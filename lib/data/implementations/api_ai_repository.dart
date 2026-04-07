import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/env_config.dart';
import '../../domain/models/magic_idea_chat_model.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../services/local_storage_service.dart';

class ApiAiRepository implements AiRepository {
  static const String _edSystemPrompt = '''
You are Ed, a product idea coach.

Behavior rules:
1) First identify intent:
   - "I have an idea but do not know what to do"
   - "I have a partial idea and want to improve it"
2) Start discovery with 1-3 concise, high-impact clarifying questions per turn.
3) Do not repeat answered questions.
4) Keep replies practical and organized.
5) Use one canonical template for all models.
6) Always append a machine-readable state block between tags.

Canonical idea template keys:
- title
- problemStatement
- targetUsers
- solutionSummary
- keyFeatures (list)
- businessModel
- launchPlan
- risks (list)
- nextSteps (list)
- status
- overview
- details
- attachments (list)

Protocol (always append exactly once):
<ED_STATE>{
  "readyToPublish": boolean,
  "missingFields": ["..."],
  "ideaTemplate": {
    "title": "...",
    "problemStatement": "...",
    "targetUsers": "...",
    "solutionSummary": "...",
    "keyFeatures": ["..."],
    "businessModel": "...",
    "launchPlan": "...",
    "risks": ["..."],
    "nextSteps": ["..."],
    "status": "Generated",
    "overview": "...",
    "details": "...",
    "attachments": [],
    "category": "General",
    "priority": "Medium"
  }
}</ED_STATE>

Set readyToPublish=true only when all canonical keys are complete.
If fields are missing, ask 1-3 focused questions and list missingFields.
''';

  static const List<String> _requiredTemplateKeys = [
    'title',
    'problemStatement',
    'targetUsers',
    'solutionSummary',
    'keyFeatures',
    'businessModel',
    'launchPlan',
    'risks',
    'nextSteps',
    'status',
    'overview',
    'details',
  ];

  @override
  Future<String> generateResponse(List<ChatMessage> history, String modelName) async {
    if (history.isEmpty) return "";

    final normalized = modelName.toLowerCase();
    final attempted = <String>{};
    final queue = <Future<String> Function()>[];

    void addAttempt(String key, Future<String> Function() attempt) {
      if (attempted.add(key)) {
        queue.add(attempt);
      }
    }

    // Try the selected provider first, then fail over to the others.
    if (normalized.contains('gemini')) {
      addAttempt('gemini', () => _generateGeminiResponse(history));
    } else if (normalized.contains('mercury')) {
      addAttempt('mercury', () => _generateMercuryResponse(history));
    } else {
      addAttempt('openai', () => _generateOpenAiCompatibleResponse(history, normalized));
    }

    addAttempt('gemini', () => _generateGeminiResponse(history));
    addAttempt('mercury', () => _generateMercuryResponse(history));
    addAttempt('openai', () => _generateOpenAiCompatibleResponse(history, normalized));

    Object? lastError;
    for (final attempt in queue) {
      try {
        return await attempt();
      } catch (e) {
        lastError = e;
      }
    }

    return _generateFallbackResponse(
      history,
      modelName,
      lastError: lastError,
    );
  }

  Future<String> _generateGeminiResponse(List<ChatMessage> history) async {
    final geminiKey = EnvConfig.geminiApiKey;
    if (geminiKey == null) {
      throw Exception('Missing GEMINI_API_KEY');
    }

    const geminiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
    final uri = Uri.parse('$geminiUrl?key=$geminiKey');

    final contents = history.map((msg) {
      return {
        "role": msg.isUser ? "user" : "model",
        "parts": [
          {"text": msg.text}
        ]
      };
    }).toList();

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "systemInstruction": {
          "parts": [
            {"text": _edSystemPrompt}
          ]
        },
        "contents": contents,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return _extractGeminiText(jsonResponse);
    } else {
      throw Exception('Gemini HTTP Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<String> _generateOpenAiCompatibleResponse(
    List<ChatMessage> history,
    String normalizedModelName,
  ) async {
    final openAiKey = EnvConfig.openAiApiKey ?? EnvConfig.mercuryApiKey;
    if (openAiKey == null) {
      throw Exception('Missing OPENAI_API_KEY/MERCURY_API_KEY');
    }

    final openAiUrl = EnvConfig.openAiBaseUrl;
    final messages = _toOpenAiMessages(history);

    final model = _mapUiModelToOpenAiModel(normalizedModelName);

    final response = await http.post(
      Uri.parse(openAiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAiKey'
      },
      body: jsonEncode({
        "model": model,
        "messages": [
          {"role": "system", "content": _edSystemPrompt},
          ...messages,
        ],
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return _extractOpenAiText(jsonResponse);
    } else {
      throw Exception('OpenAI HTTP Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<String> _generateMercuryResponse(List<ChatMessage> history) async {
    final mercuryKey = EnvConfig.mercuryApiKey;
    if (mercuryKey == null) {
      throw Exception('Missing MERCURY_API_KEY');
    }

    final mercuryUrl = EnvConfig.mercuryBaseUrl;
    final messages = _toOpenAiMessages(history);

    final response = await http.post(
      Uri.parse(mercuryUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $mercuryKey',
      },
      body: jsonEncode({
        "model": EnvConfig.mercuryModel,
        "messages": [
          {"role": "system", "content": _edSystemPrompt},
          ...messages,
        ],
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return _extractOpenAiText(jsonResponse);
    } else {
      throw Exception('Mercury HTTP Error: ${response.statusCode} - ${response.body}');
    }
  }

  String _mapUiModelToOpenAiModel(String normalizedModelName) {
    if (normalizedModelName.contains('gpt')) {
      return EnvConfig.openAiModel;
    }
    if (normalizedModelName.contains('claude')) {
      return EnvConfig.openAiModel;
    }
    if (normalizedModelName.contains('mercury')) {
      return EnvConfig.mercuryModel;
    }
    if (normalizedModelName.contains('perplexity')) {
      return EnvConfig.openAiModel;
    }

    return EnvConfig.openAiModel;
  }

  List<Map<String, dynamic>> _toOpenAiMessages(List<ChatMessage> history) {
    return history
        .map(
          (msg) => {
            "role": msg.isUser ? "user" : "assistant",
            "content": msg.text,
          },
        )
        .toList();
  }

  String _extractGeminiText(Map<String, dynamic> jsonResponse) {
    final candidates = jsonResponse['candidates'];
    if (candidates is List && candidates.isNotEmpty) {
      final first = candidates.first;
      if (first is Map<String, dynamic>) {
        final content = first['content'];
        if (content is Map<String, dynamic>) {
          final parts = content['parts'];
          if (parts is List) {
            final text = parts
                .whereType<Map<String, dynamic>>()
                .map((p) => p['text'])
                .whereType<String>()
                .join('\n')
                .trim();
            if (text.isNotEmpty) return text;
          }
        }
      }
    }

    final promptFeedback = jsonResponse['promptFeedback'];
    if (promptFeedback is Map<String, dynamic>) {
      final blockReason = promptFeedback['blockReason'];
      if (blockReason != null) {
        throw Exception('Gemini blocked response: $blockReason');
      }
    }

    return 'No response generated.';
  }

  String _extractOpenAiText(Map<String, dynamic> jsonResponse) {
    final choices = jsonResponse['choices'];
    if (choices is List && choices.isNotEmpty) {
      final first = choices.first;
      if (first is Map<String, dynamic>) {
        final message = first['message'];
        if (message is Map<String, dynamic>) {
          final content = message['content'];
          if (content is String && content.trim().isNotEmpty) {
            return content;
          }
          if (content is List) {
            final joined = content
                .whereType<Map<String, dynamic>>()
                .map((part) => part['text'])
                .whereType<String>()
                .join('\n')
                .trim();
            if (joined.isNotEmpty) return joined;
          }
        }
      }
    }

    final outputText = jsonResponse['output_text'];
    if (outputText is String && outputText.trim().isNotEmpty) {
      return outputText;
    }

    return 'No response generated.';
  }

  Future<String> _generateFallbackResponse(
    List<ChatMessage> history,
    String modelName,
    {Object? lastError,}
  ) async {
    final latestUserMessage = history.lastWhere(
      (m) => m.isUser,
      orElse: () => history.last,
    );

    final template = _buildTemplateDraft(latestUserMessage.text);
    final missingFields = _missingFields(template);
    final readyToPublish = missingFields.isEmpty;

    final providerHint = _providerHint(lastError, modelName);
    final questions = _questionsForMissing(missingFields);
    final state = {
      'readyToPublish': readyToPublish,
      'missingFields': missingFields,
      'ideaTemplate': template,
    };

    final response = StringBuffer()
      ..writeln('I could not reach the $modelName provider right now, but I can continue as Ed.')
      ..writeln(providerHint)
      ..writeln()
      ..write(questions);

    return '${response.toString().trim()}\n\n<ED_STATE>${jsonEncode(state)}</ED_STATE>';
  }

  String _providerHint(Object? error, String modelName) {
    final raw = error?.toString() ?? '';
    final lower = raw.toLowerCase();
    final isMercury = modelName.toLowerCase().contains('mercury');

    if (lower.contains('missing') && lower.contains('api_key')) {
      return 'Please add the API key for $modelName in .env and restart the app.';
    }

    if (lower.contains('401') || lower.contains('invalid_api_key')) {
      if (isMercury) {
        return 'Mercury auth failed. Verify MERCURY_API_KEY and MERCURY_BASE_URL in .env, then restart the app.';
      }
      return 'Your API key appears invalid for $modelName. Update it in .env and try again.';
    }

    if (lower.contains('404') || lower.contains('not found')) {
      return 'The configured endpoint/model for $modelName was not found. Check .env base URL and model name.';
    }

    if (lower.contains('http error')) {
      return 'The provider returned an HTTP error. Please check provider URL, model, and key in .env.';
    }

    return 'I will keep helping with structured questions while the provider is unavailable.';
  }

  Map<String, dynamic> _buildTemplateDraft(String input) {
    final cleaned = input.trim();
    final words = cleaned.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final title = words.take(6).join(' ');

    return {
      'title': title.isEmpty ? 'Untitled Idea' : title,
      'problemStatement': '',
      'targetUsers': '',
      'solutionSummary': cleaned,
      'keyFeatures': <String>[],
      'businessModel': '',
      'launchPlan': '',
      'risks': <String>[],
      'nextSteps': <String>[],
      'status': 'Generated',
      'overview': cleaned,
      'details': '',
      'attachments': <String>[],
      'category': 'General',
      'priority': 'Medium',
    };
  }

  List<String> _missingFields(Map<String, dynamic> template) {
    final missing = <String>[];
    for (final key in _requiredTemplateKeys) {
      final value = template[key];
      if (value is String) {
        if (value.trim().isEmpty) missing.add(key);
      } else if (value is List) {
        final nonEmpty = value.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
        if (nonEmpty.isEmpty) missing.add(key);
      } else {
        missing.add(key);
      }
    }
    return missing;
  }

  String _questionsForMissing(List<String> missingFields) {
    if (missingFields.isEmpty) {
      return 'Everything is complete. You can publish now.';
    }

    final prompts = <String>[];
    for (final field in missingFields.take(3)) {
      switch (field) {
        case 'problemStatement':
          prompts.add('- What exact problem are we solving?');
          break;
        case 'targetUsers':
          prompts.add('- Who are the primary users?');
          break;
        case 'keyFeatures':
          prompts.add('- What are the top 3 key features?');
          break;
        case 'businessModel':
          prompts.add('- How will this idea make money?');
          break;
        case 'launchPlan':
          prompts.add('- What is your launch plan and timeline?');
          break;
        case 'risks':
          prompts.add('- What are the biggest risks?');
          break;
        case 'nextSteps':
          prompts.add('- What are the next concrete steps this week?');
          break;
        case 'status':
          prompts.add('- What is the current status: To-do, In Progress, Completed, or Generated?');
          break;
        case 'overview':
          prompts.add('- Give a short overview in 2-4 sentences.');
          break;
        case 'details':
          prompts.add('- Provide the full detailed plan/specification for implementation.');
          break;
        default:
          prompts.add('- Please provide $field.');
      }
    }

    return 'To finalize your idea, I still need:\n${prompts.join('\n')}';
  }

  @override
  Future<List<MagicIdeaChatModel>> getChatHistory() async {
    return await LocalStorageService.loadChatHistory() ?? [];
  }

  @override
  Future<void> saveChatHistory(List<MagicIdeaChatModel> history) async {
    await LocalStorageService.saveChatHistory(history);
  }
}

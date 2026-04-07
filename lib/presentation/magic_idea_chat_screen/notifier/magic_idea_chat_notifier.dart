import 'package:flutter/material.dart';
import 'package:ai_idea_generator/domain/models/project_card_model.dart';
import 'package:ai_idea_generator/domain/models/magic_idea_chat_model.dart';
import 'package:ai_idea_generator/domain/repositories/ai_repository.dart';
import 'package:ai_idea_generator/domain/repositories/idea_repository.dart';
import 'package:ai_idea_generator/domain/repositories/project_repository.dart';
import 'package:ai_idea_generator/domain/models/ideas_dashboard_model.dart';
import 'package:ai_idea_generator/core/providers/repository_providers.dart';
import 'package:ai_idea_generator/presentation/ideas_dashboard_screen/notifier/ideas_dashboard_notifier.dart';
import 'package:ai_idea_generator/presentation/project_explore_dashboard_screen/notifier/project_explore_dashboard_notifier.dart';
import '../../../core/app_export.dart';
import 'dart:convert';

part 'magic_idea_chat_state.dart';

final magicIdeaChatNotifier =
    StateNotifierProvider<MagicIdeaChatNotifier, MagicIdeaChatState>(
      (ref) => MagicIdeaChatNotifier(
        MagicIdeaChatState(magicIdeaChatModel: MagicIdeaChatModel()),
        ref,
        ref.read(aiRepositoryProvider),
        ref.read(ideaRepositoryProvider),
        ref.read(projectRepositoryProvider),
      ),
    );

class MagicIdeaChatNotifier extends StateNotifier<MagicIdeaChatState> {
  final Ref _ref;
  final AiRepository _repository;
  final IdeaRepository _ideaRepository;
  final ProjectRepository _projectRepository;

  MagicIdeaChatNotifier(
    MagicIdeaChatState state,
    this._ref,
    this._repository,
    this._ideaRepository,
    this._projectRepository,
  )
      : super(state) {
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    final chats = await _repository.getChatHistory();
    state = state.copyWith(isLoading: false, chatHistory: chats);
  }

  // Persists and updates state in one call.
  void _updateHistory(List<MagicIdeaChatModel> updatedHistory) {
    state = state.copyWith(chatHistory: updatedHistory, isLoading: false);
    _repository.saveChatHistory(updatedHistory);
  }

  void startNewChat() {
    state = state.copyWith(currentChatId: null);
  }

  Future<void> _processAIRequest({required String chatId}) async {
    state = state.copyWith(isLoading: true);
    try {
      final currentModel = state.selectedAiModel ?? 'Gemini';
      
      final currentHistory = state.chatHistory ?? [];
      final activeChat = currentHistory.firstWhere((c) => c.id == chatId);
      final messagesToPass = activeChat.messages ?? [];
      
      final responseText = await _repository.generateResponse(
        messagesToPass,
        currentModel,
      );
      if (!mounted) return;

      final updatedHistory = List<MagicIdeaChatModel>.from(state.chatHistory ?? []);
      final index = updatedHistory.indexWhere((c) => c.id == chatId);
      if (index != -1) {
        final parsed = _extractIdeaProtocol(responseText);
        final aiMessageId = DateTime.now().millisecondsSinceEpoch.toString();
        final visibleResponse = parsed.visibleText;
        final safeResponse = visibleResponse.trim().isEmpty
            ? 'I could not generate a response this time. Please try again.'
            : visibleResponse;
        final aiChatMessage = ChatMessage(
          id: aiMessageId,
          text: safeResponse,
          isUser: false,
          timestamp: DateTime.now(),
        );
        final existingChat = updatedHistory[index];
        final updatedMessages = List<ChatMessage>.from(existingChat.messages ?? [])..add(aiChatMessage);
        
        updatedHistory[index] = existingChat.copyWith(
          status: 'Done',
          statusColor: const Color(0xFF1DE4A2),
          messages: updatedMessages,
          aiModelUsed: currentModel,
          readyToPublish: parsed.ideaState.readyToPublish,
          missingFields: parsed.ideaState.missingFields,
          ideaTemplate: parsed.ideaState.ideaTemplate ?? existingChat.ideaTemplate,
          isPublished: parsed.ideaState.readyToPublish
              ? (existingChat.isPublished ?? false)
              : false,
          errorMessage: null,
        );

        _updateHistory(updatedHistory);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      if (!mounted) return;
      final updatedHistory = List<MagicIdeaChatModel>.from(state.chatHistory ?? []);
      final index = updatedHistory.indexWhere((c) => c.id == chatId);
      if (index != -1) {
        final errorText = 'I hit an error while generating a response. Please try again.';
        final aiMessageId = DateTime.now().millisecondsSinceEpoch.toString();
        final aiErrorMessage = ChatMessage(
          id: aiMessageId,
          text: errorText,
          isUser: false,
          timestamp: DateTime.now(),
        );
        final existingChat = updatedHistory[index];
        final updatedMessages = List<ChatMessage>.from(existingChat.messages ?? [])
          ..add(aiErrorMessage);
        updatedHistory[index] = updatedHistory[index].copyWith(
          status: 'Failed',
          statusColor: const Color(0xFFFF3B30),
          errorMessage: e.toString(),
          messages: updatedMessages,
        );
        _updateHistory(updatedHistory);
      } else {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  void sendMessage(String message) {
    if (state.isLoading ?? false) return;
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    final userMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    final userChatMessage = ChatMessage(
      id: userMessageId,
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    String targetChatId;
    List<MagicIdeaChatModel> updatedHistory = List.from(state.chatHistory ?? []);

    if (state.currentChatId == null) {
      targetChatId = DateTime.now().millisecondsSinceEpoch.toString();
      final newChat = MagicIdeaChatModel(
        id: targetChatId,
        title: trimmed.length > 20 ? '${trimmed.substring(0, 20)}...' : trimmed,
        description: trimmed,
        status: 'Thinking...',
        statusColor: const Color(0xFFFBD060),
        messages: [userChatMessage],
      );
      updatedHistory = [newChat, ...updatedHistory];
    } else {
      targetChatId = state.currentChatId!;
      final index = updatedHistory.indexWhere((c) => c.id == targetChatId);
      if (index != -1) {
        final existingChat = updatedHistory[index];
        final updatedMessages = List<ChatMessage>.from(existingChat.messages ?? [])..add(userChatMessage);
        updatedHistory[index] = existingChat.copyWith(
          status: 'Thinking...',
          statusColor: const Color(0xFFFBD060),
          messages: updatedMessages,
          readyToPublish: false,
          isPublished: false,
        );
      }
    }

    state = state.copyWith(currentChatId: targetChatId);
    _updateHistory(updatedHistory);
    _processAIRequest(chatId: targetChatId);
  }

  void addImageToChat(String imagePath) {
    if (state.isLoading ?? false) return;
    sendMessage("Evaluate this uploaded image... (Attachment)");
    // TODO: implement actual image parsing logic with multi-modal APIs
  }

  void addVoiceMessage(String voicePath) {
    if (state.isLoading ?? false) return;
    sendMessage("Transcribe and interpret this audio... (Attachment)");
    // TODO: implement actual voice logic
  }

  void selectChat(String chatId) {
    state = state.copyWith(currentChatId: chatId);
  }

  void updateAiModel(String model) {
    state = state.copyWith(selectedAiModel: model);
  }

  Future<bool> publishCurrentChat({
    String? selectedCategory,
    String? selectedPriority,
    String? selectedStatus,
    String? selectedBackgroundImage,
    bool useSystemStatus = true,
  }) async {
    if (state.isLoading ?? false) return false;

    final chatId = state.currentChatId;
    if (chatId == null) return false;

    final history = List<MagicIdeaChatModel>.from(state.chatHistory ?? []);
    final index = history.indexWhere((c) => c.id == chatId);
    if (index == -1) return false;

    final chat = history[index];
    final template = chat.ideaTemplate;
    if (template == null || !(chat.readyToPublish ?? false)) {
      _appendAssistantMessage(
        chatId,
        _missingFieldsPrompt(chat.missingFields ?? const []),
      );
      return false;
    }

    if (chat.isPublished == true) {
      _appendAssistantMessage(
        chatId,
        'This idea is already published to Home and Explore.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true);

    final baseId = DateTime.now().millisecondsSinceEpoch.toString();
    final resolvedCategory =
        (selectedCategory ?? _readString(template, ['category']) ?? 'General')
            .trim();
    final resolvedPriority = _normalizePriorityLabel(
      selectedPriority ?? _readString(template, ['priority']),
    );
    final resolvedStatus = useSystemStatus
        ? _resolveSystemStatus(template)
        : _normalizeStatusLabel(selectedStatus, fallback: 'Generated');
    final resolvedBackgroundImage = _resolveBackgroundImageValue(
      selectedBackgroundImage,
    );

    final ideaDraft = _buildIdeaFromTemplate(
      template,
      baseId,
      category: resolvedCategory.isEmpty ? 'General' : resolvedCategory,
      priority: resolvedPriority,
      status: resolvedStatus,
      backgroundImage: resolvedBackgroundImage,
    );
    final projectDraft = _buildProjectFromTemplate(
      template,
      baseId,
      category: resolvedCategory.isEmpty ? 'General' : resolvedCategory,
      priority: resolvedPriority,
      status: resolvedStatus,
      backgroundImage: resolvedBackgroundImage,
    );

    IdeaCardModel? createdIdea;
    ProjectCardModel? createdProject;
    String? ideaError;
    String? projectError;

    try {
      createdIdea = await _ideaRepository.createIdea(ideaDraft);
      _ref.read(ideasDashboardNotifier.notifier).insertGeneratedIdea(createdIdea);
    } catch (e) {
      ideaError = e.toString();
    }

    try {
      createdProject = await _projectRepository.createProject(projectDraft);
      _ref.read(projectExploreDashboardNotifier.notifier).insertGeneratedProject(createdProject);
    } catch (e) {
      projectError = e.toString();
    }

    if (!mounted) return false;

    final updatedHistory = List<MagicIdeaChatModel>.from(state.chatHistory ?? []);
    final currentIndex = updatedHistory.indexWhere((c) => c.id == chatId);
    if (currentIndex == -1) {
      state = state.copyWith(isLoading: false);
      return false;
    }

    final current = updatedHistory[currentIndex];
    final succeeded = createdIdea != null || createdProject != null;
    final fullyPublished = createdIdea != null && createdProject != null;

    final publishNote = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _buildPublishResultMessage(
        createdIdea: createdIdea,
        createdProject: createdProject,
        ideaError: ideaError,
        projectError: projectError,
      ),
      isUser: false,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<ChatMessage>.from(current.messages ?? [])
      ..add(publishNote);

    updatedHistory[currentIndex] = current.copyWith(
      messages: updatedMessages,
      status: succeeded ? 'Done' : 'Failed',
      statusColor: succeeded
          ? const Color(0xFF1DE4A2)
          : const Color(0xFFFF3B30),
      isPublished: fullyPublished,
      errorMessage: !succeeded
          ? 'Publish failed: ${ideaError ?? projectError ?? 'Unknown error'}'
          : null,
    );

    _updateHistory(updatedHistory);
    return fullyPublished;
  }

  _ParsedIdeaProtocol _extractIdeaProtocol(String raw) {
    const protocols = [
      ['<ED_STATE>', '</ED_STATE>'],
      ['<IDEA_STATE>', '</IDEA_STATE>'],
    ];

    for (final protocol in protocols) {
      final startTag = protocol[0];
      final endTag = protocol[1];
      final start = raw.indexOf(startTag);
      final end = raw.indexOf(endTag);

      if (start == -1 || end == -1 || end <= start) {
        continue;
      }

      final jsonRaw = raw.substring(start + startTag.length, end).trim();
      final visible =
          (raw.substring(0, start) + raw.substring(end + endTag.length)).trim();

      try {
        final decoded = jsonDecode(jsonRaw);
        if (decoded is Map) {
          final parsed = decoded.map(
            (key, value) => MapEntry(key.toString(), value),
          );
          return _ParsedIdeaProtocol(
            visibleText: visible,
            ideaState: _IdeaPublishState.fromJson(parsed),
          );
        }
      } catch (_) {
        // Keep trying fallback protocol tags.
      }
    }

    return _ParsedIdeaProtocol(
      visibleText: raw,
      ideaState: const _IdeaPublishState(),
    );
  }

  String? _readString(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  List<String> _readStringList(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is List) {
        final parsed = value
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (parsed.isNotEmpty) return parsed;
      }
      if (value is String && value.trim().isNotEmpty) {
        return value
            .split(RegExp(r'[\n,;]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }
    return const [];
  }

  IdeaCardModel _buildIdeaFromTemplate(
    Map<String, dynamic> template,
    String id, {
    required String category,
    required String priority,
    required String status,
    required String backgroundImage,
  }) {
    final title = _readString(template, ['title', 'ideaTitle']) ?? 'Untitled Idea';
    final description = _readString(template, ['solutionSummary', 'description']) ??
        'No description provided.';

    return IdeaCardModel(
      id: 'idea_$id',
      title: title,
      description: description,
      category: category,
      priority: priority,
      status: status,
      backgroundImage: backgroundImage,
      teamMembers: const [],
      additionalMembersCount: '0',
      timestamp: DateTime.now(),
    );
  }

  ProjectCardModel _buildProjectFromTemplate(
    Map<String, dynamic> template,
    String id, {
    required String category,
    required String priority,
    required String status,
    required String backgroundImage,
  }) {
    final title = _readString(template, ['title', 'ideaTitle']) ?? 'Untitled Project';
    final summary =
        _readString(template, ['solutionSummary', 'description']) ??
            'No description provided.';
    final features = _readStringList(template, ['keyFeatures', 'coreFeatures']);
    final description = features.isEmpty
        ? summary
        : '$summary\n\nKey Features: ${features.join(', ')}';

    return ProjectCardModel(
      id: 'project_$id',
      title: title,
      description: description,
      backgroundImage: backgroundImage,
      primaryChip: category,
      priorityChip: priority,
      avatarImages: const [],
      teamCount: 0,
      statusText: status,
      statusIcon: '',
      actionIcon: '',
      isSaved: false,
      comments: const [],
    );
  }

  String _resolveSystemStatus(Map<String, dynamic> template) {
    final statusCandidate = _readString(
      template,
      const ['status', 'state', 'workflowState'],
    );
    return _normalizeStatusLabel(statusCandidate, fallback: 'Generated');
  }

  String _normalizePriorityLabel(String? raw) {
    final value = (raw ?? '').trim().toLowerCase();
    if (value.isEmpty) return 'Medium';
    if (value.contains('urgent') ||
        value.contains('critical') ||
        value.contains('high')) {
      return 'High';
    }
    if (value.contains('low')) {
      return 'Low';
    }
    if (value.contains('mid') || value.contains('medium')) {
      return 'Medium';
    }
    return 'Medium';
  }

  String _normalizeStatusLabel(String? raw, {required String fallback}) {
    final value = (raw ?? '').trim().toLowerCase();
    if (value.isEmpty) return fallback;

    if (value.contains('in progress') ||
        value.contains('in-process') ||
        value.contains('in process') ||
        value.contains('thinking') ||
        value.contains('ongoing') ||
        value.contains('working')) {
      return 'In Progress';
    }

    if (value == 'todo' || value == 'to do' || value == 'to-do') {
      return 'To-do';
    }

    if (value.contains('done') ||
        value.contains('complete') ||
        value.contains('finished')) {
      return 'Completed';
    }

    if (value.contains('generated') || value.contains('new')) {
      return 'Generated';
    }

    return fallback;
  }

  String _resolveBackgroundImageValue(String? raw) {
    final input = (raw ?? '').trim();
    if (input.isEmpty) return ImageConstant.imgRectangle29250x400;

    if (input.toLowerCase().startsWith('color:')) {
      final hex = _normalizeHexColor(input.substring('color:'.length));
      if (hex != null) return 'color:$hex';
    }

    final directHex = _normalizeHexColor(input);
    if (directHex != null) {
      return 'color:$directHex';
    }

    return input;
  }

  String? _normalizeHexColor(String value) {
    final trimmed = value.trim().replaceAll('#', '');
    final isValid = RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(trimmed);
    if (!isValid) return null;
    return '#${trimmed.toUpperCase()}';
  }

  String _missingFieldsPrompt(List<String> missingFields) {
    if (missingFields.isEmpty) {
      return 'This idea is not ready to publish yet. Ask Ed to complete the template.';
    }

    final formatted = missingFields
        .map(_humanizeField)
        .toSet()
        .join(', ');
    return 'Before publishing, please complete: $formatted.';
  }

  String _humanizeField(String key) {
    final normalized = key.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (m) => '${m.group(1)} ${m.group(2)}',
    );
    return normalized.replaceAll('_', ' ').trim();
  }

  String _buildPublishResultMessage({
    IdeaCardModel? createdIdea,
    ProjectCardModel? createdProject,
    String? ideaError,
    String? projectError,
  }) {
    if (createdIdea != null && createdProject != null) {
      return 'Published successfully to Home and Explore. Idea: "${createdIdea.title}".';
    }

    if (createdIdea != null && createdProject == null) {
      return 'Published to Home, but Explore publish failed. Error: ${projectError ?? 'Unknown error'}.';
    }

    if (createdIdea == null && createdProject != null) {
      return 'Published to Explore, but Home publish failed. Error: ${ideaError ?? 'Unknown error'}.';
    }

    return 'Publish failed for Home and Explore. Please try again.';
  }

  void _appendAssistantMessage(String chatId, String text) {
    final updatedHistory = List<MagicIdeaChatModel>.from(state.chatHistory ?? []);
    final index = updatedHistory.indexWhere((c) => c.id == chatId);
    if (index == -1) return;

    final current = updatedHistory[index];
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    );

    updatedHistory[index] = current.copyWith(
      messages: [...(current.messages ?? []), msg],
      status: 'Done',
      statusColor: const Color(0xFF1DE4A2),
    );
    _updateHistory(updatedHistory);
  }
}

class _ParsedIdeaProtocol {
  final String visibleText;
  final _IdeaPublishState ideaState;

  const _ParsedIdeaProtocol({
    required this.visibleText,
    required this.ideaState,
  });
}

class _IdeaPublishState {
  final bool readyToPublish;
  final List<String> missingFields;
  final Map<String, dynamic>? ideaTemplate;

  const _IdeaPublishState({
    this.readyToPublish = false,
    this.missingFields = const [],
    this.ideaTemplate,
  });

  factory _IdeaPublishState.fromJson(Map<String, dynamic> json) {
    final template = json['ideaTemplate'];
    final parsedTemplate = template is Map
        ? template.map((key, value) => MapEntry(key.toString(), value))
        : null;

    return _IdeaPublishState(
      readyToPublish: json['readyToPublish'] == true,
      missingFields: (json['missingFields'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      ideaTemplate: parsedTemplate,
    );
  }
}

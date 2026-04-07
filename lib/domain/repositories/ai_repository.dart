import '../../domain/models/magic_idea_chat_model.dart';

/// Contract defining AI generation and chat history operations.
abstract class AiRepository {
  /// Sends [history] to the AI [modelName] and returns the text response.
  Future<String> generateResponse(List<ChatMessage> history, String modelName);

  /// Loads persisted chat history (local cache or remote).
  Future<List<MagicIdeaChatModel>> getChatHistory();

  /// Persists the full [history] list.
  Future<void> saveChatHistory(List<MagicIdeaChatModel> history);
}

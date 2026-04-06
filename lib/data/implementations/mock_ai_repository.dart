import '../../domain/models/magic_idea_chat_model.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../services/mock_ai_service.dart';
import '../../services/local_storage_service.dart';
import '../../data/repositories/mock_repository.dart';

/// Mock implementation of [AiRepository].
///
/// Uses [MockAIService] for response generation and [LocalStorageService]
/// for chat history persistence.
/// Replace with [GeminiAiRepository] or [OpenAIRepository] when ready.
class MockAiRepository implements AiRepository {
  @override
  Future<String> generateResponse(String prompt, String modelName) {
    return MockAIService.generateMockResponse(prompt, modelName);
  }

  @override
  Future<List<MagicIdeaChatModel>> getChatHistory() async {
    return await LocalStorageService.loadChatHistory() ?? MockRepository.mockChats;
  }

  @override
  Future<void> saveChatHistory(List<MagicIdeaChatModel> history) {
    return LocalStorageService.saveChatHistory(history);
  }
}

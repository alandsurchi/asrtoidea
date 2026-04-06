import 'package:flutter/material.dart';
import 'package:ai_idea_generator/domain/models/magic_idea_chat_model.dart';
import 'package:ai_idea_generator/domain/repositories/ai_repository.dart';
import 'package:ai_idea_generator/core/providers/repository_providers.dart';
import '../../../core/app_export.dart';

part 'magic_idea_chat_state.dart';

final magicIdeaChatNotifier =
    StateNotifierProvider<MagicIdeaChatNotifier, MagicIdeaChatState>(
      (ref) => MagicIdeaChatNotifier(
        MagicIdeaChatState(magicIdeaChatModel: MagicIdeaChatModel()),
        ref.read(aiRepositoryProvider),
      ),
    );

class MagicIdeaChatNotifier extends StateNotifier<MagicIdeaChatState> {
  final AiRepository _repository;

  MagicIdeaChatNotifier(MagicIdeaChatState state, this._repository)
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
    state = state.copyWith(currentChatId: null, selectedAiModel: 'Gemini');
  }

  Future<void> _processAIRequest({
    required String chatId,
    required String promptInput,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final currentModel = state.selectedAiModel ?? 'Gemini';
      final responseText = await _repository.generateResponse(promptInput, currentModel);
      if (!mounted) return;

      final updatedHistory = List<MagicIdeaChatModel>.from(state.chatHistory ?? []);
      final index = updatedHistory.indexWhere((c) => c.id == chatId);
      if (index != -1) {
        updatedHistory[index] = updatedHistory[index].copyWith(
          status: 'Done',
          statusColor: const Color(0xFF1DE4A2),
          aiResponse: responseText,
          aiModelUsed: currentModel,
        );
        _updateHistory(updatedHistory);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (_) {
      if (!mounted) return;
      final updatedHistory = List<MagicIdeaChatModel>.from(state.chatHistory ?? []);
      final index = updatedHistory.indexWhere((c) => c.id == chatId);
      if (index != -1) {
        updatedHistory[index] = updatedHistory[index].copyWith(
          status: 'Failed',
          statusColor: const Color(0xFFFF3B30),
          errorMessage: 'Something went wrong generating the response.',
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

    final newChatId = DateTime.now().millisecondsSinceEpoch.toString();
    final newChat = MagicIdeaChatModel(
      id: newChatId,
      title: trimmed.length > 20 ? '${trimmed.substring(0, 20)}...' : trimmed,
      description: trimmed,
      status: 'Thinking...',
      statusColor: const Color(0xFFFBD060),
    );
    final updatedHistory = [newChat, ...state.chatHistory ?? <MagicIdeaChatModel>[]];
    state = state.copyWith(currentChatId: newChatId);
    _updateHistory(updatedHistory);
    _processAIRequest(chatId: newChatId, promptInput: trimmed);
  }

  void addImageToChat(String imagePath) {
    if (state.isLoading ?? false) return;
    final newChatId = DateTime.now().millisecondsSinceEpoch.toString();
    final newChat = MagicIdeaChatModel(
      id: newChatId,
      title: 'Image Uploaded',
      description: 'User shared an image attachment.',
      imagePath: imagePath,
      status: 'Processing...',
      statusColor: const Color(0xFFFBD060),
    );
    final updatedHistory = [newChat, ...state.chatHistory ?? <MagicIdeaChatModel>[]];
    state = state.copyWith(currentChatId: newChatId);
    _updateHistory(updatedHistory);
    _processAIRequest(chatId: newChatId, promptInput: 'evaluate this newly uploaded image');
  }

  void addVoiceMessage(String voicePath) {
    if (state.isLoading ?? false) return;
    final newChatId = DateTime.now().millisecondsSinceEpoch.toString();
    final newChat = MagicIdeaChatModel(
      id: newChatId,
      title: 'Voice Note',
      description: 'User submitted a voice recording.',
      voicePath: voicePath,
      status: 'Listening...',
      statusColor: const Color(0xFFFBD060),
    );
    final updatedHistory = [newChat, ...state.chatHistory ?? <MagicIdeaChatModel>[]];
    state = state.copyWith(currentChatId: newChatId);
    _updateHistory(updatedHistory);
    _processAIRequest(chatId: newChatId, promptInput: 'transcribe and interpret this audio');
  }

  void selectChat(String chatId) {
    state = state.copyWith(currentChatId: chatId);
  }

  void updateAiModel(String model) {
    state = state.copyWith(selectedAiModel: model);
  }
}

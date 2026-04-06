part of 'magic_idea_chat_notifier.dart';

class MagicIdeaChatState extends Equatable {
  final bool? isLoading;
  final bool? isRecording;
  final String? selectedAiModel;
  final String? currentChatId;
  final List<MagicIdeaChatModel>? chatHistory;
  final MagicIdeaChatModel? magicIdeaChatModel;

  MagicIdeaChatState({
    this.isLoading = false,
    this.isRecording = false,
    this.selectedAiModel = "Gemini",
    this.currentChatId,
    this.chatHistory,
    this.magicIdeaChatModel,
  });

  @override
  List<Object?> get props => [
    isLoading,
    isRecording,
    selectedAiModel,
    currentChatId,
    chatHistory,
    magicIdeaChatModel,
  ];

  MagicIdeaChatState copyWith({
    bool? isLoading,
    bool? isRecording,
    String? selectedAiModel,
    String? currentChatId,
    List<MagicIdeaChatModel>? chatHistory,
    MagicIdeaChatModel? magicIdeaChatModel,
  }) {
    return MagicIdeaChatState(
      isLoading: isLoading ?? this.isLoading,
      isRecording: isRecording ?? this.isRecording,
      selectedAiModel: selectedAiModel ?? this.selectedAiModel,
      currentChatId: currentChatId ?? this.currentChatId,
      chatHistory: chatHistory ?? this.chatHistory,
      magicIdeaChatModel: magicIdeaChatModel ?? this.magicIdeaChatModel,
    );
  }
}

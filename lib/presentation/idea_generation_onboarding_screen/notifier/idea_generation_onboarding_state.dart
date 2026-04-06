part of 'idea_generation_onboarding_notifier.dart';

class IdeaGenerationOnboardingState extends Equatable {
  final int? currentPageIndex;
  final bool? isLoading;
  final bool? shouldNavigate;
  final IdeaGenerationOnboardingModel? ideaGenerationOnboardingModel;

  IdeaGenerationOnboardingState({
    this.currentPageIndex = 0,
    this.isLoading = false,
    this.shouldNavigate = false,
    this.ideaGenerationOnboardingModel,
  });

  @override
  List<Object?> get props => [
    currentPageIndex,
    isLoading,
    shouldNavigate,
    ideaGenerationOnboardingModel,
  ];

  IdeaGenerationOnboardingState copyWith({
    int? currentPageIndex,
    bool? isLoading,
    bool? shouldNavigate,
    IdeaGenerationOnboardingModel? ideaGenerationOnboardingModel,
  }) {
    return IdeaGenerationOnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate,
      ideaGenerationOnboardingModel:
          ideaGenerationOnboardingModel ?? this.ideaGenerationOnboardingModel,
    );
  }
}

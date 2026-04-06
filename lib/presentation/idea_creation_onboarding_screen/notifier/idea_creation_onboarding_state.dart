part of 'idea_creation_onboarding_notifier.dart';

class IdeaCreationOnboardingState extends Equatable {
  final IdeaCreationOnboardingModel? ideaCreationOnboardingModel;
  final int? currentPageIndex;
  final int? totalPages;

  IdeaCreationOnboardingState({
    this.ideaCreationOnboardingModel,
    this.currentPageIndex = 0,
    this.totalPages = 3,
  });

  @override
  List<Object?> get props => [
    ideaCreationOnboardingModel,
    currentPageIndex,
    totalPages,
  ];

  IdeaCreationOnboardingState copyWith({
    IdeaCreationOnboardingModel? ideaCreationOnboardingModel,
    int? currentPageIndex,
    int? totalPages,
  }) {
    return IdeaCreationOnboardingState(
      ideaCreationOnboardingModel:
          ideaCreationOnboardingModel ?? this.ideaCreationOnboardingModel,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

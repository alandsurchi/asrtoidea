part of 'welcome_onboarding_notifier.dart';

class WelcomeOnboardingState extends Equatable {
  final int? currentPageIndex;
  final int? totalPages;
  final bool? isLoading;
  final WelcomeOnboardingModel? welcomeOnboardingModel;

  WelcomeOnboardingState({
    this.currentPageIndex = 1,
    this.totalPages = 3,
    this.isLoading = false,
    this.welcomeOnboardingModel,
  });

  @override
  List<Object?> get props => [
    currentPageIndex,
    totalPages,
    isLoading,
    welcomeOnboardingModel,
  ];

  WelcomeOnboardingState copyWith({
    int? currentPageIndex,
    int? totalPages,
    bool? isLoading,
    WelcomeOnboardingModel? welcomeOnboardingModel,
  }) {
    return WelcomeOnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      welcomeOnboardingModel:
          welcomeOnboardingModel ?? this.welcomeOnboardingModel,
    );
  }
}

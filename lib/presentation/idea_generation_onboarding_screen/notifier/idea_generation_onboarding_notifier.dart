import 'package:ai_idea_generator/domain/models/idea_generation_onboarding_model.dart';
import '../../../core/app_export.dart';

part 'idea_generation_onboarding_state.dart';

final ideaGenerationOnboardingNotifier =
    StateNotifierProvider.autoDispose<
      IdeaGenerationOnboardingNotifier,
      IdeaGenerationOnboardingState
    >(
      (ref) => IdeaGenerationOnboardingNotifier(
        IdeaGenerationOnboardingState(
          ideaGenerationOnboardingModel: IdeaGenerationOnboardingModel(),
        ),
      ),
    );

class IdeaGenerationOnboardingNotifier
    extends StateNotifier<IdeaGenerationOnboardingState> {
  IdeaGenerationOnboardingNotifier(IdeaGenerationOnboardingState state)
    : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      currentPageIndex: 0,
      isLoading: false,
      shouldNavigate: false,
    );
  }

  void onNextPressed() {
    state = state.copyWith(isLoading: true);

    // Simulate brief loading for smooth transition
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        state = state.copyWith(isLoading: false, shouldNavigate: true);

        // Reset navigation flag after triggering navigation
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            state = state.copyWith(shouldNavigate: false);
          }
        });
      }
    });
  }

  void updatePageIndex(int index) {
    state = state.copyWith(currentPageIndex: index);
  }
}

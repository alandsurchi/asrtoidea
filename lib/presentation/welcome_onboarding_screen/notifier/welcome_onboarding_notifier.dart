import 'package:ai_idea_generator/domain/models/welcome_onboarding_model.dart';
import '../../../core/app_export.dart';

part 'welcome_onboarding_state.dart';

final welcomeOnboardingNotifier =
    StateNotifierProvider.autoDispose<
      WelcomeOnboardingNotifier,
      WelcomeOnboardingState
    >(
      (ref) => WelcomeOnboardingNotifier(
        WelcomeOnboardingState(
          welcomeOnboardingModel: WelcomeOnboardingModel(),
        ),
      ),
    );

class WelcomeOnboardingNotifier extends StateNotifier<WelcomeOnboardingState> {
  WelcomeOnboardingNotifier(WelcomeOnboardingState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      currentPageIndex: 1, // This is the second screen in the onboarding flow
      totalPages: 3,
      isLoading: false,
    );
  }

  void navigateToNext() {
    state = state.copyWith(currentPageIndex: state.currentPageIndex! + 1);
  }

  void updatePageIndex(int index) {
    state = state.copyWith(currentPageIndex: index);
  }
}

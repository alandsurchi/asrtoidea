import 'package:ai_idea_generator/domain/models/welcome_model.dart';
import '../../../core/app_export.dart';

part 'welcome_state.dart';

final welcomeNotifier =
    StateNotifierProvider.autoDispose<WelcomeNotifier, WelcomeState>(
      (ref) => WelcomeNotifier(WelcomeState(welcomeModel: WelcomeModel())),
    );

class WelcomeNotifier extends StateNotifier<WelcomeState> {
  WelcomeNotifier(WelcomeState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      shouldNavigate: false,
      navigateToSignIn: false,
      navigateToSignUp: false,
    );
  }

  void navigateToSignIn() {
    state = state.copyWith(
      shouldNavigate: true,
      navigateToSignIn: true,
      navigateToSignUp: false,
    );

    // Reset navigation state
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        state = state.copyWith(shouldNavigate: false, navigateToSignIn: false);
      }
    });
  }

  void navigateToSignUp() {
    state = state.copyWith(
      shouldNavigate: true,
      navigateToSignIn: false,
      navigateToSignUp: true,
    );

    // Reset navigation state
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        state = state.copyWith(shouldNavigate: false, navigateToSignUp: false);
      }
    });
  }
}

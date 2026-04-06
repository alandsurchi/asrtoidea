import 'package:ai_idea_generator/domain/models/login_model.dart';
import 'package:ai_idea_generator/core/utils/validators.dart';
import 'package:ai_idea_generator/core/errors/app_exception.dart';
import '../../../core/app_export.dart';

part 'login_state.dart';

final loginNotifier = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(LoginState(loginModel: LoginModel())),
);

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(LoginState state) : super(state);

  void updateUsername(String username) =>
      state = state.copyWith(loginModel: state.loginModel?.copyWith(username: username));

  void updatePassword(String password) =>
      state = state.copyWith(loginModel: state.loginModel?.copyWith(password: password));

  Future<void> signIn(String username, String password) async {
    // Client-side validation before any network call
    final errors = Validators.validateAll({
      'username': () => Validators.required(username, label: 'Email or username'),
      'password': () => Validators.password(password),
    });
    if (errors.isNotEmpty) {
      state = state.copyWith(loginError: errors.first, isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, loginError: null);
    try {
      await Future.delayed(const Duration(seconds: 2)); // TODO: replace with AuthRepository
      state = state.copyWith(isLoading: false, isLoginSuccess: true, loginError: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoginSuccess: false,
        loginError: appErrorMessage(e, fallback: 'Login failed. Please try again.'),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, loginError: null);
    try {
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false, isLoginSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        loginError: appErrorMessage(e, fallback: 'Google sign-in failed.'),
      );
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true, loginError: null);
    try {
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false, isLoginSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        loginError: appErrorMessage(e, fallback: 'Apple sign-in failed.'),
      );
    }
  }

  Future<void> signInWithFacebook() async {
    state = state.copyWith(isLoading: true, loginError: null);
    try {
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false, isLoginSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        loginError: appErrorMessage(e, fallback: 'Facebook sign-in failed.'),
      );
    }
  }
}

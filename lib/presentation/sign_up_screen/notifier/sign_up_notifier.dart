import 'package:ai_idea_generator/domain/models/sign_up_model.dart';
import 'package:ai_idea_generator/core/utils/validators.dart';
import 'package:ai_idea_generator/core/errors/app_exception.dart';
import '../../../core/app_export.dart';

part 'sign_up_state.dart';

final signUpNotifier = StateNotifierProvider.autoDispose<SignUpNotifier, SignUpState>(
  (ref) => SignUpNotifier(SignUpState(signUpModel: SignUpModel())),
);

class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier(SignUpState state) : super(state);

  void updateEmail(String email) =>
      state = state.copyWith(signUpModel: state.signUpModel?.copyWith(email: email));

  void updateName(String name) =>
      state = state.copyWith(signUpModel: state.signUpModel?.copyWith(name: name));

  void updatePassword(String password) =>
      state = state.copyWith(signUpModel: state.signUpModel?.copyWith(password: password));

  Future<void> signUp(String name, String email, String password) async {
    // Client-side validation before any network call
    final errors = Validators.validateAll({
      'name': () => Validators.name(name),
      'email': () => Validators.email(email),
      'password': () => Validators.password(password),
    });
    if (errors.isNotEmpty) {
      state = state.copyWith(errorMessage: errors.first, isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await Future.delayed(const Duration(seconds: 2)); // TODO: replace with AuthRepository
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: appErrorMessage(e, fallback: 'Sign up failed. Please try again.'),
      );
    }
  }
}

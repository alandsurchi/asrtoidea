part of 'login_notifier.dart';

class LoginState extends Equatable {
  final bool? isLoading;
  final bool? isLoginSuccess;
  final String? loginError;
  final LoginModel? loginModel;

  LoginState({
    this.isLoading = false,
    this.isLoginSuccess = false,
    this.loginError,
    this.loginModel,
  });

  @override
  List<Object?> get props => [isLoading, isLoginSuccess, loginError, loginModel];

  LoginState copyWith({
    bool? isLoading,
    bool? isLoginSuccess,
    String? loginError,
    LoginModel? loginModel,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      loginError: loginError ?? this.loginError,
      loginModel: loginModel ?? this.loginModel,
    );
  }
}

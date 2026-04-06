part of 'sign_up_notifier.dart';

class SignUpState extends Equatable {
  final bool? isLoading;
  final bool? isSuccess;
  final String? errorMessage;
  final SignUpModel? signUpModel;

  SignUpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.signUpModel,
  });

  @override
  List<Object?> get props => [isLoading, isSuccess, errorMessage, signUpModel];

  SignUpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    SignUpModel? signUpModel,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      signUpModel: signUpModel ?? this.signUpModel,
    );
  }
}

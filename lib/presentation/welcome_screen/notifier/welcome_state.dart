part of 'welcome_notifier.dart';

class WelcomeState extends Equatable {
  final WelcomeModel? welcomeModel;
  final bool? shouldNavigate;
  final bool? navigateToSignIn;
  final bool? navigateToSignUp;

  WelcomeState({
    this.welcomeModel,
    this.shouldNavigate = false,
    this.navigateToSignIn = false,
    this.navigateToSignUp = false,
  });

  @override
  List<Object?> get props => [
    welcomeModel,
    shouldNavigate,
    navigateToSignIn,
    navigateToSignUp,
  ];

  WelcomeState copyWith({
    WelcomeModel? welcomeModel,
    bool? shouldNavigate,
    bool? navigateToSignIn,
    bool? navigateToSignUp,
  }) {
    return WelcomeState(
      welcomeModel: welcomeModel ?? this.welcomeModel,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate,
      navigateToSignIn: navigateToSignIn ?? this.navigateToSignIn,
      navigateToSignUp: navigateToSignUp ?? this.navigateToSignUp,
    );
  }
}

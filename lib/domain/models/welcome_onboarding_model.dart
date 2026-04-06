import '../../../core/app_export.dart';

/// This class is used in the [welcome_onboarding_screen] screen.

// ignore_for_file: must_be_immutable
class WelcomeOnboardingModel extends Equatable {
  WelcomeOnboardingModel({
    this.headlineText,
    this.descriptionText,
    this.illustrationImage,
    this.buttonText,
    this.id,
  }) {
    headlineText = headlineText ?? "Wanna start one ?";
    descriptionText =
        descriptionText ??
        "try to get Our idea using AI to enhance your productivity ";
    illustrationImage = illustrationImage ?? ImageConstant.imgIllustration;
    buttonText = buttonText ?? "Next";
    id = id ?? "";
  }

  String? headlineText;
  String? descriptionText;
  String? illustrationImage;
  String? buttonText;
  String? id;

  WelcomeOnboardingModel copyWith({
    String? headlineText,
    String? descriptionText,
    String? illustrationImage,
    String? buttonText,
    String? id,
  }) {
    return WelcomeOnboardingModel(
      headlineText: headlineText ?? this.headlineText,
      descriptionText: descriptionText ?? this.descriptionText,
      illustrationImage: illustrationImage ?? this.illustrationImage,
      buttonText: buttonText ?? this.buttonText,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
    headlineText,
    descriptionText,
    illustrationImage,
    buttonText,
    id,
  ];
}

import '../../../core/app_export.dart';

/// This class is used in the [WelcomeScreen] screen.

// ignore_for_file: must_be_immutable
class WelcomeModel extends Equatable {
  WelcomeModel({
    this.welcomeTitle,
    this.welcomeMessage,
    this.illustrationImage,
    this.backgroundImage,
    this.id,
  }) {
    welcomeTitle = welcomeTitle ?? "Welcome =)";
    welcomeMessage =
        welcomeMessage ??
        "Hi there!\nwe're pleasure to see you to generate your Idea By using AI";
    illustrationImage = illustrationImage ?? ImageConstant.imgCaitiao206cai;
    backgroundImage = backgroundImage ?? ImageConstant.imgCircle6;
    id = id ?? "";
  }

  String? welcomeTitle;
  String? welcomeMessage;
  String? illustrationImage;
  String? backgroundImage;
  String? id;

  WelcomeModel copyWith({
    String? welcomeTitle,
    String? welcomeMessage,
    String? illustrationImage,
    String? backgroundImage,
    String? id,
  }) {
    return WelcomeModel(
      welcomeTitle: welcomeTitle ?? this.welcomeTitle,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      illustrationImage: illustrationImage ?? this.illustrationImage,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
    welcomeTitle,
    welcomeMessage,
    illustrationImage,
    backgroundImage,
    id,
  ];
}

import '../../../core/app_export.dart';

/// This class is used in the [IdeaGenerationOnboardingScreen] screen.

// ignore_for_file: must_be_immutable
class IdeaGenerationOnboardingModel extends Equatable {
  IdeaGenerationOnboardingModel({
    this.headingText,
    this.illustrationImage,
    this.descriptionText,
    this.totalPages,
    this.id,
  }) {
    headingText = headingText ?? "Have An Idea ?";
    illustrationImage = illustrationImage ?? ImageConstant.imgTest1;
    descriptionText =
        descriptionText ??
        "try to get Our idea using AI to enhance your productivity ";
    totalPages = totalPages ?? 3;
    id = id ?? "";
  }

  String? headingText;
  String? illustrationImage;
  String? descriptionText;
  int? totalPages;
  String? id;

  IdeaGenerationOnboardingModel copyWith({
    String? headingText,
    String? illustrationImage,
    String? descriptionText,
    int? totalPages,
    String? id,
  }) {
    return IdeaGenerationOnboardingModel(
      headingText: headingText ?? this.headingText,
      illustrationImage: illustrationImage ?? this.illustrationImage,
      descriptionText: descriptionText ?? this.descriptionText,
      totalPages: totalPages ?? this.totalPages,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
    headingText,
    illustrationImage,
    descriptionText,
    totalPages,
    id,
  ];
}

import '../../../core/app_export.dart';

/// This class is used in the [IdeaCreationOnboardingScreen] screen.

// ignore_for_file: must_be_immutable
class IdeaCreationOnboardingModel extends Equatable {
  IdeaCreationOnboardingModel({
    this.headerText,
    this.descriptionText,
    this.illustrationImage,
    this.currentPage,
    this.id,
  }) {
    headerText = headerText ?? "Let's create our Idea ...";
    descriptionText =
        descriptionText ??
        "try to get Our idea using AI to enhance your productivity ";
    illustrationImage = illustrationImage ?? ImageConstant.imgCaitiao101cai;
    currentPage = currentPage ?? 2;
    id = id ?? "";
  }

  String? headerText;
  String? descriptionText;
  String? illustrationImage;
  int? currentPage;
  String? id;

  IdeaCreationOnboardingModel copyWith({
    String? headerText,
    String? descriptionText,
    String? illustrationImage,
    int? currentPage,
    String? id,
  }) {
    return IdeaCreationOnboardingModel(
      headerText: headerText ?? this.headerText,
      descriptionText: descriptionText ?? this.descriptionText,
      illustrationImage: illustrationImage ?? this.illustrationImage,
      currentPage: currentPage ?? this.currentPage,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
    headerText,
    descriptionText,
    illustrationImage,
    currentPage,
    id,
  ];
}

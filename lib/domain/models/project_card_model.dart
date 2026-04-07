import '../../../core/app_export.dart';

/// This class is used for project card items in the project explore dashboard.

// ignore_for_file: must_be_immutable
class ProjectCardModel extends Equatable {
  ProjectCardModel({
    this.id,
    this.createdById,
    this.createdByName,
    this.title,
    this.description,
    this.backgroundImage,
    this.primaryChip,
    this.priorityChip,
    this.avatarImages,
    this.teamCount,
    this.statusText,
    this.statusIcon,
    this.actionIcon,
    this.isSaved,
    this.comments,
  }) {
    id = id ?? "";
    createdById = createdById ?? "";
    createdByName = createdByName ?? "";
    title = title ?? "";
    description = description ?? "";
    backgroundImage = backgroundImage ?? "";
    primaryChip = primaryChip ?? "";
    priorityChip = priorityChip ?? "";
    avatarImages = avatarImages ?? [];
    teamCount = teamCount ?? 0;
    statusText = statusText ?? "";
    statusIcon = statusIcon ?? "";
    actionIcon = actionIcon ?? "";
    isSaved = isSaved ?? false;
    comments = comments ?? [];
  }

  String? id;
  String? createdById;
  String? createdByName;
  String? title;
  String? description;
  String? backgroundImage;
  String? primaryChip;
  String? priorityChip;
  List<String>? avatarImages;
  int? teamCount;
  String? statusText;
  String? statusIcon;
  String? actionIcon;
  bool? isSaved;
  List<String>? comments;

  ProjectCardModel copyWith({
    String? id,
    String? createdById,
    String? createdByName,
    String? title,
    String? description,
    String? backgroundImage,
    String? primaryChip,
    String? priorityChip,
    List<String>? avatarImages,
    int? teamCount,
    String? statusText,
    String? statusIcon,
    String? actionIcon,
    bool? isSaved,
    List<String>? comments,
  }) {
    return ProjectCardModel(
      id: id ?? this.id,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      title: title ?? this.title,
      description: description ?? this.description,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      primaryChip: primaryChip ?? this.primaryChip,
      priorityChip: priorityChip ?? this.priorityChip,
      avatarImages: avatarImages ?? this.avatarImages,
      teamCount: teamCount ?? this.teamCount,
      statusText: statusText ?? this.statusText,
      statusIcon: statusIcon ?? this.statusIcon,
      actionIcon: actionIcon ?? this.actionIcon,
      isSaved: isSaved ?? this.isSaved,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdById,
    createdByName,
    title,
    description,
    backgroundImage,
    primaryChip,
    priorityChip,
    avatarImages,
    teamCount,
    statusText,
    statusIcon,
    actionIcon,
    isSaved,
    comments,
  ];

  /// Serializes to a JSON map suitable for REST or Firestore.
  Map<String, dynamic> toJson() => {
    'id': id,
    'createdById': createdById,
    'createdByName': createdByName,
    'title': title,
    'description': description,
    'backgroundImage': backgroundImage,
    'primaryChip': primaryChip,
    'priorityChip': priorityChip,
    'avatarImages': avatarImages,
    'teamCount': teamCount,
    'statusText': statusText,
    'statusIcon': statusIcon,
    'actionIcon': actionIcon,
    'isSaved': isSaved,
    'comments': comments,
  };

  /// Deserializes from a JSON map (e.g., Firestore document data).
  factory ProjectCardModel.fromJson(Map<String, dynamic> json) =>
      ProjectCardModel(
        id: json['id'] as String?,
        createdById: json['createdById'] as String?,
        createdByName: json['createdByName'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        backgroundImage: json['backgroundImage'] as String?,
        primaryChip: json['primaryChip'] as String?,
        priorityChip: json['priorityChip'] as String?,
        avatarImages: (json['avatarImages'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        teamCount: json['teamCount'] as int?,
        statusText: json['statusText'] as String?,
        statusIcon: json['statusIcon'] as String?,
        actionIcon: json['actionIcon'] as String?,
        isSaved: json['isSaved'] as bool?,
        comments: (json['comments'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );
}


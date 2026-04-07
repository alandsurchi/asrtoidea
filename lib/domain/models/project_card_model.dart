import '../../../core/app_export.dart';

/// This class is used for project card items in the project explore dashboard.

// ignore_for_file: must_be_immutable
class ProjectCardModel extends Equatable {
  ProjectCardModel({
    this.id,
    this.createdById,
    this.createdByName,
    this.createdByAvatar,
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
    this.fullContent,
    this.attachments,
    this.viewCount,
    this.likeCount,
    this.isLiked,
    this.isPublic,
    this.canEdit,
    this.createdDate,
    this.timestamp,
  }) {
    id = id ?? "";
    createdById = createdById ?? "";
    createdByName = createdByName ?? "";
    createdByAvatar = createdByAvatar ?? "";
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
    fullContent = fullContent ?? "";
    attachments = attachments ?? [];
    viewCount = viewCount ?? 0;
    likeCount = likeCount ?? 0;
    isLiked = isLiked ?? false;
    isPublic = isPublic ?? true;
    canEdit = canEdit ?? false;
    createdDate = createdDate ?? "";
    timestamp = timestamp ?? DateTime.now();
  }

  String? id;
  String? createdById;
  String? createdByName;
  String? createdByAvatar;
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
  String? fullContent;
  List<String>? attachments;
  int? viewCount;
  int? likeCount;
  bool? isLiked;
  bool? isPublic;
  bool? canEdit;
  String? createdDate;
  DateTime? timestamp;

  ProjectCardModel copyWith({
    String? id,
    String? createdById,
    String? createdByName,
    String? createdByAvatar,
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
    String? fullContent,
    List<String>? attachments,
    int? viewCount,
    int? likeCount,
    bool? isLiked,
    bool? isPublic,
    bool? canEdit,
    String? createdDate,
    DateTime? timestamp,
  }) {
    return ProjectCardModel(
      id: id ?? this.id,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      createdByAvatar: createdByAvatar ?? this.createdByAvatar,
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
      fullContent: fullContent ?? this.fullContent,
      attachments: attachments ?? this.attachments,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isPublic: isPublic ?? this.isPublic,
      canEdit: canEdit ?? this.canEdit,
      createdDate: createdDate ?? this.createdDate,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdById,
    createdByName,
    createdByAvatar,
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
    fullContent,
    attachments,
    viewCount,
    likeCount,
    isLiked,
    isPublic,
    canEdit,
    createdDate,
    timestamp,
  ];

  /// Serializes to a JSON map suitable for REST or Firestore.
  Map<String, dynamic> toJson() => {
    'id': id,
    'createdById': createdById,
    'createdByName': createdByName,
    'createdByAvatar': createdByAvatar,
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
    'fullContent': fullContent,
    'attachments': attachments,
    'viewCount': viewCount,
    'likeCount': likeCount,
    'isLiked': isLiked,
    'isPublic': isPublic,
    'canEdit': canEdit,
    'createdDate': createdDate,
    'timestamp': timestamp?.toIso8601String(),
  };

  /// Deserializes from a JSON map (e.g., Firestore document data).
  factory ProjectCardModel.fromJson(Map<String, dynamic> json) =>
      ProjectCardModel(
        id: json['id'] as String?,
        createdById: json['createdById'] as String?,
        createdByName: json['createdByName'] as String?,
        createdByAvatar: json['createdByAvatar'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        backgroundImage: json['backgroundImage'] as String?,
        primaryChip: json['primaryChip'] as String?,
        priorityChip: json['priorityChip'] as String?,
        avatarImages: (json['avatarImages'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        teamCount: (json['teamCount'] as num?)?.toInt(),
        statusText: json['statusText'] as String?,
        statusIcon: json['statusIcon'] as String?,
        actionIcon: json['actionIcon'] as String?,
        isSaved: json['isSaved'] as bool?,
        comments: (json['comments'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        fullContent: json['fullContent'] as String?,
        attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
        viewCount: (json['viewCount'] as num?)?.toInt(),
        likeCount: (json['likeCount'] as num?)?.toInt(),
        isLiked: json['isLiked'] as bool?,
        isPublic: json['isPublic'] as bool?,
        canEdit: json['canEdit'] as bool?,
        createdDate: json['createdDate'] as String?,
        timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String)
          : null,
      );
}


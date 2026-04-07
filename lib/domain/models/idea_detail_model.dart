import '../../../core/app_export.dart';

class CommentModel extends Equatable {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String timeAgo;
  final int likes;
  final bool isLiked;
  final bool canEdit;
  final String? editedAt;
  final String? createdAt;
  final List<CommentModel> replies;

  const CommentModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.isLiked = false,
    this.canEdit = false,
    this.editedAt,
    this.createdAt,
    this.replies = const [],
  });

  CommentModel copyWith({
    String? id,
    String? authorName,
    String? authorAvatar,
    String? content,
    String? timeAgo,
    int? likes,
    bool? isLiked,
    bool? canEdit,
    String? editedAt,
    String? createdAt,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      canEdit: canEdit ?? this.canEdit,
      editedAt: editedAt ?? this.editedAt,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final rawReplies = json['replies'];
    final parsedReplies = rawReplies is List
        ? rawReplies
              .whereType<Map<String, dynamic>>()
              .map(CommentModel.fromJson)
              .toList()
        : <CommentModel>[];

    return CommentModel(
      id: json['id']?.toString() ?? '',
      authorName: json['authorName']?.toString() ?? 'Unknown',
      authorAvatar: json['authorAvatar']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      timeAgo: json['timeAgo']?.toString() ?? 'Just now',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] == true,
      canEdit: json['canEdit'] == true,
      editedAt: json['editedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      replies: parsedReplies,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'timeAgo': timeAgo,
      'likes': likes,
      'isLiked': isLiked,
      'canEdit': canEdit,
      'editedAt': editedAt,
      'createdAt': createdAt,
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    authorName,
    authorAvatar,
    content,
    timeAgo,
    likes,
    isLiked,
    canEdit,
    editedAt,
    createdAt,
    replies,
  ];
}

class IdeaDetailModel extends Equatable {
  final String id;
  final String entityType;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String backgroundImage;
  final String createdDate;
  final String creatorId;
  final String creatorName;
  final String creatorAvatar;
  final int likeCount;
  final bool isLiked;
  final bool isSaved;
  final int viewCount;
  final bool isPublic;
  final bool canEdit;
  final List<CommentModel> comments;
  final List<String> attachments;
  final String fullContent;

  const IdeaDetailModel({
    required this.id,
    required this.entityType,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.backgroundImage,
    required this.createdDate,
    required this.creatorId,
    required this.creatorName,
    required this.creatorAvatar,
    required this.likeCount,
    required this.isLiked,
    required this.isSaved,
    required this.viewCount,
    required this.isPublic,
    required this.canEdit,
    required this.comments,
    required this.attachments,
    required this.fullContent,
  });

  IdeaDetailModel copyWith({
    String? id,
    String? entityType,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    String? backgroundImage,
    String? createdDate,
    String? creatorId,
    String? creatorName,
    String? creatorAvatar,
    int? likeCount,
    bool? isLiked,
    bool? isSaved,
    int? viewCount,
    bool? isPublic,
    bool? canEdit,
    List<CommentModel>? comments,
    List<String>? attachments,
    String? fullContent,
  }) {
    return IdeaDetailModel(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      createdDate: createdDate ?? this.createdDate,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      viewCount: viewCount ?? this.viewCount,
      isPublic: isPublic ?? this.isPublic,
      canEdit: canEdit ?? this.canEdit,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
      fullContent: fullContent ?? this.fullContent,
    );
  }

  factory IdeaDetailModel.fromJson(Map<String, dynamic> json) {
    final rawAttachments = json['attachments'];
    final attachments = rawAttachments is List
        ? rawAttachments.map((e) => e.toString()).toList()
        : <String>[];

    final rawComments = json['comments'];
    final comments = rawComments is List
        ? rawComments
              .whereType<Map<String, dynamic>>()
              .map(CommentModel.fromJson)
              .toList()
        : <CommentModel>[];

    final createdDate =
        json['createdDate']?.toString() ?? json['timestamp']?.toString() ?? '';

    return IdeaDetailModel(
      id: json['id']?.toString() ?? '',
      entityType: json['entityType']?.toString() ?? 'idea',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category:
          json['category']?.toString() ?? json['primaryChip']?.toString() ?? '',
      priority:
          json['priority']?.toString() ?? json['priorityChip']?.toString() ?? '',
      status:
          json['status']?.toString() ?? json['statusText']?.toString() ?? '',
      backgroundImage: json['backgroundImage']?.toString() ?? '',
      createdDate: createdDate,
      creatorId:
          json['createdById']?.toString() ?? json['creatorId']?.toString() ?? '',
      creatorName:
          json['createdByName']?.toString() ?? json['creatorName']?.toString() ?? '',
      creatorAvatar:
          json['createdByAvatar']?.toString() ?? json['creatorAvatar']?.toString() ?? '',
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] == true,
      isSaved: json['isSaved'] == true,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      isPublic: json['isPublic'] != false,
      canEdit: json['canEdit'] == true,
      comments: comments,
      attachments: attachments,
      fullContent: json['fullContent']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entityType': entityType,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'backgroundImage': backgroundImage,
      'createdDate': createdDate,
      'createdById': creatorId,
      'createdByName': creatorName,
      'createdByAvatar': creatorAvatar,
      'likeCount': likeCount,
      'isLiked': isLiked,
      'isSaved': isSaved,
      'viewCount': viewCount,
      'isPublic': isPublic,
      'canEdit': canEdit,
      'comments': comments.map((e) => e.toJson()).toList(),
      'attachments': attachments,
      'fullContent': fullContent,
    };
  }

  @override
  List<Object?> get props => [
    id,
    entityType,
    title,
    description,
    category,
    priority,
    status,
    backgroundImage,
    createdDate,
    creatorId,
    creatorName,
    creatorAvatar,
    likeCount,
    isLiked,
    isSaved,
    viewCount,
    isPublic,
    canEdit,
    comments,
    attachments,
    fullContent,
  ];
}

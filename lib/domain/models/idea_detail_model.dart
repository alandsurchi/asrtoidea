import '../../../core/app_export.dart';

class CommentModel extends Equatable {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String timeAgo;
  final int likes;
  final bool isLiked;
  final List<CommentModel> replies;

  const CommentModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.isLiked = false,
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
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object?> get props => [
    id,
    authorName,
    content,
    timeAgo,
    likes,
    isLiked,
    replies,
  ];
}

class IdeaDetailModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String backgroundImage;
  final String createdDate;
  final String deadline;
  final List<String> teamMembers;
  final int likeCount;
  final bool isLiked;
  final bool isSaved;
  final List<CommentModel> comments;
  final List<String> attachments;
  final String fullContent;

  const IdeaDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.backgroundImage,
    required this.createdDate,
    required this.deadline,
    required this.teamMembers,
    required this.likeCount,
    required this.isLiked,
    required this.isSaved,
    required this.comments,
    required this.attachments,
    required this.fullContent,
  });

  IdeaDetailModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    String? backgroundImage,
    String? createdDate,
    String? deadline,
    List<String>? teamMembers,
    int? likeCount,
    bool? isLiked,
    bool? isSaved,
    List<CommentModel>? comments,
    List<String>? attachments,
    String? fullContent,
  }) {
    return IdeaDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      createdDate: createdDate ?? this.createdDate,
      deadline: deadline ?? this.deadline,
      teamMembers: teamMembers ?? this.teamMembers,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
      fullContent: fullContent ?? this.fullContent,
    );
  }

  @override
  List<Object?> get props => [id, title, likeCount, isLiked, isSaved, comments];
}

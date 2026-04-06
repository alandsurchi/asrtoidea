import 'package:ai_idea_generator/domain/models/idea_detail_model.dart';

class IdeaDetailState {
  final IdeaDetailModel? ideaDetail;
  final bool isLoading;
  final String commentText;
  final bool isAddingComment;
  final String? replyingToId;
  final String replyText;

  const IdeaDetailState({
    this.ideaDetail,
    this.isLoading = false,
    this.commentText = '',
    this.isAddingComment = false,
    this.replyingToId,
    this.replyText = '',
  });

  IdeaDetailState copyWith({
    IdeaDetailModel? ideaDetail,
    bool? isLoading,
    String? commentText,
    bool? isAddingComment,
    String? replyingToId,
    String? replyText,
    bool clearReplyingTo = false,
  }) {
    return IdeaDetailState(
      ideaDetail: ideaDetail ?? this.ideaDetail,
      isLoading: isLoading ?? this.isLoading,
      commentText: commentText ?? this.commentText,
      isAddingComment: isAddingComment ?? this.isAddingComment,
      replyingToId: clearReplyingTo
          ? null
          : (replyingToId ?? this.replyingToId),
      replyText: replyText ?? this.replyText,
    );
  }
}

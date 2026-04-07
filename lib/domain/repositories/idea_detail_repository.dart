import '../../domain/models/idea_detail_model.dart';

abstract class IdeaDetailRepository {
  Future<IdeaDetailModel> getDetail({
    required String entityType,
    required String id,
  });

  Future<IdeaDetailModel> updateDetail({
    required String entityType,
    required String id,
    required Map<String, dynamic> payload,
  });

  Future<Map<String, dynamic>> toggleEntityLike({
    required String entityType,
    required String id,
    required bool isLiked,
  });

  Future<void> deleteDetail({
    required String entityType,
    required String id,
  });

  Future<List<CommentModel>> fetchComments({
    required String entityType,
    required String id,
  });

  Future<List<CommentModel>> addComment({
    required String entityType,
    required String id,
    required String content,
    String? parentCommentId,
  });

  Future<List<CommentModel>> editComment({
    required String entityType,
    required String id,
    required String commentId,
    required String content,
  });

  Future<List<CommentModel>> toggleCommentLike({
    required String entityType,
    required String id,
    required String commentId,
    required bool isLiked,
  });
}

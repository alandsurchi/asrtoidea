import '../../core/errors/app_exception.dart';
import '../../domain/models/idea_detail_model.dart';
import '../../domain/repositories/idea_detail_repository.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';

class ApiIdeaDetailRepository implements IdeaDetailRepository {
  final ApiClient _apiClient;

  ApiIdeaDetailRepository(this._apiClient);

  @override
  Future<IdeaDetailModel> getDetail({
    required String entityType,
    required String id,
  }) async {
    final response = await _apiClient.get('${_prefix(entityType)}/$id/detail');
    final parsed = ApiResponse<IdeaDetailModel>.fromJson(
      response,
      (json) => IdeaDetailModel.fromJson(json as Map<String, dynamic>),
    );

    if (parsed.data == null) {
      throw const NotFoundException('Detail data not found.');
    }

    return parsed.data!;
  }

  @override
  Future<IdeaDetailModel> updateDetail({
    required String entityType,
    required String id,
    required Map<String, dynamic> payload,
  }) async {
    final response = await _apiClient.put('${_prefix(entityType)}/$id', body: payload);
    final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => (json as Map).map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    );

    final raw = parsed.data ?? <String, dynamic>{};
    raw['entityType'] = entityType;
    raw['comments'] = const <Map<String, dynamic>>[];
    return IdeaDetailModel.fromJson(raw);
  }

  @override
  Future<Map<String, dynamic>> toggleEntityLike({
    required String entityType,
    required String id,
    required bool isLiked,
  }) async {
    final response = await _apiClient.put(
      '${_prefix(entityType)}/$id/like',
      body: {'isLiked': isLiked},
    );

    final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => (json as Map).map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    );

    return parsed.data ?? {'likeCount': 0, 'isLiked': isLiked};
  }

  @override
  Future<void> deleteDetail({
    required String entityType,
    required String id,
  }) async {
    await _apiClient.delete('${_prefix(entityType)}/$id');
  }

  @override
  Future<List<CommentModel>> fetchComments({
    required String entityType,
    required String id,
  }) async {
    final response = await _apiClient.get('${_prefix(entityType)}/$id/comments');
    return _parseCommentList(response);
  }

  @override
  Future<List<CommentModel>> addComment({
    required String entityType,
    required String id,
    required String content,
    String? parentCommentId,
  }) async {
    final response = await _apiClient.post(
      '${_prefix(entityType)}/$id/comments',
      body: {
        'content': content,
        if (parentCommentId != null && parentCommentId.trim().isNotEmpty)
          'parentCommentId': parentCommentId,
      },
    );
    return _parseCommentList(response);
  }

  @override
  Future<List<CommentModel>> editComment({
    required String entityType,
    required String id,
    required String commentId,
    required String content,
  }) async {
    final response = await _apiClient.put(
      '${_prefix(entityType)}/$id/comments/$commentId',
      body: {'content': content},
    );
    return _parseCommentList(response);
  }

  @override
  Future<List<CommentModel>> toggleCommentLike({
    required String entityType,
    required String id,
    required String commentId,
    required bool isLiked,
  }) async {
    final response = await _apiClient.put(
      '${_prefix(entityType)}/$id/comments/$commentId/like',
      body: {'isLiked': isLiked},
    );
    return _parseCommentList(response);
  }

  List<CommentModel> _parseCommentList(Map<String, dynamic> response) {
    final parsed = ApiResponse<List<CommentModel>>.fromJson(
      response,
      (json) => (json as List)
          .whereType<Map<String, dynamic>>()
          .map(CommentModel.fromJson)
          .toList(),
    );

    return parsed.data ?? const <CommentModel>[];
  }

  String _prefix(String entityType) {
    final normalized = entityType.toLowerCase().trim();
    if (normalized == 'project') return '/projects';
    return '/ideas';
  }
}

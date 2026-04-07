import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_idea_generator/core/providers/repository_providers.dart';
import 'package:ai_idea_generator/domain/models/idea_detail_model.dart';
import 'package:ai_idea_generator/domain/repositories/idea_detail_repository.dart';
import './idea_detail_state.dart';

class IdeaDetailRouteArgs {
  final String entityType;
  final String id;

  const IdeaDetailRouteArgs({required this.entityType, required this.id});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IdeaDetailRouteArgs &&
        other.entityType == entityType &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(entityType, id);
}

final ideaDetailNotifierProvider = StateNotifierProvider.autoDispose
    .family<IdeaDetailNotifier, IdeaDetailState, IdeaDetailRouteArgs>((
      ref,
      args,
    ) {
      final notifier = IdeaDetailNotifier(
        ref.read(ideaDetailRepositoryProvider),
        args,
      );
      notifier.loadDetail();
      return notifier;
    });

class IdeaDetailNotifier extends StateNotifier<IdeaDetailState> {
  final IdeaDetailRepository _repository;
  final IdeaDetailRouteArgs _args;

  IdeaDetailNotifier(this._repository, this._args)
    : super(const IdeaDetailState());

  Future<void> loadDetail() async {
    state = state.copyWith(isLoading: true);

    try {
      final detail = await _repository.getDetail(
        entityType: _args.entityType,
        id: _args.id,
      );
      state = state.copyWith(ideaDetail: detail, isLoading: false);
    } catch (_) {
      state = state.copyWith(ideaDetail: null, isLoading: false);
    }
  }

  Future<void> toggleLike() async {
    final current = state.ideaDetail;
    if (current == null) return;

    // One-like-per-post behavior: always enforce liked=true.
    // If already liked, keep UI state and just re-sync with backend.
    final optimistic = current.isLiked
        ? current
        : current.copyWith(
            isLiked: true,
            likeCount: current.likeCount + 1,
          );

    if (!current.isLiked) {
      state = state.copyWith(ideaDetail: optimistic);
    }

    try {
      final likeResult = await _repository.toggleEntityLike(
        entityType: _args.entityType,
        id: _args.id,
        isLiked: true,
      );

      state = state.copyWith(
        ideaDetail: optimistic.copyWith(
          likeCount: _toInt(likeResult['likeCount']) ?? optimistic.likeCount,
          isLiked: likeResult['isLiked'] == true || optimistic.isLiked,
        ),
      );
    } catch (_) {
      if (!current.isLiked) {
        state = state.copyWith(ideaDetail: current);
      }
    }
  }

  int? _toInt(dynamic raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '');
  }

  void toggleSave() {
    final current = state.ideaDetail;
    if (current == null) return;

    state = state.copyWith(
      ideaDetail: current.copyWith(isSaved: !current.isSaved),
    );
  }

  Future<void> toggleCommentLike(String commentId) async {
    final current = state.ideaDetail;
    if (current == null) return;

    final currentlyLiked = _isCommentLiked(current.comments, commentId);
    if (currentlyLiked == null) return;

    final optimisticComments = _toggleCommentLikeInTree(
      current.comments,
      commentId,
    );
    state = state.copyWith(ideaDetail: current.copyWith(comments: optimisticComments));

    try {
      final serverComments = await _repository.toggleCommentLike(
        entityType: _args.entityType,
        id: _args.id,
        commentId: commentId,
        isLiked: !currentlyLiked,
      );
      state = state.copyWith(
        ideaDetail: current.copyWith(comments: serverComments),
      );
    } catch (_) {
      state = state.copyWith(ideaDetail: current);
    }
  }

  void updateCommentText(String text) {
    state = state.copyWith(commentText: text);
  }

  void setReplyingTo(String? commentId) {
    if (commentId == null) {
      state = state.copyWith(clearReplyingTo: true, replyText: '');
    } else {
      state = state.copyWith(replyingToId: commentId, replyText: '');
    }
  }

  void updateReplyText(String text) {
    state = state.copyWith(replyText: text);
  }

  Future<void> addComment() async {
    final current = state.ideaDetail;
    if (current == null || state.commentText.trim().isEmpty) return;

    final text = state.commentText.trim();
    state = state.copyWith(commentText: '');

    try {
      final comments = await _repository.addComment(
        entityType: _args.entityType,
        id: _args.id,
        content: text,
      );
      state = state.copyWith(
        ideaDetail: current.copyWith(comments: comments),
      );
    } catch (_) {
      state = state.copyWith(commentText: text);
    }
  }

  Future<void> addReply(String parentCommentId) async {
    final current = state.ideaDetail;
    if (current == null || state.replyText.trim().isEmpty) return;

    final text = state.replyText.trim();
    state = state.copyWith(replyText: '', clearReplyingTo: true);

    try {
      final comments = await _repository.addComment(
        entityType: _args.entityType,
        id: _args.id,
        content: text,
        parentCommentId: parentCommentId,
      );
      state = state.copyWith(
        ideaDetail: current.copyWith(comments: comments),
      );
    } catch (_) {
      state = state.copyWith(replyText: text, replyingToId: parentCommentId);
    }
  }

  Future<void> editComment(String commentId, String content) async {
    final current = state.ideaDetail;
    final trimmed = content.trim();
    if (current == null || trimmed.isEmpty) return;

    try {
      final comments = await _repository.editComment(
        entityType: _args.entityType,
        id: _args.id,
        commentId: commentId,
        content: trimmed,
      );
      state = state.copyWith(
        ideaDetail: current.copyWith(comments: comments),
      );
    } catch (_) {}
  }

  Future<void> updateStatus(String newStatus) async {
    final current = state.ideaDetail;
    if (current == null || !current.canEdit) return;

    final previous = current.status;
    state = state.copyWith(ideaDetail: current.copyWith(status: newStatus));

    try {
      await _repository.updateDetail(
        entityType: _args.entityType,
        id: _args.id,
        payload: {
          'status': newStatus,
          'statusText': newStatus,
        },
      );
    } catch (_) {
      state = state.copyWith(ideaDetail: current.copyWith(status: previous));
    }
  }

  Future<void> updateMainContent({
    required String title,
    required String description,
  }) async {
    final current = state.ideaDetail;
    if (current == null || !current.canEdit) return;

    final optimistic = current.copyWith(title: title.trim(), description: description.trim());
    state = state.copyWith(ideaDetail: optimistic);

    try {
      await _repository.updateDetail(
        entityType: _args.entityType,
        id: _args.id,
        payload: {
          'title': title.trim(),
          'description': description.trim(),
        },
      );
    } catch (_) {
      state = state.copyWith(ideaDetail: current);
    }
  }

  Future<bool> toggleVisibility() async {
    final current = state.ideaDetail;
    if (current == null || !current.canEdit) return false;

    final nextVisibility = !current.isPublic;
    state = state.copyWith(
      ideaDetail: current.copyWith(isPublic: nextVisibility),
    );

    try {
      await _repository.updateDetail(
        entityType: _args.entityType,
        id: _args.id,
        payload: {'isPublic': nextVisibility},
      );
      return true;
    } catch (_) {
      state = state.copyWith(ideaDetail: current);
      return false;
    }
  }

  Future<bool> deleteEntity() async {
    final current = state.ideaDetail;
    if (current == null || !current.canEdit) return false;

    try {
      await _repository.deleteDetail(entityType: _args.entityType, id: _args.id);
      state = state.copyWith(ideaDetail: null);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool? _isCommentLiked(List<CommentModel> comments, String commentId) {
    for (final comment in comments) {
      if (comment.id == commentId) return comment.isLiked;
      final nested = _isCommentLiked(comment.replies, commentId);
      if (nested != null) return nested;
    }
    return null;
  }

  List<CommentModel> _toggleCommentLikeInTree(
    List<CommentModel> comments,
    String commentId,
  ) {
    return comments.map((comment) {
      if (comment.id == commentId) {
        final nextLiked = !comment.isLiked;
        return comment.copyWith(
          isLiked: nextLiked,
          likes: nextLiked
              ? comment.likes + 1
              : (comment.likes > 0 ? comment.likes - 1 : 0),
        );
      }

      if (comment.replies.isNotEmpty) {
        return comment.copyWith(
          replies: _toggleCommentLikeInTree(comment.replies, commentId),
        );
      }

      return comment;
    }).toList();
  }
}

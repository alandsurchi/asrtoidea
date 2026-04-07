import 'package:ai_idea_generator/core/errors/app_exception.dart';
import 'package:ai_idea_generator/core/providers/repository_providers.dart';
import 'package:ai_idea_generator/domain/models/project_card_model.dart';
import 'package:ai_idea_generator/domain/repositories/project_repository.dart';
import '../../../core/app_export.dart';

part 'profile_posts_state.dart';

final profilePostsNotifierProvider =
    StateNotifierProvider.autoDispose<ProfilePostsNotifier, ProfilePostsState>(
      (ref) => ProfilePostsNotifier(
        const ProfilePostsState(),
        ref.read(projectRepositoryProvider),
      )..loadPosts(),
    );

class ProfilePostsNotifier extends StateNotifier<ProfilePostsState> {
  final ProjectRepository _repository;

  ProfilePostsNotifier(ProfilePostsState state, this._repository) : super(state);

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final posts = await _repository.getProjects();
      state = state.copyWith(posts: posts, isLoading: false, clearError: true);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: appErrorMessage(error),
      );
    }
  }

  Future<void> toggleSave(ProjectCardModel post) async {
    final postId = (post.id ?? '').trim();
    if (postId.isEmpty) return;

    final previousPosts = state.posts;
    final previousSaved = post.isSaved ?? false;
    final optimistic = post.copyWith(isSaved: !previousSaved);

    state = state.copyWith(posts: _replacePost(previousPosts, optimistic));

    try {
      final updated = await _repository.toggleSave(postId, !previousSaved);
      state = state.copyWith(posts: _replacePost(state.posts, updated));
    } catch (error) {
      state = state.copyWith(
        posts: previousPosts,
        errorMessage: appErrorMessage(error),
      );
    }
  }

  Future<void> toggleLike(ProjectCardModel post) async {
    final postId = (post.id ?? '').trim();
    if (postId.isEmpty) return;

    // One-like-per-post behavior: once liked, keep it liked.
    if (post.isLiked == true) return;

    final previousPosts = state.posts;
    final previousCount = post.likeCount ?? 0;
    final optimistic = post.copyWith(isLiked: true, likeCount: previousCount + 1);

    state = state.copyWith(posts: _replacePost(previousPosts, optimistic));

    try {
      final updated = await _repository.toggleLike(postId, true);
      state = state.copyWith(posts: _replacePost(state.posts, updated));
    } catch (error) {
      state = state.copyWith(
        posts: previousPosts,
        errorMessage: appErrorMessage(error),
      );
    }
  }

  List<ProjectCardModel> _replacePost(
    List<ProjectCardModel> source,
    ProjectCardModel updated,
  ) {
    final updatedId = (updated.id ?? '').trim();
    return source
        .map((item) => (item.id ?? '').trim() == updatedId ? updated : item)
        .toList();
  }
}

import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../domain/models/project_card_model.dart';
import '../../widgets/custom_task_card.dart';
import '../profile_posts/notifier/profile_posts_notifier.dart';

class FavoritesHubScreen extends ConsumerWidget {
  const FavoritesHubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(profilePostsNotifierProvider);
    final notifier = ref.read(profilePostsNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final savedPosts = state.posts.where((post) => post.isSaved == true).toList();
    final likedPosts = state.posts.where((post) => post.isLiked == true).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            loc.favoritesHubTitle,
            style: TextStyleHelper.instance.title16SemiBoldSans.copyWith(
              color: isDark ? Colors.white : const Color(0xFF000000),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.h),
              padding: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1D00FF), Color(0xFF6A59F1)],
                ),
                borderRadius: BorderRadius.circular(16.h),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.favoritesHubSubtitle,
                    style: TextStyleHelper.instance.title13MediumPoppins.copyWith(
                      color: Colors.white.withAlpha(220),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _buildCounterChip(label: loc.savedPosts, count: savedPosts.length),
                      SizedBox(width: 8.h),
                      _buildCounterChip(label: loc.likedPosts, count: likedPosts.length),
                    ],
                  ),
                ],
              ),
            ),
            if (state.errorMessage != null && state.errorMessage!.trim().isNotEmpty)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 12.h, left: 20.h, right: 20.h),
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(12.h),
                  border: Border.all(color: const Color(0xFFFFD6D6)),
                ),
                child: Text(
                  state.errorMessage!,
                  style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
                    color: const Color(0xFFC0392B),
                  ),
                ),
              ),
            Container(
              margin: EdgeInsets.only(top: 14.h, left: 20.h, right: 20.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF4F4FF),
                borderRadius: BorderRadius.circular(14.h),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF),
                  borderRadius: BorderRadius.circular(10.h),
                ),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: isDark
                    ? const Color(0xFFB6B6D1)
                    : const Color(0xFF5F5F75),
                tabs: [
                  Tab(text: loc.savedPosts),
                  Tab(text: loc.likedPosts),
                ],
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      children: [
                        _buildPostList(
                          context: context,
                          posts: savedPosts,
                          emptyLabel: loc.noSavedPosts,
                          onRefresh: notifier.loadPosts,
                          onToggleSave: (post) => notifier.toggleSave(post),
                        ),
                        _buildPostList(
                          context: context,
                          posts: likedPosts,
                          emptyLabel: loc.noLikedPosts,
                          onRefresh: notifier.loadPosts,
                          onToggleSave: (post) => notifier.toggleSave(post),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterChip({required String label, required int count}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: Text(
        '$label: $count',
        style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPostList({
    required BuildContext context,
    required List<ProjectCardModel> posts,
    required String emptyLabel,
    required Future<void> Function() onRefresh,
    required Future<void> Function(ProjectCardModel post) onToggleSave,
  }) {
    final loc = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: posts.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 80.h),
                Icon(Icons.bookmark_border, size: 48.h, color: const Color(0xFFB5B5C9)),
                SizedBox(height: 10.h),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Text(
                      emptyLabel,
                      textAlign: TextAlign.center,
                      style: TextStyleHelper.instance.title14MediumSans.copyWith(
                        color: const Color(0xFF8A8AA3),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 16.h, left: 20.h, right: 20.h, bottom: 24.h),
              itemBuilder: (context, index) {
                final post = posts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTaskCard(
                      title: post.title ?? '',
                      description: _composeDescription(post),
                      backgroundImage: _resolveBackground(post),
                      primaryChip: post.primaryChip,
                      priorityChip: post.priorityChip,
                      avatarImages: post.avatarImages,
                      teamCount: post.teamCount,
                      statusText: post.statusText,
                      statusIcon: (post.statusIcon ?? '').trim().isEmpty
                          ? null
                          : post.statusIcon,
                      actionIcon: null,
                      onTap: () => _openDetail(context, post),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          '${loc.like}: ${post.likeCount ?? 0}',
                          style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
                            color: const Color(0xFF6B6B8A),
                          ),
                        ),
                        const Spacer(),
                        if (post.isSaved == true)
                          TextButton.icon(
                            onPressed: () => onToggleSave(post),
                            icon: const Icon(Icons.bookmark_remove_outlined, size: 18),
                            label: Text(loc.removeSaved),
                          ),
                        TextButton.icon(
                          onPressed: () => _openDetail(context, post),
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: Text(loc.openPost),
                        ),
                      ],
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 14.h),
              itemCount: posts.length,
            ),
    );
  }

  String _composeDescription(ProjectCardModel post) {
    final author = (post.createdByName ?? '').trim();
    final description = (post.description ?? '').trim();
    if (author.isEmpty) return description;
    if (description.isEmpty) return 'By $author';
    return 'By $author\n$description';
  }

  String _resolveBackground(ProjectCardModel post) {
    final background = (post.backgroundImage ?? '').trim();
    if (background.isEmpty) {
      return ImageConstant.imgRectangle29250x400;
    }
    return background;
  }

  void _openDetail(BuildContext context, ProjectCardModel post) {
    final postId = (post.id ?? '').trim();
    if (postId.isEmpty) return;

    Navigator.pushNamed(
      context,
      AppRoutes.ideaDetailView,
      arguments: {
        'entityType': 'project',
        'id': postId,
      },
    );
  }
}

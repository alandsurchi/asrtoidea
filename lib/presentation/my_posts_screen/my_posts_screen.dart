import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../domain/models/project_card_model.dart';
import '../../widgets/custom_task_card.dart';
import '../profile_posts/notifier/profile_posts_notifier.dart';
import '../settings_screen/notifier/settings_notifier.dart';

class MyPostsScreen extends ConsumerWidget {
  const MyPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final postsState = ref.watch(profilePostsNotifierProvider);
    final postsNotifier = ref.read(profilePostsNotifierProvider.notifier);
    final settingsState = ref.watch(settingsNotifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentUserId = (settingsState.settingsModel?.id ?? '').trim();
    final myPosts = postsState.posts
        .where((post) => (post.createdById ?? '').trim() == currentUserId)
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          loc.myPostsTitle,
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
                colors: [Color(0xFF14B8A6), Color(0xFF0EA5E9)],
              ),
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.myPostsSubtitle,
                  style: TextStyleHelper.instance.title13MediumPoppins.copyWith(
                    color: Colors.white.withAlpha(220),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(20.h),
                  ),
                  child: Text(
                    '${loc.myPostsTitle}: ${myPosts.length}',
                    style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (postsState.errorMessage != null && postsState.errorMessage!.trim().isNotEmpty)
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
                postsState.errorMessage!,
                style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
                  color: const Color(0xFFC0392B),
                ),
              ),
            ),
          Expanded(
            child: postsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      await postsNotifier.loadPosts();
                      await ref.read(settingsNotifier.notifier).reloadProfile();
                    },
                    child: _buildBodyContent(
                      context: context,
                      posts: myPosts,
                      hasUserId: currentUserId.isNotEmpty,
                      onToggleSave: (post) => postsNotifier.toggleSave(post),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent({
    required BuildContext context,
    required List<ProjectCardModel> posts,
    required bool hasUserId,
    required Future<void> Function(ProjectCardModel post) onToggleSave,
  }) {
    final loc = AppLocalizations.of(context)!;

    if (!hasUserId) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 80.h),
          Icon(Icons.person_search_outlined, size: 48.h, color: const Color(0xFFB5B5C9)),
          SizedBox(height: 10.h),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: Text(
                loc.profileLoadHint,
                textAlign: TextAlign.center,
                style: TextStyleHelper.instance.title14MediumSans.copyWith(
                  color: const Color(0xFF8A8AA3),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (posts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 80.h),
          Icon(Icons.post_add_outlined, size: 48.h, color: const Color(0xFFB5B5C9)),
          SizedBox(height: 10.h),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: Text(
                loc.noMyPosts,
                textAlign: TextAlign.center,
                style: TextStyleHelper.instance.title14MediumSans.copyWith(
                  color: const Color(0xFF8A8AA3),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
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
                SizedBox(width: 12.h),
                Text(
                  '${loc.comments}: ${(post.comments ?? const <String>[]).length}',
                  style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
                    color: const Color(0xFF6B6B8A),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => onToggleSave(post),
                  icon: Icon(
                    post.isSaved == true ? Icons.bookmark : Icons.bookmark_outline,
                    size: 18,
                  ),
                  label: Text(
                    post.isSaved == true ? loc.savedPosts : loc.save,
                  ),
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
    );
  }

  String _composeDescription(ProjectCardModel post) {
    final description = (post.description ?? '').trim();
    if (description.isNotEmpty) return description;
    return post.fullContent ?? '';
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

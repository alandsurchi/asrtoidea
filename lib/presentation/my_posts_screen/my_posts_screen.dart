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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentUserId = (settingsState.settingsModel?.id ?? '').trim();
    final myPosts = postsState.posts
        .where((post) => (post.createdById ?? '').trim() == currentUserId)
        .toList();
    final sortedMyPosts = _sortedByRecent(myPosts);
    final topPost = _topPostByLikes(myPosts);
    final totalLikes = myPosts.fold<int>(0, (sum, post) => sum + (post.likeCount ?? 0));
    final totalComments = myPosts.fold<int>(
      0,
      (sum, post) => sum + (post.comments?.length ?? 0),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
      body: Stack(
        children: [
          _buildBackdrop(isDark),
          Column(
            children: [
              _buildHeroPanel(
                context: context,
                totalPosts: myPosts.length,
                totalLikes: totalLikes,
                totalComments: totalComments,
              ),
              if (postsState.errorMessage != null && postsState.errorMessage!.trim().isNotEmpty)
                _buildErrorBanner(context, postsState.errorMessage!),
              if (topPost != null)
                _buildSpotlightCard(
                  context: context,
                  post: topPost,
                ),
              Expanded(
                child: postsState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        color: const Color(0xFF00A8C9),
                        onRefresh: () async {
                          await postsNotifier.loadPosts();
                          await ref.read(settingsNotifier.notifier).reloadProfile();
                        },
                        child: _buildBodyContent(
                          context: context,
                          posts: sortedMyPosts,
                          hasUserId: currentUserId.isNotEmpty,
                          onToggleLike: (post) => postsNotifier.toggleLike(post),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<ProjectCardModel> _sortedByRecent(List<ProjectCardModel> posts) {
    final ordered = [...posts];
    ordered.sort((a, b) => _postTimestamp(b).compareTo(_postTimestamp(a)));
    return ordered;
  }

  DateTime _postTimestamp(ProjectCardModel post) {
    final fromCreatedDate = DateTime.tryParse((post.createdDate ?? '').trim());
    return post.timestamp ?? fromCreatedDate ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  ProjectCardModel? _topPostByLikes(List<ProjectCardModel> posts) {
    if (posts.isEmpty) return null;
    final ranked = [...posts]
      ..sort((a, b) => (b.likeCount ?? 0).compareTo(a.likeCount ?? 0));
    return ranked.first;
  }

  Widget _buildBackdrop(bool isDark) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100.h,
            right: -90.h,
            child: Container(
              width: 240.h,
              height: 240.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00C2A8).withAlpha(isDark ? 80 : 50),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 80.h,
            left: -120.h,
            child: Container(
              width: 250.h,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0EA5E9).withAlpha(isDark ? 80 : 46),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPanel({
    required BuildContext context,
    required int totalPosts,
    required int totalLikes,
    required int totalComments,
  }) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.all(18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.h),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00A8C9), Color(0xFF13B99E), Color(0xFF58C56F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A8C9).withAlpha(70),
            blurRadius: 24.h,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.myPostsSubtitle,
            style: TextStyleHelper.instance.title14MediumSans.copyWith(
              color: Colors.white.withAlpha(235),
              height: 1.45,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  value: '$totalPosts',
                  label: loc.myPostsTitle,
                  icon: Icons.grid_view_rounded,
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: _buildStatTile(
                  value: '$totalLikes',
                  label: loc.like,
                  icon: Icons.favorite_rounded,
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: _buildStatTile(
                  value: '$totalComments',
                  label: loc.comments,
                  icon: Icons.chat_bubble_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(36),
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(color: Colors.white.withAlpha(55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.h, color: Colors.white),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyleHelper.instance.title14MediumSans.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
              fontSize: 11.fSize,
              color: Colors.white.withAlpha(220),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.h, left: 20.h, right: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: const Color(0xFFFFD6D6)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18.h, color: const Color(0xFFC0392B)),
          SizedBox(width: 8.h),
          Expanded(
            child: Text(
              message,
              style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
                color: const Color(0xFFC0392B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotlightCard({
    required BuildContext context,
    required ProjectCardModel post,
  }) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(top: 12.h, left: 20.h, right: 20.h),
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1D2F) : const Color(0xFFFFFCF1),
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(
          color: isDark ? const Color(0xFF343652) : const Color(0xFFF4E4AE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.h,
            height: 42.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF2C94C).withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome, color: const Color(0xFFC89200), size: 22.h),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.instance.title14MediumSans.copyWith(
                    color: isDark ? Colors.white : const Color(0xFF1C1D2D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${loc.like}: ${post.likeCount ?? 0} • ${loc.comments}: ${(post.comments ?? const <String>[]).length}',
                  style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
                    color: isDark ? const Color(0xFFB9BCDA) : const Color(0xFF615E46),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 24.h, color: const Color(0xFFB58A00)),
        ],
      ),
    );
  }

  Widget _buildBodyContent({
    required BuildContext context,
    required List<ProjectCardModel> posts,
    required bool hasUserId,
    required Future<void> Function(ProjectCardModel post) onToggleLike,
  }) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!hasUserId) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        children: [
          SizedBox(height: 80.h),
          Container(
            padding: EdgeInsets.all(22.h),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20.h),
              border: Border.all(
                color: isDark ? const Color(0xFF323249) : const Color(0xFFE7ECFF),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 54.h,
                  height: 54.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00A8C9).withAlpha(22),
                  ),
                  child: Icon(
                    Icons.person_search_outlined,
                    size: 30.h,
                    color: const Color(0xFF008EAD),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  loc.profileLoadHint,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.title14MediumSans.copyWith(
                    color: isDark ? const Color(0xFFD4D6EA) : const Color(0xFF4E5578),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (posts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        children: [
          SizedBox(height: 80.h),
          Container(
            padding: EdgeInsets.all(22.h),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20.h),
              border: Border.all(
                color: isDark ? const Color(0xFF323249) : const Color(0xFFE7ECFF),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 54.h,
                  height: 54.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00A8C9).withAlpha(22),
                  ),
                  child: Icon(
                    Icons.post_add_outlined,
                    size: 30.h,
                    color: const Color(0xFF008EAD),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  loc.noMyPosts,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.title14MediumSans.copyWith(
                    color: isDark ? const Color(0xFFD4D6EA) : const Color(0xFF4E5578),
                    height: 1.5,
                  ),
                ),
              ],
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
        return Container(
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF181827) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(18.h),
            border: Border.all(
              color: isDark ? const Color(0xFF2D2F45) : const Color(0xFFE5EBFF),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 26 : 14),
                blurRadius: 16.h,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Column(
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
                height: 230.h,
                onTap: () => _openDetail(context, post),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.h,
                runSpacing: 8.h,
                children: [
                  _buildMetaChip(
                    icon: Icons.chat_bubble_outline,
                    label: '${loc.comments}: ${(post.comments ?? const <String>[]).length}',
                    color: const Color(0xFFE7F2FF),
                    textColor: const Color(0xFF1D5FBF),
                  ),
                  _buildMetaChip(
                    icon: post.isPublic == true ? Icons.public : Icons.lock_outline,
                    label: post.isPublic == true
                        ? loc.publicPostVisibility
                        : loc.privatePostVisibility,
                    color: const Color(0xFFEAF8ED),
                    textColor: const Color(0xFF1F7B49),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: post.isLiked == true ? null : () => onToggleLike(post),
                  icon: Icon(
                    post.isLiked == true
                        ? Icons.favorite_rounded
                        : Icons.favorite_border,
                    size: 18,
                    color: post.isLiked == true
                        ? const Color(0xFFB41E52)
                        : null,
                  ),
                  label: Text(
                    '${post.isLiked == true ? loc.likedPosts : loc.like} (${post.likeCount ?? 0})',
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: post.isLiked == true
                          ? const Color(0xFFF3A9BE)
                          : (isDark ? const Color(0xFF3A3D57) : const Color(0xFFD5DDF8)),
                    ),
                    backgroundColor: post.isLiked == true
                        ? const Color(0xFFFFF0F4)
                        : (isDark ? const Color(0xFF212338) : const Color(0xFFF4F7FF)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 14.h),
      itemCount: posts.length,
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.h, color: textColor),
          SizedBox(width: 4.h),
          Text(
            label,
            style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
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

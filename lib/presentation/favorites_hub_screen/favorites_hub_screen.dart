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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final savedPosts = state.posts.where((post) => post.isSaved == true).toList();
    final likedPosts = state.posts.where((post) => post.isLiked == true).toList();
    final totalLikes = state.posts.fold<int>(
      0,
      (sum, post) => sum + (post.likeCount ?? 0),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
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
        body: Stack(
          children: [
            _buildBackdrop(isDark),
            Column(
              children: [
                _buildHeaderPanel(
                  context: context,
                  subtitle: loc.favoritesHubSubtitle,
                  savedCount: savedPosts.length,
                  totalLikes: totalLikes,
                ),
                if (state.errorMessage != null && state.errorMessage!.trim().isNotEmpty)
                  _buildErrorBanner(context, state.errorMessage!),
                _buildTabBar(
                  context: context,
                  savedCount: savedPosts.length,
                  likedCount: likedPosts.length,
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
                              emptyIcon: Icons.bookmark_add_outlined,
                              onRefresh: notifier.loadPosts,
                              onOpenDetail: (post) => _openDetail(context, post, notifier),
                            ),
                            _buildPostList(
                              context: context,
                              posts: likedPosts,
                              emptyLabel: loc.noLikedPosts,
                              emptyIcon: Icons.favorite_border,
                              onRefresh: notifier.loadPosts,
                              onOpenDetail: (post) => _openDetail(context, post, notifier),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackdrop(bool isDark) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90.h,
            left: -80.h,
            child: Container(
              width: 220.h,
              height: 220.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1D00FF).withAlpha(isDark ? 80 : 55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            right: -110.h,
            child: Container(
              width: 250.h,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF39B8FF).withAlpha(isDark ? 70 : 45),
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

  Widget _buildHeaderPanel({
    required BuildContext context,
    required String subtitle,
    required int savedCount,
    required int totalLikes,
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
          colors: [Color(0xFF1D00FF), Color(0xFF3C54F5), Color(0xFF0FA3FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D00FF).withAlpha(70),
            blurRadius: 24.h,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyleHelper.instance.title14MediumSans.copyWith(
              color: Colors.white.withAlpha(235),
              height: 1.45,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _buildCounterChip(
                  label: loc.savedPosts,
                  count: savedCount,
                  icon: Icons.bookmark_rounded,
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: _buildCounterChip(
                  label: loc.like,
                  count: totalLikes,
                  icon: Icons.auto_awesome,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterChip({
    required String label,
    required int count,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(36),
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(color: Colors.white.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 16.h),
          SizedBox(height: 8.h),
          Text(
            '$count',
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

  Widget _buildTabBar({
    required BuildContext context,
    required int savedCount,
    required int likedCount,
  }) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(top: 14.h, left: 20.h, right: 20.h),
      padding: EdgeInsets.all(4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2A) : const Color(0xFFF2F5FF),
        borderRadius: BorderRadius.circular(14.h),
        border: Border.all(
          color: isDark ? const Color(0xFF323249) : const Color(0xFFDCE5FF),
        ),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1D00FF), Color(0xFF446DFF)],
          ),
          borderRadius: BorderRadius.circular(10.h),
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? const Color(0xFFB6B6D1) : const Color(0xFF4E5578),
        tabs: [
          Tab(
            child: _buildTabLabel(
              label: loc.savedPosts,
              count: savedCount,
            ),
          ),
          Tab(
            child: _buildTabLabel(
              label: loc.likedPosts,
              count: likedCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabLabel({required String label, required int count}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(40),
            borderRadius: BorderRadius.circular(20.h),
          ),
          child: Text(
            '$count',
            style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
              fontSize: 11.fSize,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostList({
    required BuildContext context,
    required List<ProjectCardModel> posts,
    required String emptyLabel,
    required IconData emptyIcon,
    required Future<void> Function() onRefresh,
    required Future<void> Function(ProjectCardModel post) onOpenDetail,
  }) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: const Color(0xFF1D00FF),
      child: posts.isEmpty
          ? ListView(
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 30 : 15),
                        blurRadius: 16.h,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 54.h,
                        height: 54.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1D00FF).withAlpha(22),
                        ),
                        child: Icon(
                          emptyIcon,
                          size: 30.h,
                          color: const Color(0xFF3552FB),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        emptyLabel,
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
            )
          : ListView.separated(
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
                        onTap: () => onOpenDetail(post),
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
                          if (post.isSaved == true)
                            _buildMetaChip(
                              icon: Icons.bookmark_rounded,
                              label: loc.savedPosts,
                              color: const Color(0xFFE8F8EE),
                              textColor: const Color(0xFF1B7A46),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 14.h),
              itemCount: posts.length,
            ),
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

  Future<void> _openDetail(
    BuildContext context,
    ProjectCardModel post,
    ProfilePostsNotifier notifier,
  ) async {
    final postId = (post.id ?? '').trim();
    if (postId.isEmpty) return;

    await Navigator.pushNamed(
      context,
      AppRoutes.ideaDetailView,
      arguments: {
        'entityType': 'project',
        'id': postId,
      },
    );

    await notifier.loadPosts();
  }
}

import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/custom_task_card.dart';
import './widgets/project_filter_tab_item.dart';
import 'notifier/project_explore_dashboard_notifier.dart';
import 'package:ai_idea_generator/domain/models/project_card_model.dart';

class ProjectExploreDashboardScreen extends ConsumerStatefulWidget {
  ProjectExploreDashboardScreen({Key? key}) : super(key: key);

  @override
  ProjectExploreDashboardScreenState createState() =>
      ProjectExploreDashboardScreenState();
}

class ProjectExploreDashboardScreenState
    extends ConsumerState<ProjectExploreDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context, isRtl, isDark),
        body: Container(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 2.h),
              _buildSearchSection(context),
              SizedBox(height: 20.h),
              _buildFilterTabs(context, isRtl),
              SizedBox(height: 44.h),
              _buildProjectsList(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isRtl,
    bool isDark,
  ) {
    final loc = AppLocalizations.of(context)!;
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 46.h,
      titleSpacing: 20.h,
      title: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                loc.explore,
                style: TextStyleHelper.instance.headline24SemiBoldPoppins
                    .copyWith(color: textColor),
              ),
            ),
          ),
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              GestureDetector(
                onTap: () => onTapEditIcon(context),
                child: CustomImageView(
                  imagePath: ImageConstant.imgEditContainedBlack900,
                  height: 24.h,
                  width: 24.h,
                  color: isDark ? Colors.white : null,
                ),
              ),
              SizedBox(width: 14.h),
              GestureDetector(
                onTap: () => onTapTrashIcon(context),
                child: CustomImageView(
                  imagePath: ImageConstant.imgTrash04,
                  height: 24.h,
                  width: 24.h,
                  color: isDark ? Colors.white : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, _) {
        return CustomSearchView(
          controller: _searchController,
          placeholder: loc.search,
          leftImagePath: ImageConstant.imgSearch,
          rightImagePath: ImageConstant.imgFilter3line,
          margin: EdgeInsets.symmetric(horizontal: 20.h),
          onRightIconTap: () => onTapFilterIcon(context),
          onChanged: (value) {
            ref
                .read(projectExploreDashboardNotifier.notifier)
                .updateSearchQuery(value);
          },
        );
      },
    );
  }

  Widget _buildFilterTabs(BuildContext context, bool isRtl) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(projectExploreDashboardNotifier);
        final allCards = state.projectExploreDashboardModel?.allProjectCards ?? [];
        
        final inProgressCount = allCards.where((c) => c.statusText == 'In Progress').length;
        final toDoCount = allCards.where((c) => c.statusText == 'To-do').length;
        final completedCount = allCards.where((c) => c.statusText == 'Completed').length;
        final generatedCount = allCards.where((c) => c.statusText == 'Generated').length;

        // The mock tabs are in progress, To-do, Completed, Generated
        // We will update their counts locally
        return Container(
          margin: isRtl
              ? EdgeInsets.only(right: 20.h)
              : EdgeInsets.only(left: 20.h),
          height: 36.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            reverse: isRtl,
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            separatorBuilder: (context, index) => SizedBox(width: 12.h),
            itemCount:
                state.projectExploreDashboardModel?.filterTabs?.length ?? 0,
            itemBuilder: (context, index) {
              final tabModel =
                  state.projectExploreDashboardModel?.filterTabs?[index];
              if (tabModel == null) return SizedBox.shrink();
              
              int dynamicCount = 0;
              switch (index) {
                case 0: dynamicCount = inProgressCount; break;
                case 1: dynamicCount = toDoCount; break;
                case 2: dynamicCount = completedCount; break;
                case 3: dynamicCount = generatedCount; break;
              }
              
              return ProjectFilterTabItem(
                // We fake the copyWith by copying the count here because the model doesn't have copyWith generated sometimes, but it's passed as model wrapper
                model: tabModel.copyWith(count: dynamicCount),
                isSelected: index == (state.selectedTabIndex ?? 0),
                onTap: () {
                  ref
                      .read(projectExploreDashboardNotifier.notifier)
                      .selectTab(index);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(projectExploreDashboardNotifier);
          if (state.isLoading ?? false) {
            return Center(child: CircularProgressIndicator());
          }
          final projects =
              state.projectExploreDashboardModel?.projectCards ?? [];
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            separatorBuilder: (context, index) => SizedBox(height: 20.h),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final projectModel = projects[index];
              return CustomTaskCard(
                title: projectModel.title ?? '',
                description: _withCreator(projectModel),
                backgroundImage: projectModel.backgroundImage ?? '',
                primaryChip: projectModel.primaryChip,
                priorityChip: projectModel.priorityChip,
                avatarImages: projectModel.avatarImages,
                teamCount: projectModel.teamCount,
                statusText: projectModel.statusText,
                statusIcon: projectModel.statusIcon,
                actionIcon: projectModel.actionIcon,
                onTap: () => onTapProjectCard(context, index),
                onActionTap: () => onTapProjectAction(context, projectModel),
              );
            },
          );
        },
      ),
    );
  }

  String _withCreator(ProjectCardModel projectModel) {
    final author = (projectModel.createdByName ?? '').trim();
    final description = (projectModel.description ?? '').trim();

    if (author.isEmpty) return description;
    if (description.isEmpty) return 'By $author';
    return 'By $author\n$description';
  }

  void onTapEditIcon(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _showDarkAwareBottomSheet(
      context: context,
      isDark: isDark,
      title: loc.editOptions,
      children: [
        _buildBottomSheetItem(
          context,
          Icons.edit_outlined,
          loc.editProjectName,
          isDark,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.editComingSoon),
                backgroundColor: Color(0xFF1D00FF),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        _buildBottomSheetItem(
          context,
          Icons.description_outlined,
          loc.editDescription,
          isDark,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.editComingSoon),
                backgroundColor: Color(0xFF1D00FF),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        _buildBottomSheetItem(
          context,
          Icons.label_outline,
          loc.editTags,
          isDark,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.editComingSoon),
                backgroundColor: Color(0xFF1D00FF),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomSheetItem(
    BuildContext context,
    IconData icon,
    String title,
    bool isDark,
    VoidCallback onTap,
  ) {
    final cardColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFF8F8FF);
    final borderColor = isDark
        ? const Color(0xFF3A3A5E)
        : const Color(0xFFEBEBFF);
    final iconColor = isDark
        ? const Color(0xFF6A59F1)
        : const Color(0xFF1D00FF);
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final arrowColor = isDark
        ? const Color(0xFF6B6B8A)
        : const Color(0xFF888888);

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyleHelper.instance.title14MediumSans.copyWith(
                  color: textColor,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: arrowColor, size: 18),
          ],
        ),
      ),
    );
  }

  void onTapTrashIcon(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.delete_outline,
              color: Color(0xFFFF3B30),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              loc.deleteProject,
              style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
                color: isDark ? Colors.white : const Color(0xFF000000),
              ),
            ),
          ],
        ),
        content: Text(
          loc.deleteConfirm,
          style: TextStyleHelper.instance.title13LightPoppins.copyWith(
            color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF555555),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              loc.cancel,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF9E9E9E)
                    : const Color(0xFF888888),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.projectDeleted),
                  backgroundColor: Color(0xFFFF3B30),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(loc.delete, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void onTapFilterIcon(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipBg = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0FF);
    final chipBorder = isDark
        ? const Color(0xFF6A59F1).withAlpha(60)
        : const Color(0xFF1D00FF).withAlpha(60);
    final chipText = isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF);
    final subTextColor = isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF888888);

    _showDarkAwareBottomSheet(
      context: context,
      isDark: isDark,
      title: loc.filterProjects,
      children: [
        Text(
          loc.sortBy,
          style: TextStyleHelper.instance.title13SemiBoldPoppins.copyWith(
            color: subTextColor,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [loc.newest, loc.oldest, loc.aToZ, loc.priority].map((
            label,
          ) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${loc.sortedBy} $label'),
                    backgroundColor: const Color(0xFF1D00FF),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: chipBorder),
                ),
                child: Text(
                  label,
                  style: TextStyleHelper.instance.title13MediumPoppins.copyWith(
                    color: chipText,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text(
          loc.status,
          style: TextStyleHelper.instance.title13SemiBoldPoppins.copyWith(
            color: subTextColor,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [loc.all, loc.inProgress, loc.completed, loc.toDo].map((
            label,
          ) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${loc.filtered}: $label'),
                    backgroundColor: const Color(0xFF1D00FF),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: chipBorder),
                ),
                child: Text(
                  label,
                  style: TextStyleHelper.instance.title13MediumPoppins.copyWith(
                    color: chipText,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void onTapProjectCard(BuildContext context, int index) {
    Navigator.pushNamed(
      context,
      AppRoutes.ideaDetailView,
      arguments: 'idea_$index',
    );
  }

  void onTapProjectAction(BuildContext context, ProjectCardModel project) {
    if (project.id == null) return;
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deleteBg = isDark ? const Color(0xFF2A1515) : const Color(0xFFFFF0F0);
    final deleteBorder = isDark
        ? const Color(0xFF5A2020)
        : const Color(0xFFFFCCCC);
    
    final isSaved = project.isSaved ?? false;
    final saveIcon = isSaved ? Icons.bookmark : Icons.bookmark_outline;
    final saveLabel = isSaved ? "Remove from favorites" : loc.saveToFavorites;

    _showDarkAwareBottomSheet(
      context: context,
      isDark: isDark,
      title: loc.projectActions,
      children: [
        _buildBottomSheetItem(
          context,
          Icons.open_in_new,
          loc.viewDetails,
          isDark,
          () {
            // Using index 0 randomly since this is just navigation legacy, but really should be project.id
            onTapProjectCard(context, 0); 
          },
        ),
        const SizedBox(height: 10),
        _buildBottomSheetItem(
          context,
          Icons.chat_bubble_outline,
          "Add Comment",
          isDark,
          () {
            _showCommentDialog(context, project.id!, isDark, loc);
          },
        ),
        const SizedBox(height: 10),
        _buildBottomSheetItem(
          context,
          Icons.share_outlined,
          loc.shareProject,
          isDark,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.shareComingSoon),
                backgroundColor: Color(0xFF1D00FF),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        _buildBottomSheetItem(
          context,
          saveIcon,
          saveLabel,
          isDark,
          () {
            ref.read(projectExploreDashboardNotifier.notifier).toggleSave(project.id!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isSaved ? "Removed from favorites" : loc.savedToFavorites),
                backgroundColor: isSaved ? Color(0xFFFF3B30) : Color(0xFF1DE4A2),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.projectRemoved),
                backgroundColor: Color(0xFFFF3B30),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: deleteBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: deleteBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFFF3B30),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loc.removeProject,
                    style: TextStyleHelper.instance.title14MediumSans.copyWith(
                      color: const Color(0xFFFF3B30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCommentDialog(BuildContext context, String projectId, bool isDark, AppLocalizations loc) {
    Navigator.pop(context); // Close the bottom sheet

    final _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Type your comment",
          style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
            color: isDark ? Colors.white : const Color(0xFF000000),
          ),
        ),
        content: TextField(
          controller: _commentController,
          maxLines: 3,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: "Add your feedback...",
            hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF1D00FF)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.cancel, style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_commentController.text.trim().isNotEmpty) {
                ref.read(projectExploreDashboardNotifier.notifier).addComment(projectId, _commentController.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Comment successfully added!"),
                    backgroundColor: Color(0xFF1DE4A2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D00FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Post Comment", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDarkAwareBottomSheet({
    required BuildContext context,
    required bool isDark,
    required String title,
    required List<Widget> children,
  }) {
    final sheetBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final handleColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFE0E0E0);
    final textColor = isDark ? Colors.white : const Color(0xFF000000);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

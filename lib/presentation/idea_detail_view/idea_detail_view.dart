import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_idea_generator/domain/models/idea_detail_model.dart';

import '../../core/app_export.dart';
import '../../core/config/env_config.dart';
import '../ideas_dashboard_screen/notifier/ideas_dashboard_notifier.dart';
import '../project_explore_dashboard_screen/notifier/project_explore_dashboard_notifier.dart';
import './notifier/idea_detail_notifier.dart';
import './widgets/idea_detail_header_widget.dart';
import './widgets/idea_action_bar_widget.dart';
import './widgets/idea_comment_section_widget.dart';
import './widgets/idea_attachments_widget.dart';

class IdeaDetailView extends ConsumerStatefulWidget {
  const IdeaDetailView({Key? key}) : super(key: key);

  @override
  ConsumerState<IdeaDetailView> createState() => _IdeaDetailViewState();
}

class _IdeaDetailViewState extends ConsumerState<IdeaDetailView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  IdeaDetailRouteArgs? _routeArgs;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is IdeaDetailRouteArgs) {
      _routeArgs = args;
      return;
    }

    if (args is String && args.trim().isNotEmpty) {
      _routeArgs = IdeaDetailRouteArgs(entityType: 'idea', id: args.trim());
      return;
    }

    if (args is Map<String, dynamic>) {
      final id = args['id']?.toString().trim() ?? '';
      final type = (args['entityType'] ?? args['type'] ?? 'idea')
          .toString()
          .toLowerCase()
          .trim();
      if (id.isNotEmpty) {
        _routeArgs = IdeaDetailRouteArgs(
          entityType: type == 'project' ? 'project' : 'idea',
          id: id,
        );
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final routeArgs = _routeArgs;
    if (routeArgs == null) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF7F7FB),
        body: _buildErrorState(),
      );
    }

    final detailProvider = ideaDetailNotifierProvider(routeArgs);
    final notifier = ref.watch(detailProvider);
    final idea = notifier.ideaDetail;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F0F1A)
          : const Color(0xFFF7F7FB),
      body: notifier.isLoading
          ? _buildLoadingState()
          : idea == null
          ? _buildErrorState()
          : FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  children: [
                    // Fixed header
                    IdeaDetailHeaderWidget(
                      idea: idea,
                      onBack: () => Navigator.pop(context),
                      onShare: () => _onShare(context, idea),
                      onMore: () => _showPostActions(context, idea),
                    ),
                    // Scrollable content
                    Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          // Status + meta row
                          SliverToBoxAdapter(
                            child: _buildMetaRow(context, idea, isRtl),
                          ),
                          // Overview section
                          SliverToBoxAdapter(
                            child: _buildSection(
                              context,
                              title: 'Overview',
                              icon: Icons.lightbulb_outline_rounded,
                              child: Builder(
                                builder: (ctx) {
                                  final isDark =
                                      Theme.of(ctx).brightness ==
                                      Brightness.dark;
                                  return Text(
                                    idea.description,
                                    textDirection: isRtl
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFFB0B0C8)
                                          : const Color(0xFF5A5A72),
                                      fontSize: 14,
                                      height: 1.75,
                                    ),
                                  );
                                },
                              ),
                              isRtl: isRtl,
                            ),
                          ),
                          // Details section
                          SliverToBoxAdapter(
                            child: _buildSection(
                              context,
                              title: 'Details',
                              icon: Icons.article_outlined,
                              child: Builder(
                                builder: (ctx) {
                                  final isDark =
                                      Theme.of(ctx).brightness ==
                                      Brightness.dark;
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1E1E2E)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF2A2A3E)
                                            : const Color(0xFFE8E8F4),
                                      ),
                                    ),
                                    child: Text(
                                      idea.fullContent,
                                      textDirection: isRtl
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFFCCCCDD)
                                            : const Color(0xFF2D2D3A),
                                        fontSize: 13.5,
                                        height: 1.8,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              isRtl: isRtl,
                            ),
                          ),
                          // Attachments
                          if (idea.attachments.isNotEmpty)
                            SliverToBoxAdapter(
                              child: _buildSection(
                                context,
                                title: 'Attachments',
                                icon: Icons.attach_file_rounded,
                                child: IdeaAttachmentsWidget(
                                  attachments: idea.attachments,
                                ),
                                isRtl: isRtl,
                                noPadding: true,
                              ),
                            ),
                          // Team members
                          // Divider
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 4,
                              ),
                              child: Divider(
                                color: const Color(0xFFE8E8F4),
                                thickness: 1,
                              ),
                            ),
                          ),
                          // Comments
                          SliverToBoxAdapter(
                            child: IdeaCommentSectionWidget(
                              comments: idea.comments,
                              commentText: notifier.commentText,
                              replyingToId: notifier.replyingToId,
                              replyText: notifier.replyText,
                              onCommentChanged: (text) => ref
                                  .read(
                                    detailProvider.notifier,
                                  )
                                  .updateCommentText(text),
                              onAddComment: () => ref
                                  .read(detailProvider.notifier)
                                  .addComment(),
                              onToggleCommentLike: (id) => ref
                                  .read(detailProvider.notifier)
                                  .toggleCommentLike(id),
                              onSetReplyingTo: (id) => ref
                                  .read(detailProvider.notifier)
                                  .setReplyingTo(id),
                              onReplyTextChanged: (text) => ref
                                  .read(detailProvider.notifier)
                                  .updateReplyText(text),
                              onAddReply: (parentId) => ref
                                  .read(detailProvider.notifier)
                                  .addReply(parentId),
                              onEditComment: (commentId, content) => ref
                                  .read(detailProvider.notifier)
                                  .editComment(commentId, content),
                            ),
                          ),
                          // Bottom padding for action bar
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 100),
                          ),
                        ],
                      ),
                    ),
                    // Fixed bottom action bar
                    IdeaActionBarWidget(
                      idea: idea,
                      onLike: () {
                        HapticFeedback.lightImpact();
                        ref.read(detailProvider.notifier).toggleLike();
                      },
                      onSave: () {
                        HapticFeedback.lightImpact();
                        ref.read(detailProvider.notifier).toggleSave();
                        _showSaveSnackbar(context, !idea.isSaved);
                      },
                      onEdit: () => _showEditBottomSheet(context),
                      onShare: () => _onShare(context, idea),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
    required bool isRtl,
    bool noPadding = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionIconBg = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFF1D00FF).withAlpha(18);
    final sectionIconColor = isDark
        ? const Color(0xFF6A59F1)
        : const Color(0xFF1D00FF);
    final titleColor = isDark ? Colors.white : const Color(0xFF1A1A2E);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: sectionIconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: sectionIconColor, size: 15),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          noPadding ? child : child,
        ],
      ),
    );
  }

  Widget _buildMetaRow(BuildContext context, IdeaDetailModel idea, bool isRtl) {
    final statusConfig = _getStatusConfig(idea.status);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Status chip
          if (idea.canEdit)
            GestureDetector(
              onTap: () => _showStatusPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusConfig['color'].withAlpha(24),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusConfig['color'].withAlpha(80),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusConfig['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      idea.status,
                      style: TextStyle(
                        color: statusConfig['color'],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: statusConfig['color'],
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          const Spacer(),
          // Views count
          Row(
            children: [
              Icon(
                Icons.remove_red_eye_outlined,
                color: const Color(0xFF9E9EBE),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${_formatViews(idea.viewCount)} views',
                style: TextStyle(color: const Color(0xFF9E9EBE), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF),
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading idea...',
            style: TextStyle(
              color: isDark ? const Color(0xFF6B6B8A) : const Color(0xFF9E9EBE),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFF3B30),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Could not load idea',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF2D2D3A),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Go Back',
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF6A59F1)
                    : const Color(0xFF1D00FF),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'In Progress':
        return {'color': const Color(0xFF1D00FF)};
      case 'Completed':
        return {'color': const Color(0xFF00C48C)};
      case 'To-do':
        return {'color': const Color(0xFFFFB800)};
      case 'Generated':
        return {'color': const Color(0xFF6A59F1)};
      default:
        return {'color': const Color(0xFF9E9EBE)};
    }
  }

  void _showStatusPicker(BuildContext context) {
    final args = _routeArgs;
    if (args == null) return;

    final detail = ref.read(ideaDetailNotifierProvider(args)).ideaDetail;
    if (detail == null || !detail.canEdit) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final handleColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFDEDEF0);
    final titleColor = isDark ? Colors.white : const Color(0xFF1A1A2E);

    final statuses = ['In Progress', 'To-do', 'Completed', 'Generated'];
    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Change Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 16),
            ...statuses.map((s) {
              final config = _getStatusConfig(s);
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                leading: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: config['color'],
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  s,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D2D3A),
                  ),
                ),
                onTap: () {
                  ref.read(ideaDetailNotifierProvider(args).notifier).updateStatus(s);
                  Navigator.pop(ctx);
                },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    final args = _routeArgs;
    if (args == null) return;
    final idea = ref.read(ideaDetailNotifierProvider(args)).ideaDetail;
    if (idea == null || !idea.canEdit) return;

    final titleController = TextEditingController(text: idea.title);
    final descController = TextEditingController(text: idea.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDEDEF0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Edit Idea',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: const Color(0xFF9E9EBE)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE8E8F4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE8E8F4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1D00FF),
                    width: 1.5,
                  ),
                ),
              ),
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: const Color(0xFF9E9EBE)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE8E8F4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE8E8F4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1D00FF),
                    width: 1.5,
                  ),
                ),
              ),
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(ideaDetailNotifierProvider(args).notifier)
                      .updateMainContent(
                        title: titleController.text,
                        description: descController.text,
                      );
                  if (!mounted) return;
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Idea updated successfully!',
                        style: TextStyle(),
                      ),
                      backgroundColor: const Color(0xFF00C48C),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D00FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostActions(BuildContext context, IdeaDetailModel idea) {
    if (!idea.canEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Only the owner can manage this post.', style: TextStyle()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final makePrivate = idea.isPublic;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDEDEF0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(
                  makePrivate
                      ? Icons.lock_outline_rounded
                      : Icons.public_rounded,
                  color: const Color(0xFF1D00FF),
                ),
                title: Text(
                  makePrivate ? 'Make Private' : 'Make Public',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  makePrivate
                      ? 'Only you can open this post.'
                      : 'Everyone can open and comment.',
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final args = _routeArgs;
                  if (args == null) return;

                  final ok = await ref
                      .read(ideaDetailNotifierProvider(args).notifier)
                      .toggleVisibility();
                  if (!mounted) return;

                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not update visibility.', style: TextStyle()),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  _refreshDashboards(args.entityType);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        makePrivate
                            ? 'Post is now private.'
                            : 'Post is now public.',
                        style: TextStyle(),
                      ),
                      backgroundColor: const Color(0xFF1D00FF),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: const Color(0xFFFF3B30),
                ),
                title: Text(
                  'Delete Post',
                  style: TextStyle(
                    color: const Color(0xFFFF3B30),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text('This action cannot be undone.'),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(context, idea);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, IdeaDetailModel idea) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete post?',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This will permanently delete "${idea.title}".',
          style: TextStyle(
            color: isDark ? const Color(0xFFB0B0C8) : const Color(0xFF5A5A72),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
            ),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final args = _routeArgs;
    if (args == null) return;

    final deleted = await ref
        .read(ideaDetailNotifierProvider(args).notifier)
        .deleteEntity();
    if (!mounted) return;

    if (!deleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not delete post.', style: TextStyle()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _refreshDashboards(args.entityType);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post deleted.', style: TextStyle()),
        backgroundColor: const Color(0xFFFF3B30),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  void _refreshDashboards(String entityType) {
    if (entityType == 'project') {
      ref.invalidate(projectExploreDashboardNotifier);
      return;
    }
    ref.invalidate(ideasDashboardNotifier);
  }

  void _onShare(BuildContext context, IdeaDetailModel idea) {
    final routePath = AppRoutes.buildIdeaDetailPath(idea.id);
    final link = _buildAbsoluteShareLink(routePath);

    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link copied: $link', style: TextStyle()),
        backgroundColor: const Color(0xFF1D00FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSaveSnackbar(BuildContext context, bool saving) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saving
              ? 'Idea saved to your collection!'
              : 'Removed from saved ideas',
          style: TextStyle(),
        ),
        backgroundColor: saving
            ? const Color(0xFF1D00FF)
            : const Color(0xFF818181),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatViews(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}m';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  String _buildAbsoluteShareLink(String routePath) {
    final configuredBase = EnvConfig.publicWebBaseUrl;
    final configuredUri = Uri.tryParse(configuredBase);
    if (configuredUri != null &&
        configuredUri.hasAuthority &&
        (configuredUri.scheme == 'http' || configuredUri.scheme == 'https')) {
      return configuredUri.replace(path: routePath).toString();
    }

    final base = Uri.base;
    final hasWebOrigin = base.hasAuthority &&
        (base.scheme == 'http' || base.scheme == 'https');
    if (!hasWebOrigin) {
      return routePath;
    }

    final uri = Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path: routePath,
    );
    return uri.toString();
  }
}

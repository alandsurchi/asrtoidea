import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import './notifier/idea_detail_notifier.dart';
import './widgets/idea_detail_header_widget.dart';
import './widgets/idea_action_bar_widget.dart';
import './widgets/idea_comment_section_widget.dart';
import './widgets/idea_attachments_widget.dart';
import './widgets/idea_team_members_widget.dart';

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
  String? _ideaId;
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
    if (args is String) {
      _ideaId = args;
    } else if (args is Map<String, dynamic>) {
      _ideaId = args['id'] as String?;
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
    final notifier = ref.watch(ideaDetailNotifierProvider(_ideaId));
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
                      onShare: () => _onShare(context),
                    ),
                    // Scrollable content
                    Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          // Status + meta row
                          SliverToBoxAdapter(
                            child: _buildMetaRow(context, idea.status, isRtl),
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
                          if (idea.teamMembers.isNotEmpty)
                            SliverToBoxAdapter(
                              child: _buildSection(
                                context,
                                title: 'Team',
                                icon: Icons.group_outlined,
                                child: IdeaTeamMembersWidget(
                                  teamMembers: idea.teamMembers,
                                ),
                                isRtl: isRtl,
                                noPadding: true,
                              ),
                            ),
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
                                    ideaDetailNotifierProvider(
                                      _ideaId,
                                    ).notifier,
                                  )
                                  .updateCommentText(text),
                              onAddComment: () => ref
                                  .read(
                                    ideaDetailNotifierProvider(
                                      _ideaId,
                                    ).notifier,
                                  )
                                  .addComment(),
                              onToggleCommentLike: (id) => ref
                                  .read(
                                    ideaDetailNotifierProvider(
                                      _ideaId,
                                    ).notifier,
                                  )
                                  .toggleCommentLike(id),
                              onSetReplyingTo: (id) => ref
                                  .read(
                                    ideaDetailNotifierProvider(
                                      _ideaId,
                                    ).notifier,
                                  )
                                  .setReplyingTo(id),
                              onReplyTextChanged: (text) => ref
                                  .read(
                                    ideaDetailNotifierProvider(
                                      _ideaId,
                                    ).notifier,
                                  )
                                  .updateReplyText(text),
                              onAddReply: (parentId) => ref
                                  .read(
                                    ideaDetailNotifierProvider(
                                      _ideaId,
                                    ).notifier,
                                  )
                                  .addReply(parentId),
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
                        ref
                            .read(ideaDetailNotifierProvider(_ideaId).notifier)
                            .toggleLike();
                      },
                      onSave: () {
                        HapticFeedback.lightImpact();
                        ref
                            .read(ideaDetailNotifierProvider(_ideaId).notifier)
                            .toggleSave();
                        _showSaveSnackbar(context, !idea.isSaved);
                      },
                      onEdit: () => _showEditBottomSheet(context),
                      onShare: () => _onShare(context),
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

  Widget _buildMetaRow(BuildContext context, String status, bool isRtl) {
    final statusConfig = _getStatusConfig(status);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Status chip
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
                    status,
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
                '1.2k views',
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
                  ref
                      .read(ideaDetailNotifierProvider(_ideaId).notifier)
                      .updateStatus(s);
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
    final idea = ref.read(ideaDetailNotifierProvider(_ideaId)).ideaDetail;
    if (idea == null) return;
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
                onPressed: () {
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

  void _onShare(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link copied to clipboard!', style: TextStyle()),
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
}

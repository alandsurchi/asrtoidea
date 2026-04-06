import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../ideas_dashboard_screen/ideas_dashboard_screen.dart';
import '../magic_idea_chat_screen/magic_idea_chat_screen.dart';
import '../notification_center_screen/notification_center_screen.dart';
import '../project_explore_dashboard_screen/project_explore_dashboard_screen.dart';
import '../settings_screen/settings_screen.dart';
import '../ideas_dashboard_screen/notifier/ideas_dashboard_notifier.dart';
import '../magic_idea_chat_screen/notifier/magic_idea_chat_notifier.dart';
import 'package:ai_idea_generator/domain/models/ideas_dashboard_model.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({Key? key}) : super(key: key);

  static final GlobalKey<MainShellScreenState> shellKey =
      GlobalKey<MainShellScreenState>();

  static void goToNotifications() {
    shellKey.currentState?.switchToNotifications();
  }

  static void goToTab(int pageIndex) {
    shellKey.currentState?.switchToTab(pageIndex);
  }

  @override
  MainShellScreenState createState() => MainShellScreenState();
}

class MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _selectedIndex = 0;

  // Single source of truth: navIndex -> pageIndex.
  static const Map<int, int> _navToPage = {0: 0, 1: 1, 2: 3, 3: 4};
  static final Map<int, int> _pageToNav = {for (final e in _navToPage.entries) e.value: e.key};

  final List<Widget> _pages = [
    IdeasDashboardScreen(),
    ProjectExploreDashboardScreen(),
    const MagicIdeaChatScreen(),
    const _StatsPage(),
    SettingsScreen(),
    NotificationCenterScreen(),
  ];

  void switchToNotifications() => setState(() => _selectedIndex = 5);

  void switchToTab(int pageIndex) => setState(() => _selectedIndex = pageIndex);

  void _onNavTapped(int navIndex) {
    final pageIndex = _navToPage[navIndex];
    if (pageIndex != null) setState(() => _selectedIndex = pageIndex);
  }

  /// -1 when current page has no bottom-nav entry (Chat, Notifications).
  int get _navSelectedIndex => _pageToNav[_selectedIndex] ?? -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        top: false,
        left: false,
        right: false,
        child: _buildBottomNavBar(isDark, context),
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDark, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final items = <CustomBottomNavigationItem>[
      CustomBottomNavigationItem(
        icon: ImageConstant.imgHome04,
        activeIcon: ImageConstant.imgHome04deepPurpleA700,
        label: loc.navHome,
        routeName: AppRoutes.ideasDashboardScreen,
      ),
      CustomBottomNavigationItem(
        icon: ImageConstant.imgContrast,
        activeIcon: ImageConstant.imgContrastDeepPurpleA700,
        label: loc.navExplore,
        routeName: AppRoutes.projectExploreDashboardScreen,
      ),
      CustomBottomNavigationItem(
        icon: ImageConstant.imgBarChartSquare02,
        label: loc.navStats,
        routeName: AppRoutes.projectExploreDashboardScreen,
      ),
      CustomBottomNavigationItem(
        icon: ImageConstant.imgUserProfileCircle,
        activeIcon: ImageConstant.imgUserProfileCircleDeepPurpleA700,
        label: loc.navProfile,
        routeName: AppRoutes.settingsScreen,
      ),
    ];

    return Container(
      margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 8.h),
      child: CustomBottomNavigationBar(
        items: items,
        selectedIndex: _navSelectedIndex,
        onItemTapped: _onNavTapped,
        centerButtonIcon: ImageConstant.imgGroup1000006182,
        onCenterButtonTapped: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        margin: EdgeInsets.zero,
      ),
    );
  }
}

class _ActivityItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final Color color;

  _ActivityItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.color,
  });
}

// ─── Stats Page ───────────────────────────────────────────────────────────────
class _StatsPage extends ConsumerWidget {
  const _StatsPage({Key? key}) : super(key: key);

  double _calculateCategoryProgress(List<IdeaCardModel> ideas, String category) {
    final categoryIdeas = ideas.where((i) => i.category == category).toList();
    if (categoryIdeas.isEmpty) return 0.0;
    final completed = categoryIdeas.where((i) => i.status == 'Done' || i.status == 'Completed').length;
    return completed / categoryIdeas.length;
  }

  String _formatTimeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Watch precise rivers
    final ideasState = ref.watch(ideasDashboardNotifier);
    final allIdeasList = ideasState.ideasDashboardModel?.allIdeasList ?? [];

    final magicChatState = ref.watch(magicIdeaChatNotifier);
    final chatHistory = magicChatState.chatHistory ?? [];

    // Calculate Top Level Overviews
    final totalIdeas = allIdeasList.length.toString();
    final completedIdeasCount = allIdeasList.where((i) => i.status == 'Done' || i.status == 'Completed').length.toString();
    final inProgressIdeasCount = allIdeasList.where((i) => i.status == 'In Progress' || i.status == 'To-do').length.toString();
    final aiGeneratedCount = chatHistory.length.toString();

    // Map Recent Activities
    final List<_ActivityItemData> combinedActivities = [];
    
    for (var idea in allIdeasList) {
      combinedActivities.add(
        _ActivityItemData(
          icon: idea.status == 'Done' || idea.status == 'Completed' ? Icons.check_circle_outline : Icons.add_circle_outline,
          title: idea.status == 'Done' || idea.status == 'Completed' ? loc.ideaCompleted : loc.newIdeaCreated,
          subtitle: idea.title ?? 'Unknown Idea',
          timestamp: idea.timestamp ?? DateTime.now(),
          color: idea.status == 'Done' || idea.status == 'Completed' ? const Color(0xFF1DE4A2) : const Color(0xFF1D00FF),
        )
      );
    }
    
    for (var chat in chatHistory) {
      combinedActivities.add(
        _ActivityItemData(
          icon: Icons.auto_awesome,
          title: loc.aiGeneratedIdea,
          subtitle: chat.title ?? 'Generated Interaction',
          timestamp: chat.timestamp ?? DateTime.now(),
          color: const Color(0xFF6A59F1),
        )
      );
    }

    // Sort heavily & Limit exactly to 4 length
    combinedActivities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final recentActivitiesToDisplay = combinedActivities.take(4).toList();
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final subTextColor = isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF666666);
    final progressBgColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFEEEEEE);
    final activityCardColor = isDark
        ? const Color(0xFF1E1E2E)
        : const Color(0xFFF8F8FF);
    final activityBorderColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFEBEBFF);

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  loc.statistics,
                  style: TextStyleHelper.instance.headline24SemiBoldPoppins
                      .copyWith(color: textColor),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: loc.totalIdeas,
                      value: totalIdeas,
                      icon: Icons.lightbulb_outline,
                      color: const Color(0xFF1D00FF),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: loc.completedIdeas,
                      value: completedIdeasCount,
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFF1DE4A2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: loc.inProgressIdeas,
                      value: inProgressIdeasCount,
                      icon: Icons.pending_outlined,
                      color: const Color(0xFFFBD060),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: loc.aiGenerated,
                      value: aiGeneratedCount,
                      icon: Icons.auto_awesome,
                      color: const Color(0xFF6A59F1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                loc.monthlyProgress,
                style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildProgressBar(
                loc.design,
                _calculateCategoryProgress(allIdeasList, 'Design'),
                const Color(0xFF1D00FF),
                textColor,
                progressBgColor,
              ),
              const SizedBox(height: 12),
              _buildProgressBar(
                loc.development,
                _calculateCategoryProgress(allIdeasList, 'Development'),
                const Color(0xFF6A59F1),
                textColor,
                progressBgColor,
              ),
              const SizedBox(height: 12),
              _buildProgressBar(
                loc.marketing,
                _calculateCategoryProgress(allIdeasList, 'Marketing'),
                const Color(0xFFFBD060),
                textColor,
                progressBgColor,
              ),
              const SizedBox(height: 12),
              _buildProgressBar(
                loc.research,
                _calculateCategoryProgress(allIdeasList, 'Research'),
                const Color(0xFF1DE4A2),
                textColor,
                progressBgColor,
              ),
              const SizedBox(height: 28),
              Text(
                loc.recentActivity,
                style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              if (recentActivitiesToDisplay.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      'No recent activity found',
                      style: TextStyleHelper.instance.title13MediumPoppins.copyWith(color: subTextColor),
                    ),
                  ),
                )
              else
                ...recentActivitiesToDisplay.map((activity) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildActivityItem(
                      activity.icon,
                      activity.title,
                      activity.subtitle,
                      _formatTimeAgo(activity.timestamp),
                      activity.color,
                      textColor,
                      subTextColor,
                      activityCardColor,
                      activityBorderColor,
                    ),
                  );
                }).toList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    String label,
    double value,
    Color color,
    Color textColor,
    Color bgColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyleHelper.instance.title13MediumPoppins.copyWith(
                color: textColor,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyleHelper.instance.title13SemiBoldPoppins.copyWith(
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: bgColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    String title,
    String subtitle,
    String time,
    Color color,
    Color textColor,
    Color subTextColor,
    Color cardColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.instance.title13SemiBoldPoppins
                      .copyWith(color: textColor),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
                    color: subTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyleHelper.instance.label11RegularSans.copyWith(
              color: subTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF666666);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(isDark ? 30 : 15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(isDark ? 60 : 40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyleHelper.instance.headline24SemiBoldPoppins.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}

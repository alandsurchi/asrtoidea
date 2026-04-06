import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../main_shell_screen/main_shell_screen.dart';
import './widgets/home_filter_tabs_widget.dart';
import './widgets/home_search_bar_widget.dart';
import './widgets/idea_detail_bottom_sheet.dart';
import './widgets/interactive_idea_card_widget.dart';

class InteractiveIdeasHome extends ConsumerStatefulWidget {
  const InteractiveIdeasHome({Key? key}) : super(key: key);

  @override
  InteractiveIdeasHomeState createState() => InteractiveIdeasHomeState();
}

class InteractiveIdeasHomeState extends ConsumerState<InteractiveIdeasHome> {
  int _selectedFilterIndex = 0;
  int _notificationCount = 3;

  final List<Map<String, dynamic>> _ideas = [
    {
      'title': 'AI-Powered Landing Page Generator',
      'category': 'Web',
      'status': 'In Progress',
      'timeAgo': '2h ago',
      'cardColor': const Color(0xFF3B1FCC),
      'imageUrl':
          'https://images.unsplash.com/photo-1467232004584-a241de8bcf5d?w=600&q=80',
      'likeCount': 24,
      'commentCount': 8,
      'isLiked': false,
      'isSaved': true,
      'author': 'Aram Satar',
      'description':
          'A smart tool that generates beautiful, conversion-optimized landing pages from a simple prompt. Uses AI to understand your product and create compelling copy, layout, and visuals automatically.',
    },
    {
      'title': 'Smart Inventory Management SaaS',
      'category': 'SaaS',
      'status': 'Completed',
      'timeAgo': '5h ago',
      'cardColor': const Color(0xFF0D6E6E),
      'imageUrl':
          'https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?w=600',
      'likeCount': 41,
      'commentCount': 12,
      'isLiked': true,
      'isSaved': false,
      'author': 'Sara K.',
      'description':
          'A comprehensive inventory management platform for small and medium businesses. Features real-time tracking, predictive restocking alerts, and seamless integration with popular e-commerce platforms.',
    },
    {
      'title': 'Personalized Fitness Coach App',
      'category': 'Mobile',
      'status': 'Generated',
      'timeAgo': '1d ago',
      'cardColor': const Color(0xFF7C2D12),
      'imageUrl':
          'https://images.pixabay.com/photo/2017/08/07/19/26/fitness-2604149_1280.jpg',
      'likeCount': 18,
      'commentCount': 5,
      'isLiked': false,
      'isSaved': false,
      'author': 'Mike R.',
      'description':
          'An AI fitness coach that creates personalized workout and nutrition plans based on your goals, body metrics, and available equipment. Adapts in real-time based on your progress and feedback.',
    },
    {
      'title': 'Collaborative Whiteboard for Remote Teams',
      'category': 'Productivity',
      'status': 'In Progress',
      'timeAgo': '2d ago',
      'cardColor': const Color(0xFF1E3A5F),
      'imageUrl':
          'https://images.unsplash.com/photo-1552664730-d307ca884978?w=600&q=80',
      'likeCount': 33,
      'commentCount': 9,
      'isLiked': false,
      'isSaved': true,
      'author': 'Lena M.',
      'description':
          'A real-time collaborative whiteboard designed for distributed teams. Features AI-assisted diagramming, smart templates, and seamless video call integration for brainstorming sessions.',
    },
  ];

  List<Map<String, dynamic>> get _filteredIdeas {
    if (_selectedFilterIndex == 0) return _ideas;
    final filters = ['All', 'In Progress', 'To-do', 'Completed'];
    final filter = filters[_selectedFilterIndex];
    return _ideas.where((i) => i['status'] == filter).toList();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1200));
  }

  void _openIdeaDetail(Map<String, dynamic> idea) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IdeaDetailBottomSheet(
        title: idea['title'] as String,
        category: idea['category'] as String,
        status: idea['status'] as String,
        description: idea['description'] as String,
        author: idea['author'] as String,
        timeAgo: idea['timeAgo'] as String,
        cardColor: idea['cardColor'] as Color,
        likeCount: idea['likeCount'] as int,
        commentCount: idea['commentCount'] as int,
        isLiked: idea['isLiked'] as bool,
        isSaved: idea['isSaved'] as bool,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: const Color(0xFF1D00FF),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildWelcomeBanner()),
              SliverToBoxAdapter(child: _buildSearchSection()),
              SliverToBoxAdapter(child: _buildFilterSection()),
              SliverToBoxAdapter(child: _buildSectionHeader()),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final idea = _filteredIdeas[index];
                    return InteractiveIdeaCardWidget(
                      title: idea['title'] as String,
                      category: idea['category'] as String,
                      status: idea['status'] as String,
                      timeAgo: idea['timeAgo'] as String,
                      cardColor: idea['cardColor'] as Color,
                      imageUrl: idea['imageUrl'] as String?,
                      likeCount: idea['likeCount'] as int,
                      commentCount: idea['commentCount'] as int,
                      isLiked: idea['isLiked'] as bool,
                      isSaved: idea['isSaved'] as bool,
                      onTap: () => _openIdeaDetail(idea),
                      onComment: () => _openIdeaDetail(idea),
                    );
                  }, childCount: _filteredIdeas.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 16.h, 20.h, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44.h,
            height: 44.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF3B1FCC)],
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back 👋',
                  style: TextStyleHelper.instance.title13MediumPoppins.copyWith(
                    color: const Color(0xFF888888),
                  ),
                ),
                Text(
                  'Aram Satar',
                  style: TextStyleHelper.instance.title16SemiBoldPoppins
                      .copyWith(color: const Color(0xFF1A1A2E)),
                ),
              ],
            ),
          ),
          // Notification bell
          GestureDetector(
            onTap: () => MainShellScreen.goToNotifications(),
            child: Stack(
              children: [
                Container(
                  width: 44.h,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBD060),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF433408),
                    size: 22,
                  ),
                ),
                if (_notificationCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$_notificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.h, 20.h, 20.h, 0),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B1FCC), Color(0xFF7C3AED), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B1FCC).withAlpha(102),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You have 7 ideas\nfor today ✨',
                  style: TextStyleHelper.instance.headline20SemiBoldPoppins
                      .copyWith(color: Colors.white, height: 1.3),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () => MainShellScreen.goToTab(2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: Text(
                      'Generate New →',
                      style: TextStyleHelper.instance.title13SemiBoldPoppins
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFD4AF37),
            size: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 20.h, 20.h, 0),
      child: HomeSearchBarWidget(onChanged: (_) {}, onFilterTap: () {}),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 16.h, 20.h, 0),
      child: HomeFilterTabsWidget(
        selectedIndex: _selectedFilterIndex,
        onTabSelected: (i) => setState(() => _selectedFilterIndex = i),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 20.h, 20.h, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Ideas',
            style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
              color: const Color(0xFF1A1A2E),
            ),
          ),
          Text(
            'See all',
            style: TextStyleHelper.instance.title13MediumPoppins.copyWith(
              color: const Color(0xFF1D00FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => MainShellScreen.goToTab(2),
      backgroundColor: const Color(0xFF1D00FF),
      icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
      label: Text(
        'New Idea',
        style: TextStyleHelper.instance.title13SemiBoldPoppins.copyWith(
          color: Colors.white,
        ),
      ),
      elevation: 8,
    );
  }
}

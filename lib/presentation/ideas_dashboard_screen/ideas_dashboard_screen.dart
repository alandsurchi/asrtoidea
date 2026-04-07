import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:ai_idea_generator/domain/models/ideas_dashboard_model.dart';
import 'package:ai_idea_generator/core/utils/detail_navigation_resolver.dart';

import '../../core/app_export.dart';
import '../main_shell_screen/main_shell_screen.dart';
import '../settings_screen/notifier/settings_notifier.dart';
import './widgets/idea_card_widget.dart';
import './widgets/status_filter_tab.dart';
import 'notifier/ideas_dashboard_notifier.dart';

class IdeasDashboardScreen extends ConsumerStatefulWidget {
  IdeasDashboardScreen({Key? key}) : super(key: key);

  @override
  IdeasDashboardScreenState createState() => IdeasDashboardScreenState();
}

class IdeasDashboardScreenState extends ConsumerState<IdeasDashboardScreen> {
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: isRtl
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                _buildAppBarSection(context, isRtl),
                _buildWelcomeSection(context, isRtl, isDark),
                _buildSearchSection(context, isDark),
                _buildIdeaCarouselSection(context, isDark),
                _buildStatusFilterSection(context, isRtl),
                _buildIdeaListSection(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarSection(BuildContext context, bool isRtl) {
    final loc = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, _) {
        final settingsModel = ref.watch(settingsNotifier).settingsModel;
        final displayName = _resolveDisplayName(
          settingsModel?.userName,
          settingsModel?.userEmail,
        );
        final profileImagePath = _sanitizeProfileImagePath(
          settingsModel?.profileImagePath,
        );

        return CustomAppBar(
          profileImagePath: profileImagePath,
          userName: displayName,
          welcomeMessage: loc.welcomeBack,
          showProfile: true,
          actions: [
            GestureDetector(
              onTap: () {
                MainShellScreen.goToNotifications();
              },
              child: Container(
                width: 40.h,
                height: 40.h,
                padding: EdgeInsets.all(8.h),
                margin: isRtl
                    ? EdgeInsets.only(right: 8.h)
                    : EdgeInsets.only(left: 8.h),
                decoration: BoxDecoration(
                  color: Color(0xFFFBD060),
                  borderRadius: BorderRadius.circular(10.h),
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgGroup90,
                  height: 24.h,
                  width: 24.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _resolveDisplayName(String? userName, String? userEmail) {
    final name = userName?.trim() ?? '';
    if (name.isNotEmpty) {
      return name;
    }

    final email = userEmail?.trim() ?? '';
    if (email.contains('@')) {
      final localPart = email.split('@').first.trim();
      if (localPart.isNotEmpty) {
        return localPart;
      }
    }

    return 'User';
  }

  String? _sanitizeProfileImagePath(String? imagePath) {
    final value = imagePath?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }

    final legacyPlaceholders = <String>{
      ImageConstant.imgUserProfilePhoto,
      ImageConstant.imgImage,
      ImageConstant.imgImage176x160,
    };

    if (legacyPlaceholders.contains(value)) {
      return null;
    }

    return value;
  }

  Widget _buildWelcomeSection(BuildContext context, bool isRtl, bool isDark) {
    final loc = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(ideasDashboardNotifier);
        final totalIdeasList = state.ideasDashboardModel?.allIdeasList ?? [];
        final totalIdeas = totalIdeasList.length + (state.ideasDashboardModel?.ideaCardsList?.length ?? 0);
        return Container(
          margin: isRtl
              ? EdgeInsets.only(top: 14.h, right: 20.h)
              : EdgeInsets.only(top: 14.h, left: 20.h),
          child: Text(
            'You have $totalIdeas\n${loc.ideasForToday}',
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyleHelper.instance.headline24SemiBoldPoppins.copyWith(
              color: isDark ? Colors.white : const Color(0xFF000000),
              height: 1.5,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchSection(BuildContext context, bool isDark) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final loc = AppLocalizations.of(context)!;
    final borderColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFE0E0E0);
    final fillColor = isDark ? const Color(0xFF1E1E2E) : Colors.transparent;
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final hintColor = isDark
        ? const Color(0xFF6B6B8A)
        : const Color(0xFF000000).withAlpha(128);

    return Container(
      margin: EdgeInsets.only(top: 8.h, left: 20.h, right: 20.h),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                ref
                    .read(ideasDashboardNotifier.notifier)
                    .onSearchChanged(value);
              },
              style: TextStyleHelper.instance.title15SemiBoldPoppins.copyWith(
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: loc.search,
                hintStyle: TextStyleHelper.instance.title15SemiBoldPoppins
                    .copyWith(color: hintColor),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgSearch,
                    height: 24.h,
                    width: 24.h,
                    color: isDark ? Colors.white54 : null,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 8.h,
                ),
                filled: isDark,
                fillColor: fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: borderColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: borderColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF6A59F1)
                        : const Color(0xFF1D00FF),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.h),
          GestureDetector(
            onTap: () => _onTapFilterButton(context),
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 14.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1D00FF), Color(0xFF6A59F1)],
                ),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D00FF).withAlpha(60),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune_rounded, color: Colors.white, size: 20.h),
                  SizedBox(width: 6.h),
                  Text(
                    loc.filter,
                    style: TextStyleHelper.instance.title13SemiBoldPoppins
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdeaCarouselSection(BuildContext context, bool isDark) {
    return Container(
      margin: EdgeInsets.only(top: 34.h, left: 20.h, right: 20.h),
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(ideasDashboardNotifier);
              return CarouselSlider(
                controller: carouselController,
                options: CarouselOptions(
                  height: 250.h,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    ref
                        .read(ideasDashboardNotifier.notifier)
                        .updateCarouselIndex(index);
                  },
                ),
                items:
                    state.ideasDashboardModel?.ideaCardsList?.map((idea) {
                      return IdeaCardWidget(
                        idea: idea,
                        onTap: () {
                          _onTapIdeaCard(context, idea);
                        },
                      );
                    }).toList() ??
                    [],
              );
            },
          ),
          SizedBox(height: 20.h),
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(ideasDashboardNotifier);
              final currentIndex = state.currentCarouselIndex ?? 0;
              final totalItems =
                  state.ideasDashboardModel?.ideaCardsList?.length ?? 0;
              return _CarouselDots(
                count: totalItems,
                activeIndex: currentIndex,
                isDark: isDark,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilterSection(BuildContext context, bool isRtl) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.only(top: 24.h, left: 20.h, right: 20.h),
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(ideasDashboardNotifier);
          final allIdeas = state.ideasDashboardModel?.allIdeasList ?? [];
          
          final inProgressCount = allIdeas.where((i) => i.status == 'In Progress').length.toString();
          final toDoCount = allIdeas.where((i) => i.status == 'To-do').length.toString();
          final completedCount = allIdeas.where((i) => i.status == 'Completed').length.toString();
          final generatedCount = allIdeas.where((i) => i.status == 'Generated').length.toString();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: isRtl,
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              children: [
                StatusFilterTab(
                  title: loc.inProgress,
                  count: inProgressCount,
                  isSelected: state.selectedFilterIndex == 0,
                  onTap: () => ref
                      .read(ideasDashboardNotifier.notifier)
                      .updateSelectedFilter(0),
                ),
                SizedBox(width: 4.h),
                StatusFilterTab(
                  title: loc.toDo,
                  count: toDoCount,
                  isSelected: state.selectedFilterIndex == 1,
                  onTap: () => ref
                      .read(ideasDashboardNotifier.notifier)
                      .updateSelectedFilter(1),
                ),
                SizedBox(width: 4.h),
                StatusFilterTab(
                  title: loc.completed,
                  count: completedCount,
                  isSelected: state.selectedFilterIndex == 2,
                  onTap: () => ref
                      .read(ideasDashboardNotifier.notifier)
                      .updateSelectedFilter(2),
                ),
                SizedBox(width: 4.h),
                StatusFilterTab(
                  title: loc.generated,
                  count: generatedCount,
                  isSelected: state.selectedFilterIndex == 3,
                  onTap: () => ref
                      .read(ideasDashboardNotifier.notifier)
                      .updateSelectedFilter(3),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIdeaListSection(BuildContext context, bool isDark) {
    final loc = AppLocalizations.of(context)!;
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final cardColor = isDark
        ? const Color(0xFF1E1E2E)
        : const Color(0xFFF8F8FF);
    final borderColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFEBEBFF);
    final categoryBgColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFEBEBFF);
    final categoryTextColor = isDark
        ? const Color(0xFF6A59F1)
        : const Color(0xFF1D00FF);
    final subTextColor = isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF888888);
    final arrowColor = isDark
        ? const Color(0xFF6B6B8A)
        : const Color(0xFFBBBBBB);
    final thumbBgColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFEBEBFF);

    return Container(
      margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(ideasDashboardNotifier);

          if (state.isLoading ?? false) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(50.h),
                child: CircularProgressIndicator(
                  color: isDark
                      ? const Color(0xFF6A59F1)
                      : const Color(0xFF1D00FF),
                ),
              ),
            );
          }

          final ideas = state.ideasDashboardModel?.additionalIdeasList ?? [];
          if (ideas.isEmpty) return SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.recentIdeas,
                    style: TextStyleHelper.instance.title16SemiBoldPoppins
                        .copyWith(color: textColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.projectExploreDashboardScreen,
                      );
                    },
                    child: Text(
                      loc.seeAll,
                      style: TextStyleHelper.instance.title13MediumPoppins
                          .copyWith(
                            color: isDark
                                ? const Color(0xFF6A59F1)
                                : const Color(0xFF1D00FF),
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemCount: ideas.length,
                itemBuilder: (context, index) {
                  final idea = ideas[index];
                  return _buildCompactIdeaCard(
                    context,
                    idea,
                    isDark,
                    textColor,
                    cardColor,
                    borderColor,
                    categoryBgColor,
                    categoryTextColor,
                    subTextColor,
                    arrowColor,
                    thumbBgColor,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompactIdeaCard(
    BuildContext context,
    IdeaCardModel idea,
    bool isDark,
    Color textColor,
    Color cardColor,
    Color borderColor,
    Color categoryBgColor,
    Color categoryTextColor,
    Color subTextColor,
    Color arrowColor,
    Color thumbBgColor,
  ) {
    return GestureDetector(
      onTap: () => _onTapIdeaCard(context, idea),
      child: Container(
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 56.h,
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: thumbBgColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: _buildIdeaThumbnail(
                  idea,
                  thumbBgColor,
                  categoryTextColor,
                ),
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.h,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: categoryBgColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          idea.category ?? '',
                          style: TextStyleHelper.instance.title12MediumPoppins
                              .copyWith(color: categoryTextColor),
                        ),
                      ),
                      SizedBox(width: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.h,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: idea.priority == 'High'
                              ? (isDark
                                    ? const Color(0xFF2A1515)
                                    : const Color(0xFFFFEEEE))
                              : (isDark
                                    ? const Color(0xFF2A2010)
                                    : const Color(0xFFFFF8E1)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          idea.priority ?? '',
                          style: TextStyleHelper.instance.title12MediumPoppins
                              .copyWith(
                                color: idea.priority == 'High'
                                    ? const Color(0xFFFF3B30)
                                    : const Color(0xFFCC9300),
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    idea.title ?? '',
                    style: TextStyleHelper.instance.title14SemiBoldPoppins
                        .copyWith(color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    idea.status ?? '',
                    style: TextStyleHelper.instance.title12MediumPoppins
                        .copyWith(color: subTextColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: arrowColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeaThumbnail(
    IdeaCardModel idea,
    Color fallbackColor,
    Color iconColor,
  ) {
    final backgroundValue = (idea.backgroundImage ?? '').trim();
    final customColor = _parseCardColor(backgroundValue);

    if (customColor != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _shiftColorLightness(customColor, 0.1),
              _shiftColorLightness(customColor, -0.1),
            ],
          ),
        ),
        child: Icon(
          Icons.lightbulb_outline,
          color: Colors.white.withValues(alpha: 0.85),
          size: 28.h,
        ),
      );
    }

    if (backgroundValue.isNotEmpty) {
      return Image.asset(
        backgroundValue,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: fallbackColor,
          child: Icon(
            Icons.lightbulb_outline,
            color: iconColor,
            size: 28.h,
          ),
        ),
      );
    }

    return Container(
      color: fallbackColor,
      child: Icon(
        Icons.lightbulb_outline,
        color: iconColor,
        size: 28.h,
      ),
    );
  }

  Color? _parseCardColor(String value) {
    if (value.isEmpty) return null;

    final normalized = value.toLowerCase().startsWith('color:')
        ? value.substring('color:'.length)
        : value;
    final cleaned = normalized.trim().replaceAll('#', '');
    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(cleaned)) return null;
    final full = 'FF${cleaned.toUpperCase()}';
    return Color(int.parse(full, radix: 16));
  }

  Color _shiftColorLightness(Color color, double delta) {
    final hsl = HSLColor.fromColor(color);
    final adjusted = (hsl.lightness + delta).clamp(0.0, 1.0).toDouble();
    return hsl.withLightness(adjusted).toColor();
  }

  void _onTapFilterButton(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final subTextColor = isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF888888);
    final chipBg = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0FF);
    final chipBorder = isDark
        ? const Color(0xFF6A59F1).withAlpha(60)
        : const Color(0xFF1D00FF).withAlpha(60);
    final chipText = isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF);
    final handleColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFE0E0E0);

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
              loc.filterIdeas,
              style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
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
              children:
                  [
                    loc.all,
                    loc.inProgress,
                    loc.toDo,
                    loc.completed,
                    loc.generated,
                  ].map((label) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
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
                          style: TextStyleHelper.instance.title13MediumPoppins
                              .copyWith(color: chipText),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              loc.priority,
              style: TextStyleHelper.instance.title13SemiBoldPoppins.copyWith(
                color: subTextColor,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [loc.all, loc.high, loc.medium, loc.low].map((label) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${loc.priority}: $label'),
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
                      style: TextStyleHelper.instance.title13MediumPoppins
                          .copyWith(color: chipText),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? const Color(0xFF6A59F1)
                      : const Color(0xFF1D00FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  loc.applyFilters,
                  style: TextStyleHelper.instance.title14SemiBoldPoppins
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _onTapIdeaCard(BuildContext context, [IdeaCardModel? idea]) {
    if (idea == null) return;

    final ideaId = (idea.id ?? '').trim();
    if (ideaId.isEmpty) return;

    final target = resolveIdeaDetailTarget(idea);

    Navigator.pushNamed(
      context,
      AppRoutes.ideaDetailView,
      arguments: {
        'entityType': target.entityType,
        'id': target.id,
      },
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({
    required this.count,
    required this.activeIndex,
    required this.isDark,
  });

  final int count;
  final int activeIndex;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final safeIndex = activeIndex.clamp(0, count - 1);
    final activeColor =
        isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF);
    final inactiveColor =
        isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE0E0E0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final on = i == safeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: EdgeInsets.symmetric(horizontal: 4.h),
          height: 8.h,
          width: on ? 20.h : 8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.h),
            color: on ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}

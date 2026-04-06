import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomBottomNavigationBar - A customizable bottom navigation bar with floating action button
 * 
 * Features:
 * - 5 navigation items with customizable icons and active states
 * - Central floating action button
 * - Optional completion status overlay
 * - Rounded container with shadow effect
 * - Responsive design using SizeUtils
 * 
 * @param items List of navigation items with their properties
 * @param selectedIndex Currently selected navigation item index
 * @param onItemTapped Callback when navigation item is tapped
 * @param onCenterButtonTapped Callback when center floating button is tapped
 * @param showCompletionStatus Whether to show completion status overlay
 * @param completionText Text to display in completion status
 * @param centerButtonIcon Icon for the center floating button
 * @param backgroundColor Background color of the bottom bar
 * @param margin Margin around the bottom bar
 */
class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.items,
    required this.onItemTapped,
    this.selectedIndex = 0,
    this.onCenterButtonTapped,
    this.centerButtonIcon,
    this.backgroundColor,
    this.margin,
  }) : super(key: key);

  final List<CustomBottomNavigationItem> items;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback? onCenterButtonTapped;
  final String? centerButtonIcon;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      margin: margin ?? EdgeInsets.only(left: 20.h, right: 20.h, bottom: 20.h),
      child: _buildBottomBar(isRtl),
    );
  }

  Widget _buildBottomBar(bool isRtl) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x4C000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: _buildAllItems(),
      ),
    );
  }

  List<Widget> _buildAllItems() {
    // items list: [Home, Explore, Stats, Profile] (4 items, center AI is separate)
    // Layout: Home | Explore | [AI Center] | Stats | Profile
    return [
      _buildNavItem(0, items[0]),
      _buildNavItem(1, items[1]),
      _buildCenterButton(),
      _buildNavItem(2, items[2]),
      _buildNavItem(3, items[3]),
    ];
  }

  Widget _buildNavItem(int index, CustomBottomNavigationItem item) {
    final bool isSelected = selectedIndex == index;
    final Color activeColor = Color(0xFF1D00FF);
    final Color inactiveColor = Color(0xFF9E9E9E);

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: isSelected
                  ? (item.activeIcon ?? item.icon)
                  : item.icon,
              height: 24.h,
              width: 24.h,
              color: isSelected ? null : inactiveColor,
            ),
            SizedBox(height: 4.h),
            Text(
              item.label ?? '',
              style: TextStyleHelper.instance.label10RegularPoppins.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? activeColor : inactiveColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: onCenterButtonTapped,
      child: Container(
        height: 54.h,
        width: 54.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4E56E2), Color(0xFF1D00FF)],
          ),
          borderRadius: BorderRadius.circular(27.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x661D00FF),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: CustomImageView(
            imagePath: centerButtonIcon ?? ImageConstant.imgGroup1000006182,
            height: 28.h,
            width: 28.h,
          ),
        ),
      ),
    );
  }
}

/// Data model for bottom navigation items
class CustomBottomNavigationItem {
  const CustomBottomNavigationItem({
    required this.icon,
    this.activeIcon,
    this.routeName,
    this.iconSize = 24,
    this.label,
  });

  final String icon;
  final String? activeIcon;
  final String? routeName;
  final double? iconSize;
  final String? label;
}

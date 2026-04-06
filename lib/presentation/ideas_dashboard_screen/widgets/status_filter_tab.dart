import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class StatusFilterTab extends StatelessWidget {
  final String title;
  final String count;
  final bool isSelected;
  final VoidCallback? onTap;

  StatusFilterTab({
    Key? key,
    required this.title,
    required this.count,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark
        ? const Color(0xFF6A59F1)
        : const Color(0xFF1D00FF);
    final inactiveTextColor = isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF888888);
    final badgeBgInactive = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFEBEBFF);
    final badgeTextInactive = isDark
        ? const Color(0xFFCCCCDD)
        : const Color(0xFF25282C);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyleHelper.instance.title12MediumSFProText.copyWith(
                color: isSelected ? const Color(0xFFFFFFFF) : inactiveTextColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            SizedBox(width: 5.h),
            Container(
              width: 20.h,
              height: 20.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFBCA62) : badgeBgInactive,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                count,
                style: TextStyleHelper.instance.title12MediumSFProText.copyWith(
                  color: isSelected
                      ? const Color(0xFF433408)
                      : badgeTextInactive,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

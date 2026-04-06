import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_switch.dart';

/** 
 * CustomSettingsItem - A reusable settings menu item component with shadow effects and flexible right-side content.
 * Supports both navigation items with chevron icons and toggle items with switches.
 * Features consistent styling, responsive design, and customizable spacing.
 * 
 * @param title - The main text content for the settings item
 * @param onTap - Callback function for navigation items (ignored when hasSwitch is true)
 * @param hasSwitch - Whether to display a switch instead of chevron icon
 * @param switchValue - Current state of the switch (required when hasSwitch is true)
 * @param onSwitchChanged - Callback for switch state changes (required when hasSwitch is true)
 * @param margin - Custom margin for spacing between items
 */
class CustomSettingsItem extends StatelessWidget {
  CustomSettingsItem({
    Key? key,
    required this.title,
    this.onTap,
    this.hasSwitch,
    this.switchValue,
    this.onSwitchChanged,
    this.margin,
  }) : super(key: key);

  /// The main text content for the settings item
  final String title;

  /// Callback function for navigation items
  final VoidCallback? onTap;

  /// Whether to display a switch instead of chevron icon
  final bool? hasSwitch;

  /// Current state of the switch
  final bool? switchValue;

  /// Callback for switch state changes
  final ValueChanged<bool>? onSwitchChanged;

  /// Custom margin for spacing between items
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(0xFF1E1E2E)
        : const Color(0xFFFFFFFF);
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final shadowColor = isDark
        ? Colors.black.withAlpha(60)
        : const Color(0x3F000000);

    return Container(
      width: double.maxFinite,
      margin: margin ?? EdgeInsets.zero,
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: (hasSwitch ?? false) ? 10.h : 8.h,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 25.h, offset: Offset(0, 0)),
        ],
      ),
      child: InkWell(
        onTap: (hasSwitch ?? false) ? null : onTap,
        child: Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyleHelper.instance.headline18SemiBoldPoppins
                  .copyWith(color: textColor),
            ),
            _buildRightWidget(isRtl, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildRightWidget(bool isRtl, bool isDark) {
    if (hasSwitch ?? false) {
      return CustomSwitch(
        value: switchValue ?? false,
        onChanged: onSwitchChanged,
      );
    }

    return Transform.scale(
      scaleX: isRtl ? -1.0 : 1.0,
      child: CustomImageView(
        imagePath: ImageConstant.imgChevronRight,
        height: 16.h,
        width: 28.h,
        color: isDark ? Colors.white54 : null,
      ),
    );
  }
}

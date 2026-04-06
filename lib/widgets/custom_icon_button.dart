import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * A customizable icon button widget that supports various sizes, colors, and border styles.
 * 
 * This widget provides a flexible icon button implementation with support for:
 * - Custom SVG/PNG icons via CustomImageView
 * - Configurable sizes and colors
 * - Custom border radius including asymmetric borders
 * - Optional tap handling with visual feedback
 * - Responsive design using SizeUtils extensions
 * 
 * @param iconPath - Path to the icon image (SVG/PNG) - Required
 * @param onTap - Callback function when button is tapped - Optional
 * @param size - Size of the button (width and height) - Optional, defaults to 40
 * @param backgroundColor - Background color of the button - Optional, defaults to appTheme.whiteCustom
 * @param borderRadius - Border radius for the button - Optional, defaults to 8
 * @param padding - Internal padding for the icon - Optional, defaults to 8
 * @param margin - External margin around the button - Optional, defaults to EdgeInsets.zero
 */
class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    required this.iconPath,
    this.onTap,
    this.size,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.iconSize,
  }) : super(key: key);

  /// Path to the icon image (SVG, PNG, etc.)
  final String iconPath;

  /// Callback function when the button is tapped
  final VoidCallback? onTap;

  /// Size of the button container (width and height will be same)
  final double? size;

  /// Background color of the button
  final Color? backgroundColor;

  /// Border radius for the button corners
  final BorderRadius? borderRadius;

  /// Internal padding around the icon
  final EdgeInsets? padding;

  /// External margin around the button
  final EdgeInsets? margin;

  /// Specific size for the icon (if different from container size)
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 40.0;
    final defaultPadding = padding ?? EdgeInsets.all(8.h);
    final defaultMargin = margin ?? EdgeInsets.zero;
    final defaultBackgroundColor = backgroundColor ?? appTheme.whiteCustom;
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(8.h);
    final defaultIconSize =
        iconSize ?? (buttonSize - (defaultPadding.horizontal));

    return Container(
      margin: defaultMargin,
      child: Material(
        color: appTheme.transparentCustom,
        child: InkWell(
          onTap: onTap,
          borderRadius: defaultBorderRadius,
          child: Container(
            width: buttonSize.h,
            height: buttonSize.h,
            padding: defaultPadding,
            decoration: BoxDecoration(
              color: defaultBackgroundColor,
              borderRadius: defaultBorderRadius,
            ),
            child: CustomImageView(
              imagePath: iconPath,
              width: defaultIconSize.h,
              height: defaultIconSize.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

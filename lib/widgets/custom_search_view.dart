import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomSearchView - A reusable search input component with customizable icons and styling
 * 
 * Features:
 * - Left and right icon support with CustomImageView
 * - Customizable placeholder text
 * - Border styling with rounded corners
 * - Responsive design using SizeUtils
 * - Form validation support
 * - Flexible padding and margin configuration
 * 
 * @param controller - TextEditingController for managing input text
 * @param placeholder - Placeholder text displayed when field is empty
 * @param leftImagePath - Path to left icon image (search icon)
 * @param rightImagePath - Path to right icon image (filter icon)
 * @param onRightIconTap - Callback function when right icon is tapped
 * @param validator - Form validation function
 * @param onChanged - Callback function when text changes
 * @param margin - External margin spacing
 * @param padding - Internal content padding
 * @param borderColor - Border color for the input field
 * @param borderRadius - Border radius for rounded corners
 * @param backgroundColor - Background color of the input field
 * @param textStyle - Text styling for input text
 */
class CustomSearchView extends StatelessWidget {
  const CustomSearchView({
    Key? key,
    this.controller,
    this.placeholder,
    this.leftImagePath,
    this.rightImagePath,
    this.onRightIconTap,
    this.validator,
    this.onChanged,
    this.margin,
    this.padding,
    this.borderColor,
    this.borderRadius,
    this.backgroundColor,
    this.textStyle,
  }) : super(key: key);

  /// Controller for managing the text input
  final TextEditingController? controller;

  /// Placeholder text shown when field is empty
  final String? placeholder;

  /// Path to the left icon image
  final String? leftImagePath;

  /// Path to the right icon image
  final String? rightImagePath;

  /// Callback function when right icon is tapped
  final VoidCallback? onRightIconTap;

  /// Form validation function
  final String? Function(String?)? validator;

  /// Callback function when text input changes
  final Function(String)? onChanged;

  /// External margin spacing around the component
  final EdgeInsetsGeometry? margin;

  /// Internal padding within the input field
  final EdgeInsetsGeometry? padding;

  /// Border color of the input field
  final Color? borderColor;

  /// Border radius for rounded corners
  final double? borderRadius;

  /// Background color of the input field
  final Color? backgroundColor;

  /// Text styling for the input text
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBorderColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFE0E0E0);
    final defaultFocusBorderColor = isDark
        ? const Color(0xFF6A59F1)
        : const Color(0xFF1D00FF);
    final defaultTextColor = isDark ? Colors.white : const Color(0xFF000000);
    final defaultHintColor = isDark
        ? const Color(0xFF6B6B8A)
        : const Color(0xFF000000).withAlpha(128);
    final defaultFillColor = isDark
        ? const Color(0xFF1E1E2E)
        : Colors.transparent;
    final iconColor = isDark ? Colors.white54 : null;

    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 20.h),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        style:
            textStyle ??
            TextStyleHelper.instance.title15SemiBoldPoppins.copyWith(
              color: defaultTextColor,
            ),
        decoration: InputDecoration(
          hintText: placeholder ?? "Search",
          hintStyle: TextStyleHelper.instance.title15SemiBoldPoppins.copyWith(
            color: defaultHintColor,
          ),
          prefixIcon: leftImagePath != null
              ? Padding(
                  padding: EdgeInsets.all(12.h),
                  child: CustomImageView(
                    imagePath: leftImagePath!,
                    height: 24.h,
                    width: 24.h,
                    color: iconColor,
                  ),
                )
              : null,
          suffixIcon: rightImagePath != null
              ? InkWell(
                  onTap: onRightIconTap,
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: CustomImageView(
                      imagePath: rightImagePath!,
                      height: 24.h,
                      width: 24.h,
                      color: iconColor,
                    ),
                  ),
                )
              : null,
          contentPadding:
              padding ?? EdgeInsets.symmetric(horizontal: 40.h, vertical: 8.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.h),
            borderSide: BorderSide(
              color: borderColor ?? defaultBorderColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.h),
            borderSide: BorderSide(
              color: borderColor ?? defaultBorderColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.h),
            borderSide: BorderSide(
              color: borderColor ?? defaultFocusBorderColor,
              width: 1.5,
            ),
          ),
          fillColor: backgroundColor ?? defaultFillColor,
          filled: true,
        ),
      ),
    );
  }
}

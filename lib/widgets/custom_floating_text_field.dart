import 'package:flutter/material.dart';

import '../core/app_export.dart';

/// A customizable floating text field component that supports various input types,
/// right-side icons, and form validation. Designed to handle text, email, and phone inputs
/// with consistent styling and behavior across different use cases.
///
/// @param labelText - The label text displayed above the field when focused
/// @param hintText - The hint text shown when the field is empty
/// @param suffixIconPath - Path to the SVG icon displayed on the right side
/// @param keyboardType - The type of keyboard to show for input
/// @param initialValue - Pre-filled text value for the field
/// @param validator - Validation function for form validation
/// @param onChanged - Callback function when the text value changes
/// @param controller - Text editing controller for the field
/// @param enabled - Whether the field is enabled for interaction
class CustomFloatingTextField extends StatelessWidget {
  const CustomFloatingTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.suffixIconPath,
    this.keyboardType,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.controller,
    this.enabled = true,
  }) : super(key: key);

  /// The label text displayed above the field when focused
  final String? labelText;

  /// The hint text shown when the field is empty
  final String? hintText;

  /// Path to the SVG icon displayed on the right side
  final String? suffixIconPath;

  /// The type of keyboard to show for input
  final TextInputType? keyboardType;

  /// Pre-filled text value for the field
  final String? initialValue;

  /// Validation function for form validation
  final String? Function(String?)? validator;

  /// Callback function when the text value changes
  final void Function(String)? onChanged;

  /// Text editing controller for the field
  final TextEditingController? controller;

  /// Whether the field is enabled for interaction
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType ?? TextInputType.text,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      style: TextStyleHelper.instance.title15MediumPoppins.copyWith(
        height: 22.h / 15.fSize,
        color: Color(0xFF7B7878),
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText ?? labelText,
        hintStyle: TextStyleHelper.instance.title15MediumPoppins.copyWith(
          color: Color(0xFF7B7878),
        ),
        labelStyle: TextStyleHelper.instance.title15MediumPoppins.copyWith(
          color: Color(0xFF7B7878),
        ),
        suffixIcon: suffixIconPath != null
            ? Padding(
                padding: EdgeInsets.all(12.h),
                child: CustomImageView(
                  imagePath: suffixIconPath!,
                  height: 24.h,
                  width: 24.h,
                ),
              )
            : null,
        filled: true,
        fillColor: Color(0xFFFFFFFF),
        contentPadding: EdgeInsets.only(
          top: 12.h,
          bottom: 12.h,
          left: 16.h,
          right: suffixIconPath != null ? 48.h : 16.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
          borderSide: BorderSide(color: Color(0x3F000000), width: 1.h),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
          borderSide: BorderSide(color: Color(0x3F000000), width: 1.h),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
          borderSide: BorderSide(color: Color(0x3F000000), width: 1.h),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
          borderSide: BorderSide(color: appTheme.redCustom, width: 1.h),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
          borderSide: BorderSide(color: appTheme.redCustom, width: 1.h),
        ),
      ),
    );
  }
}

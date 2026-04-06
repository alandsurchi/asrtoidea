import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomEditText - A highly customizable text input field component
 * 
 * Features:
 * - Support for various input types (text, email, password)
 * - Left and right icon support
 * - Gradient background with background image
 * - Password visibility toggle
 * - Form validation support
 * - Responsive design with SizeUtils
 * - Customizable styling and colors
 * 
 * @param controller - TextEditingController for managing input
 * @param hintText - Placeholder text shown when field is empty
 * @param leftIcon - Icon displayed on the left side of the input
 * @param rightIcon - Icon displayed on the right side of the input
 * @param isPassword - Whether this is a password field with obscured text
 * @param keyboardType - Type of keyboard to display
 * @param validator - Validation function for form validation
 * @param onChanged - Callback when text changes
 * @param textStyle - Custom text style for input text
 * @param hintStyle - Custom text style for hint text
 * @param fillColor - Background fill color
 * @param backgroundImage - Background image path
 * @param borderRadius - Border radius for the input field
 * @param contentPadding - Internal padding of the input field
 * @param enabled - Whether the field is enabled for input
 */
class CustomEditText extends StatefulWidget {
  const CustomEditText({
    Key? key,
    this.controller,
    this.hintText,
    this.leftIcon,
    this.rightIcon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.backgroundImage,
    this.borderRadius,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final String? leftIcon;
  final String? rightIcon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final String? backgroundImage;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildContainerDecoration(),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && !_isPasswordVisible,
        keyboardType: widget.keyboardType ?? _getDefaultKeyboardType(),
        validator: widget.validator,
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        onTap: widget.onTap,
        style: widget.textStyle ?? _getDefaultTextStyle(),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ?? _getDefaultHintStyle(),
          prefixIcon: widget.leftIcon != null ? _buildPrefixIcon() : null,
          suffixIcon: _buildSuffixIcon(),
          contentPadding: widget.contentPadding ?? _getDefaultContentPadding(),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.h),
      color: widget.fillColor ?? Color(0x33FFFFFF),
      image: widget.backgroundImage != null
          ? DecorationImage(
              image: AssetImage(widget.backgroundImage!),
              fit: BoxFit.cover,
            )
          : null,
      gradient: widget.fillColor == null
          ? LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: [Color(0x33FFFFFF), Color(0x33FFFFFF), Color(0x33FFFFFF)],
            )
          : null,
    );
  }

  Widget _buildPrefixIcon() {
    return Container(
      padding: EdgeInsets.all(12.h),
      child: CustomImageView(
        imagePath: widget.leftIcon!,
        height: 16.h,
        width: 16.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: CustomImageView(
          imagePath: _isPasswordVisible
              ? ImageConstant.imgEyeOpen
              : widget.rightIcon ?? ImageConstant.imgVectorWhiteA70016x16,
          height: 16.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      );
    } else if (widget.rightIcon != null) {
      return Container(
        padding: EdgeInsets.all(12.h),
        child: CustomImageView(
          imagePath: widget.rightIcon!,
          height: 16.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
      );
    }
    return null;
  }

  TextInputType _getDefaultKeyboardType() {
    if (widget.hintText?.toLowerCase().contains('email') == true) {
      return TextInputType.emailAddress;
    }
    if (widget.isPassword) {
      return TextInputType.visiblePassword;
    }
    return TextInputType.text;
  }

  TextStyle _getDefaultTextStyle() {
    return TextStyleHelper.instance.body14MediumPoppins.copyWith(
      color: Color(0xFFFFFFFF),
      height: 1.57,
    );
  }

  TextStyle _getDefaultHintStyle() {
    if (widget.hintText == 'Strong') {
      return TextStyleHelper.instance.label10MediumPoppins.copyWith(
        color: Color(0xFF9EDAA1),
        height: 1.6,
      );
    }
    return TextStyleHelper.instance.body14MediumPoppins.copyWith(
      color: Color(0xFFFFFFFF),
      height: 1.57,
    );
  }

  EdgeInsetsGeometry _getDefaultContentPadding() {
    if (widget.leftIcon != null && widget.rightIcon != null) {
      return EdgeInsets.fromLTRB(38.h, 16.h, 36.h, 16.h);
    } else if (widget.leftIcon != null) {
      return EdgeInsets.fromLTRB(36.h, 16.h, 14.h, 16.h);
    }
    return EdgeInsets.all(16.h);
  }
}

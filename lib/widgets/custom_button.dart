import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * A customizable button component with shadow effects and rounded borders.
 * Supports configurable text, colors, dimensions, and styling properties.
 * 
 * @param width - Required width for the button
 * @param onPressed - Callback function triggered when button is pressed
 * @param text - Text to display on the button (defaults to "Next")
 * @param backgroundColor - Background color of the button (defaults to white)
 * @param textColor - Color of the button text (defaults to black)
 * @param borderRadius - Corner radius of the button (defaults to 12)
 * @param padding - Internal padding of the button
 * @param margin - External margin around the button
 * @param boxShadow - Shadow effect for the button
 */
class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    required this.width,
    required this.onPressed,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.boxShadow,
  }) : super(key: key);

  /// Required width for the button
  final double width;

  /// Callback function triggered when button is pressed
  final VoidCallback? onPressed;

  /// Text to display on the button
  final String? text;

  /// Background color of the button
  final Color? backgroundColor;

  /// Color of the button text
  final Color? textColor;

  /// Corner radius of the button
  final double? borderRadius;

  /// Internal padding of the button
  final EdgeInsetsGeometry? padding;

  /// External margin around the button
  final EdgeInsetsGeometry? margin;

  /// Shadow effect for the button
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin ?? EdgeInsets.only(top: 46.h, right: 26.h, bottom: 12.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(borderRadius?.h ?? 12.h),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: appTheme.color3F0000,
                blurRadius: 25.h,
                offset: Offset(0, 0),
              ),
            ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.transparentCustom,
          shadowColor: appTheme.transparentCustom,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 8.h, horizontal: 30.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius?.h ?? 12.h),
          ),
        ),
        child: Text(
          text ?? "Next",
          style: TextStyleHelper.instance.headline24MediumPoppins.copyWith(
            color: textColor ?? Color(0xFF000000),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

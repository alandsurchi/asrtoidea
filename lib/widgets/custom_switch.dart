import 'package:flutter/material.dart';

/**
 * CustomSwitch - A reusable switch component that wraps Flutter's Switch widget
 * 
 * Features:
 * - Customizable active and inactive colors
 * - Responsive sizing using SizeUtils
 * - Callback function for value changes
 * - Follows Material Design guidelines
 * 
 * @param value - Current state of the switch (true/false)
 * @param onChanged - Callback function triggered when switch state changes
 * @param activeColor - Color when switch is turned on
 * @param inactiveTrackColor - Color of track when switch is turned off
 * @param inactiveThumbColor - Color of thumb when switch is turned off
 */
class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveTrackColor,
    this.inactiveThumbColor,
  }) : super(key: key);

  /// Current state of the switch
  final bool value;

  /// Callback function when switch value changes
  final ValueChanged<bool>? onChanged;

  /// Color when switch is active/on
  final Color? activeColor;

  /// Color of the track when switch is inactive/off
  final Color? inactiveTrackColor;

  /// Color of the thumb when switch is inactive/off
  final Color? inactiveThumbColor;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.0,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: activeColor ?? Color(0xFF52D1C6),
        inactiveTrackColor: inactiveTrackColor ?? Color(0xFFE0E0E0),
        inactiveThumbColor: inactiveThumbColor ?? Color(0xFFFFFFFF),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

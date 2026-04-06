import 'package:flutter/material.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
ThemeData get darkTheme => ThemeHelper().darkThemeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = "lightCode";

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current light theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      brightness: Brightness.light,
      fontFamilyFallback: const ['Sarchia'],
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      cardColor: const Color(0xFFFFFFFF),
      dividerColor: const Color(0xFFE0E0E0),
      appBarTheme: const AppBarThemeData(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF000000),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1D00FF), width: 1.5),
        ),
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF000000)),
        bodyMedium: TextStyle(color: Color(0xFF000000)),
        titleLarge: TextStyle(color: Color(0xFF000000)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF000000)),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1D00FF);
          }
          return const Color(0xFFBBBBBB);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1D00FF).withAlpha(80);
          }
          return const Color(0xFFE0E0E0);
        }),
      ),
    );
  }

  /// Returns the dark theme data.
  ThemeData _getDarkThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamilyFallback: const ['Sarchia'],
      visualDensity: VisualDensity.standard,
      colorScheme: ColorSchemes.darkCodeColorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      cardColor: const Color(0xFF1E1E2E),
      dividerColor: const Color(0xFF2A2A3E),
      appBarTheme: const AppBarThemeData(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: const Color(0xFF1E1E2E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6A59F1), width: 1.5),
        ),
        hintStyle: const TextStyle(color: Color(0xFF6B6B8A)),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
        bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
        titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF6A59F1);
          }
          return const Color(0xFF555570);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF6A59F1).withAlpha(80);
          }
          return const Color(0xFF2A2A3E);
        }),
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current light theme data.
  ThemeData themeData() => _getThemeData();

  /// Returns the dark theme data.
  ThemeData darkThemeData() => _getDarkThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: const Color(0xFF1D00FF),
    secondary: const Color(0xFF6A59F1),
    surface: const Color(0xFFFFFFFF),
    onPrimary: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF000000),
  );

  static final darkCodeColorScheme = ColorScheme.dark(
    primary: const Color(0xFF6A59F1),
    secondary: const Color(0xFF4E56E2),
    surface: const Color(0xFF1E1E2E),
    onPrimary: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFFFFFFFF),
  );
}

class LightCodeColors {
  // App Colors
  Color get black_900 => Color(0xFF000000);
  Color get blue_400 => Color(0xFF4B9DFE);
  Color get blue_gray_100 => Color(0xFFD9D9D9);
  Color get white_A700 => Color(0xFFFFFFFF);

  // Additional Colors
  Color get transparentCustom => Colors.transparent;
  Color get greyCustom => Colors.grey;
  Color get color990000 => Color(0x99000000);
  Color get colorFF007A => Color(0xFF007AFF);
  Color get colorFFE0E0 => Color(0xFFE0E0E0);
  Color get color3F0000 => Color(0x3F000000);

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;

  // New Colors
  Color get color1D00FF => Color(0xFF1D00FF);
  Color get colorEFEFEF => Color(0xFFEFEFEF);
  Color get colorDEDEDE => Color(0xFFDEDEDE);
  Color get colorBBBBBB => Color(0xFFBBBBBB);
  Color get color818181 => Color(0xFF818181);
  Color get colorBFD9D9D9 => Color(0xBFD9D9D9);
  Color get color7F7F7F => Color(0xFF7F7F7F);
  Color get colorD1CBCB => Color(0xFFD1CBCB);
  Color get color33FFFFFF => Color(0x33FFFFFF);
  Color get color9EDAA1 => Color(0xFF9EDAA1);
  Color get color808080 => Color(0xFF808080);
  Color get color191919 => Color(0xFF191919);
  Color get color686868 => Color(0xFF686868);

  // Additional predefined colors
  Color get greenCustom => Colors.green;
  Color get redCustom => Colors.red;
  Color get blueCustom => Colors.blue;
  Color get whiteCustom => Colors.white;
  Color get blackCustom => Colors.black;
  Color get orangeCustom => Colors.orange;

  // New hex colors from extracted data
  Color get colorFBD060 => Color(0xFFFBD060);
  Color get color99FFFFFF => Color(0x99FFFFFF);
  Color get color4E56E2 => Color(0xFF4E56E2);
  Color get color282828 => Color(0xFF282828);
  Color get colorFBCA62 => Color(0xFFFBCA62);
  Color get colorEBEBFF => Color(0xFFEBEBFF);
  Color get color25282C => Color(0xFF25282C);
  Color get colorFFFBFB => Color(0xFFFFFBFB);
  Color get color5E000000 => Color(0x5E000000);
  Color get color6A59F1 => Color(0xFF6A59F1);
  Color get colorB5FFFFFF => Color(0xB5FFFFFF);
  Color get color1DE4A2 => Color(0xFF1DE4A2);
  Color get colorCCFFFFFF => Color(0xCCFFFFFF);
  Color get color5EFFFEFE => Color(0x5EFFFEFE);
  Color get colorC4C4C4 => Color(0xFFC4C4C4);
  Color get colorCC9300 => Color(0xFFCC9300);
  Color get color433408 => Color(0xFF433408);
  Color get color292626 => Color(0xFF292626);
  Color get color4C000000 => Color(0x4C000000);
  Color get color52D1C6 => Color(0xFF52D1C6);

  // Additional new colors from extraction
  Color get color1869FF => Color(0xFF1869FF);
  Color get color1A56DB => Color(0xFF1A56DB);
  Color get color1A1A2E => Color(0xFF1A1A2E);
  Color get color3B1FCC => Color(0xFF3B1FCC);
  Color get color33000000 => Color(0x33000000);
  Color get color14000000 => Color(0x14000000);
  Color get colorFFF0F0 => Color(0xFFFFF0F0);
  Color get colorFFCCCC => Color(0xFFFFCCCC);
  Color get colorFF3B30 => Color(0xFFFF3B30);
  Color get color9E9E9E => Color(0xFF9E9E9E);
  Color get color661D00FF => Color(0x661D00FF);
  Color get color7B7878 => Color(0xFF7B7878);

  // New colors from current extraction
  Color get colorF5F5F5 => Color(0xFFF5F5F5);
  Color get colorF8F8FF => Color(0xFFF8F8FF);
  Color get colorFFEEEE => Color(0xFFFFEEEE);
  Color get colorFFF8E1 => Color(0xFFFFF8E1);
  Color get color888888 => Color(0xFF888888);
  Color get color848080 => Color(0xFF848080);
  Color get color2B3D3DDB => Color(0x2B3D3DDB);
  Color get colorB2000000 => Color(0xB2000000);
  Color get color2918A6 => Color(0xFF2918A6);
  Color get color2919A6 => Color(0xFF2919A6);
}

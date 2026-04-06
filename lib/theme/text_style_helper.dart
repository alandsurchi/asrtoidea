import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  /// Renders Kurdish script when primary Latin fonts lack glyphs.
  static const List<String> _kurdishGlyphFallback = ['Sarchia'];

  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Display Styles
  // Large text styles for main headings

  TextStyle get display40SemiBoldPoppins => TextStyle(
    fontSize: 40.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get display40RegularLemon => TextStyle(
    fontSize: 40.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Lemon',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get display38RegularLemon => TextStyle(
    fontSize: 38.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Lemon',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get display36RegularJua => TextStyle(
    fontSize: 36.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Jua',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get display32MediumSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 32.fSize, fontWeight: FontWeight.w500);

  // Headline Styles
  // Medium-large text styles for section headers

  TextStyle get headline32MediumKarla => TextStyle(
    fontSize: 32.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Karla',
    fontFamilyFallback: _kurdishGlyphFallback,
    color: appTheme.black_900,
  );

  TextStyle get headline24SemiBoldPoppins => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get headline24MediumPoppins => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get headline24SemiBoldSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 24.fSize, fontWeight: FontWeight.w600);

  TextStyle get headline20BoldSFProText => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get headline20SemiBoldPoppins => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get headline20BoldSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 20.fSize, fontWeight: FontWeight.bold);

  TextStyle get headline20SemiBoldSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 20.fSize, fontWeight: FontWeight.w600);

  TextStyle get headline19RegularPoppins => TextStyle(
    fontSize: 19.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get headline18SemiBoldPoppins => TextStyle(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get headline18RegularPoppins => TextStyle(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get headline18SemiBoldSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 18.fSize, fontWeight: FontWeight.w600);

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title16SemiBoldPoppins => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title16RegularKarla => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Karla',
    fontFamilyFallback: _kurdishGlyphFallback,
    color: appTheme.color990000,
  );

  TextStyle get title16RegularJua => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Jua',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title16SemiBoldSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 16.fSize, fontWeight: FontWeight.w600);

  TextStyle get title16RegularSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 16.fSize, fontWeight: FontWeight.w400);

  TextStyle get title15SemiBoldPoppins => TextStyle(
    fontSize: 15.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title15MediumPoppins => TextStyle(
    fontSize: 15.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title15LightPoppins => TextStyle(
    fontSize: 15.fSize,
    fontWeight: FontWeight.w300,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title15SemiBoldSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 15.fSize, fontWeight: FontWeight.w600);

  TextStyle get title14SemiBoldPoppins => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title14LightPoppins => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w300,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title14MediumSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 14.fSize, fontWeight: FontWeight.w500);

  TextStyle get title13BoldInter => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Inter',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title13RegularLemon => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Lemon',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title13MediumPoppins => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title13LightPoppins => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w300,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title13SemiBoldPoppins => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title13SemiBoldSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 13.fSize, fontWeight: FontWeight.w600);

  TextStyle get title12MediumSFProText => TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title12MediumPoppins => TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get title12SemiBoldSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 12.fSize, fontWeight: FontWeight.w600);

  TextStyle get title12RegularSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 12.fSize, fontWeight: FontWeight.w400);

  // Body Styles
  // Regular text styles for body content

  TextStyle get body14MediumPoppins => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get body14RegularPoppins => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  // Label Styles
  // Small text styles for labels and captions

  TextStyle get label11SemiBoldPoppins => TextStyle(
    fontSize: 11.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get label11MediumPoppins => TextStyle(
    fontSize: 11.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get label11RegularPoppins => TextStyle(
    fontSize: 11.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get label11RegularSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 11.fSize, fontWeight: FontWeight.w400);

  TextStyle get label10MediumPoppins => TextStyle(
    fontSize: 10.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get label10RegularPoppins => TextStyle(
    fontSize: 10.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );

  TextStyle get label9RegularSans =>
      TextStyle(fontFamilyFallback: _kurdishGlyphFallback, fontSize: 9.fSize, fontWeight: FontWeight.w400);

  TextStyle get label7RegularPoppins => TextStyle(
    fontSize: 7.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    fontFamilyFallback: _kurdishGlyphFallback,
  );
}

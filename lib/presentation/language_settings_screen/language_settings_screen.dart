import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../providers/locale_provider.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final localeProvider = ref.watch(localeProviderInstance);
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final subTextColor = isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF818181);
    final backBtnBg = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFEBEBFF);
    final backBtnIcon = isDark
        ? const Color(0xFF6A59F1)
        : const Color(0xFF1D00FF);

    final languages = [
      {
        'code': 'en',
        'name': localizations.languageNameEn,
        'flag': '🇬🇧',
        'nativeName': 'English',
      },
      {
        'code': 'ar',
        'name': localizations.languageNameAr,
        'flag': '🇸🇦',
        'nativeName': 'عربي',
      },
      {
        'code': 'ku',
        'name': localizations.languageNameKu,
        'flag': '🏳️',
        'nativeName': 'کوردی',
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          crossAxisAlignment: isRtl
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Row(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40.h,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: backBtnBg,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Icon(
                        isRtl
                            ? Icons.help_outline
                            : Icons.arrow_back_ios_new_rounded,
                        color: backBtnIcon,
                        size: 18.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Text(
                    localizations.languageSectionTitle,
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: TextStyleHelper.instance.headline20SemiBoldSans
                        .copyWith(color: textColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Text(
                localizations.languageSectionSubtitle,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyleHelper.instance.title13SemiBoldSans.copyWith(
                  color: subTextColor,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Text(
                localizations.languageSelectLabel,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyleHelper.instance.headline18SemiBoldSans.copyWith(
                  color: textColor,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                itemCount: languages.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final isSelected =
                      localeProvider.locale.languageCode == lang['code'];
                  final selectedBg = isDark
                      ? const Color(0xFF2A2A3E)
                      : const Color(0xFFEBEBFF);
                  final unselectedBg = isDark
                      ? const Color(0xFF1E1E2E)
                      : const Color(0xFFFFFFFF);
                  final selectedBorder = isDark
                      ? const Color(0xFF6A59F1)
                      : const Color(0xFF1D00FF);
                  final unselectedBorder = isDark
                      ? const Color(0xFF2A2A3E)
                      : const Color(0xFFE8E8E8);
                  final flagBg = isDark
                      ? const Color(0xFF2A2A3E)
                      : (isSelected ? Colors.white : const Color(0xFFF5F5F5));
                  final nameColor = isSelected
                      ? (isDark
                            ? const Color(0xFF6A59F1)
                            : const Color(0xFF1D00FF))
                      : textColor;
                  final checkBg = isDark
                      ? const Color(0xFF6A59F1)
                      : const Color(0xFF1D00FF);
                  final uncheckBg = isDark
                      ? const Color(0xFF2A2A3E)
                      : const Color(0xFFE8E8E8);

                  return GestureDetector(
                    onTap: () {
                      ref.read(localeProviderInstance.notifier).setLocale(
                        Locale(lang['code']!),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.h,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedBg : unselectedBg,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: isSelected ? selectedBorder : unselectedBorder,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withAlpha(40)
                                : const Color(0x14000000),
                            blurRadius: 12.h,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        textDirection: isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        children: [
                          Container(
                            width: 44.h,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: flagBg,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                lang['flag']!,
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.h),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: isRtl
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang['nativeName']!,
                                  textDirection: isRtl
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  style: TextStyleHelper
                                      .instance
                                      .title14MediumSans
                                      .copyWith(
                                        color: nameColor,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  lang['name']!,
                                  textDirection: isRtl
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  style: TextStyleHelper
                                      .instance
                                      .label11RegularSans
                                      .copyWith(color: subTextColor),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 28.h,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: checkBg,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 16.h,
                              ),
                            )
                          else
                            Container(
                              width: 28.h,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: uncheckBg,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

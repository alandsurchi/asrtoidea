import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/custom_switch.dart';
import '../../services/local_storage_service.dart';
import '../ideas_dashboard_screen/notifier/ideas_dashboard_notifier.dart';
import '../magic_idea_chat_screen/notifier/magic_idea_chat_notifier.dart';
import '../project_explore_dashboard_screen/notifier/project_explore_dashboard_notifier.dart';
import './notifier/settings_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final subTextColor = isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF818181);
    final iconBgColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFEBEBFF);
    final iconColor = isDark
        ? const Color(0xFF6A59F1)
        : const Color(0xFF1D00FF);
    final shadowColor = isDark
        ? Colors.black.withAlpha(60)
        : const Color(0x14000000);

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              _buildPageTitle(context, localizations, textColor),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Consumer(builder: (context, ref, _) {
                      return _buildProfileCard(context, localizations, isRtl, ref);
                    }),
                    SizedBox(height: 16.h),
                    _buildUpgradePlanCard(context, localizations, isRtl),
                    SizedBox(height: 28.h),
                    _buildGeneralSection(
                      context,
                      localizations,
                      isRtl,
                      textColor,
                      cardColor,
                      iconBgColor,
                      iconColor,
                      subTextColor,
                      shadowColor,
                    ),
                    SizedBox(height: 24.h),
                    _buildAlertsSection(
                      context,
                      localizations,
                      isRtl,
                      textColor,
                      cardColor,
                      iconBgColor,
                      iconColor,
                      subTextColor,
                      shadowColor,
                    ),
                    SizedBox(height: 24.h),
                    _buildSupportSection(
                      context,
                      localizations,
                      isRtl,
                      textColor,
                      cardColor,
                      iconBgColor,
                      iconColor,
                      subTextColor,
                      shadowColor,
                    ),
                    SizedBox(height: 24.h),
                    _buildLogoutButton(context, localizations, isDark),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageTitle(
    BuildContext context,
    AppLocalizations localizations,
    Color textColor,
  ) {
    return Center(
      child: Text(
        localizations.settingsTitle,
        style: TextStyleHelper.instance.headline20SemiBoldSans.copyWith(
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    AppLocalizations localizations,
    bool isRtl,
    WidgetRef ref,
  ) {
    final settingsState = ref.watch(settingsNotifier);
    final model = settingsState.settingsModel;
    final userName = _resolveDisplayName(model?.userName, model?.userEmail);
    final userEmail = model?.userEmail?.trim() ?? '';
    final imagePath = _sanitizeProfileImagePath(model?.profileImagePath);

    return GestureDetector(
      onTap: () => onTapEditProfile(context),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.h),
          gradient: LinearGradient(
            colors: isRtl
                ? [Color(0xFF6A59F1), Color(0xFF1D00FF)]
                : [Color(0xFF1D00FF), Color(0xFF6A59F1)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Container(
              width: 64.h,
              height: 64.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: appTheme.whiteCustom, width: 2.h),
              ),
              child: ClipOval(
                child: _buildProfileAvatar(userName: userName, imagePath: imagePath),
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
                    userName,
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: TextStyleHelper.instance.title16SemiBoldSans
                        .copyWith(color: Color(0xFFFFFFFF)),
                  ),
                  if (userEmail.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      userEmail,
                      textDirection: isRtl
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: TextStyleHelper.instance.label11RegularSans.copyWith(
                        color: Color(0xCCFFFFFF),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.h),
            Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                color: Color(0x33FFFFFF),
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: Icon(
                Icons.edit_outlined,
                color: appTheme.whiteCustom,
                size: 18.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar({required String userName, String? imagePath}) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return CustomImageView(
        imagePath: imagePath,
        height: 64.h,
        width: 64.h,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 64.h,
      height: 64.h,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDEE4FF), Color(0xFFC8D2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        _extractInitials(userName),
        style: TextStyleHelper.instance.title16SemiBoldSans.copyWith(
          color: const Color(0xFF1D2B53),
        ),
      ),
    );
  }

  String _resolveDisplayName(String? userName, String? userEmail) {
    final name = userName?.trim() ?? '';
    if (name.isNotEmpty) {
      return name;
    }

    final email = userEmail?.trim() ?? '';
    if (email.contains('@')) {
      final localPart = email.split('@').first.trim();
      if (localPart.isNotEmpty) {
        return localPart;
      }
    }

    return 'User';
  }

  String _extractInitials(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '?';
    }

    final parts = trimmed
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }

    return parts.first[0].toUpperCase();
  }

  String? _sanitizeProfileImagePath(String? imagePath) {
    final value = imagePath?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }

    final legacyPlaceholders = <String>{
      ImageConstant.imgUserProfilePhoto,
      ImageConstant.imgImage,
      ImageConstant.imgImage176x160,
    };

    if (legacyPlaceholders.contains(value)) {
      return null;
    }

    return value;
  }

  Widget _buildUpgradePlanCard(
    BuildContext context,
    AppLocalizations localizations,
    bool isRtl,
  ) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.h),
        gradient: LinearGradient(
          colors: isRtl
              ? [Color(0xFFCC9300), Color(0xFFC4C4C4)]
              : [Color(0xFFC4C4C4), Color(0xFFCC9300)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            height: 44.h,
            width: 44.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgGroup1000006231,
                  height: 44.h,
                  width: 44.h,
                  fit: BoxFit.contain,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgCrownRolex,
                  height: 26.h,
                  width: 24.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: isRtl
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.settingsUpgradePlan,
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyleHelper.instance.title13SemiBoldSans.copyWith(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  localizations.settingsUpgradePlanDesc,
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyleHelper.instance.label9RegularSans.copyWith(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.h),
          GestureDetector(
            onTap: () => onTapBuyNow(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
              decoration: BoxDecoration(
                color: Color(0xFF433408),
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: Text(
                localizations.settingsBuyNow,
                style: TextStyleHelper.instance.title12SemiBoldSans.copyWith(
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isRtl,
    Color textColor,
    Color cardColor,
    Color iconBgColor,
    Color iconColor,
    Color subTextColor,
    Color shadowColor,
  ) {
    final themeProvider = ref.watch(themeProviderInstance);
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          localizations.settingsGeneral,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyleHelper.instance.headline18SemiBoldSans.copyWith(
            color: textColor,
          ),
        ),
        SizedBox(height: 12.h),
        _buildSettingsItem(
          icon: Icons.person_outline,
          title: localizations.settingsAccount,
          onTap: () => onTapAccount(context),
          isRtl: isRtl,
          textColor: textColor,
          cardColor: cardColor,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          subTextColor: subTextColor,
          shadowColor: shadowColor,
        ),
        SizedBox(height: 12.h),
        _buildSettingsItem(
          icon: Icons.language_outlined,
          title: localizations.settingsLanguage,
          onTap: () => onTapLanguage(context),
          isRtl: isRtl,
          textColor: textColor,
          cardColor: cardColor,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          subTextColor: subTextColor,
          shadowColor: shadowColor,
        ),
        SizedBox(height: 12.h),
        _buildSettingsItem(
          icon: Icons.credit_card_outlined,
          title: localizations.settingsBilling,
          onTap: () => onTapBilling(context),
          isRtl: isRtl,
          textColor: textColor,
          cardColor: cardColor,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          subTextColor: subTextColor,
          shadowColor: shadowColor,
        ),
        SizedBox(height: 12.h),
        _buildSwitchItem(
          icon: Icons.dark_mode_outlined,
          title: localizations.settingsDarkMode,
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.setDarkMode(value);
          },
          isRtl: isRtl,
          textColor: textColor,
          cardColor: cardColor,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          shadowColor: shadowColor,
        ),
      ],
    );
  }

  Widget _buildAlertsSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isRtl,
    Color textColor,
    Color cardColor,
    Color iconBgColor,
    Color iconColor,
    Color subTextColor,
    Color shadowColor,
  ) {
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          localizations.settingsAlerts,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyleHelper.instance.headline18SemiBoldSans.copyWith(
            color: textColor,
          ),
        ),
        SizedBox(height: 12.h),
        _buildSettingsItem(
          icon: Icons.security_outlined,
          title: localizations.settingsSecurity,
          onTap: () => onTapSecurity(context),
          isRtl: isRtl,
          textColor: textColor,
          cardColor: cardColor,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          subTextColor: subTextColor,
          shadowColor: shadowColor,
        ),
        SizedBox(height: 12.h),
        _buildSettingsItem(
          icon: Icons.notifications_outlined,
          title: localizations.settingsReminders,
          onTap: () => onTapReminders(context),
          isRtl: isRtl,
          textColor: textColor,
          cardColor: cardColor,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          subTextColor: subTextColor,
          shadowColor: shadowColor,
        ),
      ],
    );
  }

  Widget _buildSupportSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isRtl,
    Color textColor,
    Color cardColor,
    Color iconBgColor,
    Color iconColor,
    Color subTextColor,
    Color shadowColor,
  ) {
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          localizations.settingsSupport,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyleHelper.instance.headline18SemiBoldSans.copyWith(
            color: textColor,
          ),
        ),
        SizedBox(height: 12.h),
        _buildSettingsItem(
          icon: Icons.help_outline,
          title: localizations.settingsHelpSupport,
          onTap: () {},
          isRtl: isRtl,
          textColor: textColor,
          cardColor: cardColor,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          subTextColor: subTextColor,
          shadowColor: shadowColor,
        ),
        SizedBox(height: 12.h),
        _buildSettingsItem(
          icon: Icons.star_outline,
          title: localizations.settingsRateApp,
          onTap: () {},
          isRtl: isRtl,
          textColor: textColor,
          cardColor: cardColor,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          subTextColor: subTextColor,
          shadowColor: shadowColor,
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isRtl,
    required Color textColor,
    required Color cardColor,
    required Color iconBgColor,
    required Color iconColor,
    required Color subTextColor,
    required Color shadowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 14.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12.h,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: Icon(icon, color: iconColor, size: 18.h),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                title,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyleHelper.instance.title14MediumSans.copyWith(
                  color: textColor,
                ),
              ),
            ),
            Transform.scale(
              scaleX: isRtl ? -1.0 : 1.0,
              child: Icon(Icons.chevron_right, color: subTextColor, size: 20.h),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isRtl,
    required Color textColor,
    required Color cardColor,
    required Color iconBgColor,
    required Color iconColor,
    required Color shadowColor,
  }) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 12.h, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            width: 36.h,
            height: 36.h,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Icon(icon, color: iconColor, size: 18.h),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              title,
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyleHelper.instance.title14MediumSans.copyWith(
                color: textColor,
              ),
            ),
          ),
          CustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => onTapLogout(context),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A1515) : const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: isDark ? const Color(0xFF5A2020) : const Color(0xFFFFCCCC),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_outlined, color: Color(0xFFFF3B30), size: 20.h),
            SizedBox(width: 8.h),
            Text(
              localizations.settingsLogOut,
              style: TextStyleHelper.instance.title15SemiBoldSans.copyWith(
                color: Color(0xFFFF3B30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapEditProfile(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.editProfileScreen);
  }

  void onTapBuyNow(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.workspace_premium, color: Color(0xFFCC9300), size: 24),
            SizedBox(width: 8),
            Text(
              loc.upgradePlanTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF000000),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.upgradePlanDesc2,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF9E9E9E)
                    : const Color(0xFF555555),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            _buildProFeatureRow(
              Icons.all_inclusive,
              loc.upgradePlanFeature1,
              isDark,
            ),
            _buildProFeatureRow(Icons.group, loc.upgradePlanFeature2, isDark),
            _buildProFeatureRow(
              Icons.analytics,
              loc.upgradePlanFeature3,
              isDark,
            ),
            _buildProFeatureRow(
              Icons.cloud_upload,
              loc.upgradePlanFeature2,
              isDark,
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFCC9300), Color(0xFFFFD700)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    loc.upgradePlanMonthly,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              loc.cancel,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF9E9E9E)
                    : const Color(0xFF888888),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.comingSoon),
                  backgroundColor: Color(0xFF1D00FF),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1D00FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              loc.settingsBuyNow,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProFeatureRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? const Color(0xFFCCCCCC)
                    : const Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTapAccount(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.editProfileScreen);
  }

  void onTapLanguage(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.languageSettingsScreen);
  }

  void onTapBilling(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.credit_card,
              color: isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF),
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              loc.billingTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF000000),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2A2A3E)
                    : const Color(0xFFF8F8FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF3A3A5E)
                      : const Color(0xFFEBEBFF),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Color(0xFFCC9300), size: 20),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Free Plan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF000000),
                        ),
                      ),
                      Text(
                        loc.billingDesc,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF9E9E9E)
                              : const Color(0xFF888888),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Upgrade to Pro to access billing management.',
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF9E9E9E)
                    : const Color(0xFF666666),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              loc.close,
              style: TextStyle(color: isDark ? const Color(0xFF9E9E9E) : null),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onTapBuyNow(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? const Color(0xFF6A59F1)
                  : const Color(0xFF1D00FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              loc.settingsBuyNow,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void onTapSecurity(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.security,
              color: isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF),
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              loc.securityTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF000000),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSecurityItem(
              Icons.lock_outline,
              'Change Password',
              isDark,
              () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.comingSoon),
                    backgroundColor: Color(0xFF1D00FF),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            _buildSecurityItem(
              Icons.fingerprint,
              'Biometric Login',
              isDark,
              () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.comingSoon),
                    backgroundColor: Color(0xFF1D00FF),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            _buildSecurityItem(
              Icons.verified_user_outlined,
              'Two-Factor Auth',
              isDark,
              () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.comingSoon),
                    backgroundColor: Color(0xFF1D00FF),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              loc.close,
              style: TextStyle(color: isDark ? const Color(0xFF9E9E9E) : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(
    IconData icon,
    String title,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF8F8FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? const Color(0xFF3A3A5E) : const Color(0xFFEBEBFF),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF),
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF000000),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? const Color(0xFF6B6B8A) : const Color(0xFF888888),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void onTapReminders(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.notifications_outlined,
              color: isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF),
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              loc.remindersTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF000000),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildReminderRow('Daily Idea Reminder', true, isDark),
            SizedBox(height: 10),
            _buildReminderRow('Weekly Progress Report', false, isDark),
            SizedBox(height: 10),
            _buildReminderRow('Team Activity Alerts', true, isDark),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              loc.close,
              style: TextStyle(color: isDark ? const Color(0xFF9E9E9E) : null),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.comingSoon),
                  backgroundColor: Color(0xFF1D00FF),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? const Color(0xFF6A59F1)
                  : const Color(0xFF1D00FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(loc.apply, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderRow(String title, bool enabled, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF8F8FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF3A3A5E) : const Color(0xFFEBEBFF),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF000000),
              ),
            ),
          ),
          Container(
            width: 40,
            height: 22,
            decoration: BoxDecoration(
              color: enabled
                  ? (isDark ? const Color(0xFF6A59F1) : const Color(0xFF1D00FF))
                  : (isDark
                        ? const Color(0xFF3A3A5E)
                        : const Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Align(
              alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTapLogout(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          loc.logoutConfirmTitle,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF000000),
          ),
        ),
        content: Text(
          loc.logoutConfirmDesc,
          style: TextStyle(
            color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF555555),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              loc.cancel,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF9E9E9E)
                    : const Color(0xFF888888),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await LocalStorageService.deleteToken();
              await LocalStorageService.clearAll();
              _resetSessionProviders();
              NavigatorService.pushNamedAndRemoveUntil(AppRoutes.welcomeScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF3B30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(loc.logout, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _resetSessionProviders() {
    ref.invalidate(settingsNotifier);
    ref.invalidate(ideasDashboardNotifier);
    ref.invalidate(projectExploreDashboardNotifier);
    ref.invalidate(magicIdeaChatNotifier);
  }
}

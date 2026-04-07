import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomAppBar - A flexible and reusable AppBar component that supports profile sections,
 * custom titles, and multiple action buttons with various layout configurations.
 * 
 * @param profileImagePath - Optional path to profile image
 * @param userName - User's display name for profile section
 * @param welcomeMessage - Subtitle text for profile section
 * @param title - Main title text for the AppBar
 * @param titleAlignment - Alignment for the title text
 * @param showProfile - Whether to show the profile section
 * @param actions - List of action widgets to display
 * @param backgroundColor - Background color of the AppBar
 * @param height - Custom height for the AppBar
 * @param padding - Custom padding for the AppBar content
 */
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.profileImagePath,
    this.userName,
    this.welcomeMessage,
    this.title,
    this.titleAlignment,
    this.showProfile,
    this.actions,
    this.backgroundColor,
    this.height,
    this.padding,
  }) : super(key: key);

  /// Path to the profile image
  final String? profileImagePath;

  /// User's display name
  final String? userName;

  /// Welcome or subtitle message
  final String? welcomeMessage;

  /// Main title text
  final String? title;

  /// Alignment for the title text
  final Alignment? titleAlignment;

  /// Whether to show profile section
  final bool? showProfile;

  /// List of action widgets
  final List<Widget>? actions;

  /// Background color of the AppBar
  final Color? backgroundColor;

  /// Custom height for the AppBar
  final double? height;

  /// Custom padding for the AppBar content
  final EdgeInsets? padding;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 56.h);

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final EdgeInsets appBarPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 18.h);

    return AppBar(
      backgroundColor: backgroundColor ?? appTheme.transparentCustom,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: height ?? 56.h,
      flexibleSpace: Container(
        padding: appBarPadding.copyWith(top: 20.h),
        alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
        child: _buildAppBarContent(context, isRtl),
      ),
    );
  }

  Widget _buildAppBarContent(BuildContext context, bool isRtl) {
    final bool shouldShowProfile = showProfile ?? false;

    if (shouldShowProfile &&
        (profileImagePath != null || userName != null || welcomeMessage != null)) {
      return _buildProfileAppBar(context, isRtl);
    } else if (title != null) {
      return _buildTitleAppBar(context, isRtl);
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildProfileAppBar(BuildContext context, bool isRtl) {
    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        _buildProfileSection(isRtl),
        Expanded(child: SizedBox()),
        if (actions != null) ...actions!,
      ],
    );
  }

  Widget _buildTitleAppBar(BuildContext context, bool isRtl) {
    final Alignment alignment = titleAlignment ?? Alignment.centerLeft;

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        if (alignment == Alignment.center || alignment == Alignment.centerLeft)
          Expanded(
            child: Align(
              alignment: alignment == Alignment.center
                  ? Alignment.center
                  : (isRtl ? Alignment.centerRight : Alignment.centerLeft),
              child: _buildTitleText(),
            ),
          ),
        if (alignment == Alignment.centerRight) Expanded(child: SizedBox()),
        if (alignment == Alignment.centerRight) _buildTitleText(),
        if (actions != null) ...[
          if (alignment != Alignment.centerRight) SizedBox(width: 8.h),
          ...actions!,
        ],
      ],
    );
  }

  Widget _buildProfileSection(bool isRtl) {
    final hasUserName = userName?.trim().isNotEmpty ?? false;
    final hasWelcomeMessage = welcomeMessage?.trim().isNotEmpty ?? false;

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        _buildProfileAvatar(),
        if (hasUserName || hasWelcomeMessage)
          SizedBox(width: 8.h),
        if (hasUserName || hasWelcomeMessage)
          _buildUserInfoColumn(isRtl),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    final imagePath = profileImagePath?.trim() ?? '';
    if (imagePath.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(27.h),
        child: CustomImageView(
          imagePath: imagePath,
          height: 48.h,
          width: 48.h,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 48.h,
      height: 48.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
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

  String _extractInitials(String? value) {
    final trimmed = value?.trim() ?? '';
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

  Widget _buildUserInfoColumn(bool isRtl) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final subTextColor = isDark
            ? const Color(0xFF9E9E9E)
            : const Color(0xFF888888);
        final nameColor = isDark ? Colors.white : const Color(0xFF000000);
        final welcome = welcomeMessage?.trim();
        final name = userName?.trim();
        final hasWelcome = welcome?.isNotEmpty ?? false;
        final hasName = name?.isNotEmpty ?? false;
        return Column(
          crossAxisAlignment: isRtl
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasWelcome)
              Text(
                welcome!,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyleHelper.instance.title12RegularSans.copyWith(
                  color: subTextColor,
                  height: 1.25,
                ),
              ),
            if (hasName) ...[
              SizedBox(height: 2.h),
              Text(
                name!,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyleHelper.instance.headline20BoldSans.copyWith(
                  color: nameColor,
                  height: 1.3,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTitleText() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Text(
          title!,
          style: TextStyleHelper.instance.headline24SemiBoldSans.copyWith(
            color: isDark ? Colors.white : const Color(0xFF000000),
            height: 1.5,
          ),
        );
      },
    );
  }
}

/// Helper class for creating common AppBar action buttons
class CustomAppBarAction extends StatelessWidget {
  const CustomAppBarAction({
    Key? key,
    required this.iconPath,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.margin,
    this.padding,
  }) : super(key: key);

  /// Path to the icon image
  final String iconPath;

  /// Callback function when button is tapped
  final VoidCallback? onTap;

  /// Background color of the button
  final Color? backgroundColor;

  /// Color of the icon
  final Color? iconColor;

  /// Size of the button
  final double? size;

  /// Margin around the button
  final EdgeInsets? margin;

  /// Padding inside the button
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final double buttonSize = size ?? 40.h;
    final EdgeInsets buttonPadding = padding ?? EdgeInsets.all(8.h);
    final EdgeInsets defaultMargin = isRtl
        ? EdgeInsets.only(right: 8.h)
        : EdgeInsets.only(left: 8.h);
    final EdgeInsets buttonMargin = margin ?? defaultMargin;

    return Container(
      margin: buttonMargin,
      child: Material(
        color: backgroundColor ?? Color(0xFFFBD060),
        borderRadius: BorderRadius.circular(10.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.h),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            padding: buttonPadding,
            child: CustomImageView(
              imagePath: iconPath,
              color: iconColor,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

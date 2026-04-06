import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomTaskCard - A reusable task/project card component with background image,
 * priority chips, team avatars, and status indicators. Supports optional action buttons
 * and flexible content layout with responsive design.
 * 
 * @param title - The main title text for the task
 * @param description - Descriptive text about the task
 * @param backgroundImage - Background image path for the card
 * @param primaryChip - Main category chip (e.g., "Design")
 * @param priorityChip - Priority level chip (e.g., "High", "Medium", "Low")
 * @param avatarImages - List of team member avatar image paths
 * @param teamCount - Additional team member count to display
 * @param statusText - Status text (e.g., "In Progress", "Completed")
 * @param statusIcon - Icon path for status indicator
 * @param actionIcon - Optional action button icon path
 * @param onActionTap - Callback for action button tap
 * @param onTap - Callback for card tap
 */
class CustomTaskCard extends StatelessWidget {
  const CustomTaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.backgroundImage,
    this.primaryChip,
    this.priorityChip,
    this.avatarImages,
    this.teamCount,
    this.statusText,
    this.statusIcon,
    this.actionIcon,
    this.onActionTap,
    this.onTap,
    this.width,
    this.height,
    this.margin,
  }) : super(key: key);

  final String title;
  final String description;
  final String backgroundImage;
  final String? primaryChip;
  final String? priorityChip;
  final List<String>? avatarImages;
  final int? teamCount;
  final String? statusText;
  final String? statusIcon;
  final String? actionIcon;
  final VoidCallback? onActionTap;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 400.h,
      height: height ?? 250.h,
      margin: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.h),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.h),
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.h),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(77),
                  Colors.black.withAlpha(179),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipRow(),
                SizedBox(height: 22.h),
                _buildTitle(),
                SizedBox(height: 24.h),
                _buildDescription(),
                Spacer(),
                _buildBottomRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChipRow() {
    return Row(
      children: [
        if (primaryChip != null) _buildChip(primaryChip!, true),
        if (primaryChip != null && priorityChip != null) SizedBox(width: 12.h),
        if (priorityChip != null) _buildChip(priorityChip!, false),
        Spacer(),
        if (actionIcon != null) _buildActionButton(),
      ],
    );
  }

  Widget _buildChip(String text, bool isPrimary) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: isPrimary ? 18.h : 14.h,
      ),
      decoration: BoxDecoration(
        color: isPrimary ? Color(0xFFFFFFFF) : appTheme.transparentCustom,
        border: isPrimary ? null : Border.all(color: Color(0xFFFFFFFF)),
        borderRadius: BorderRadius.circular(14.h),
      ),
      child: Text(
        text,
        style: TextStyleHelper.instance.body14RegularPoppins.copyWith(
          fontSize: isPrimary ? 14.fSize : 12.fSize,
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
          color: isPrimary ? Color(0xFF000000) : Color(0xFFFFFFFF),
          height: isPrimary ? 1.5 : 1.5,
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return InkWell(
      onTap: onActionTap,
      child: CustomImageView(imagePath: actionIcon!, width: 24.h, height: 24.h),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: TextStyleHelper.instance.headline20BoldSFProText.copyWith(
        color: Color(0xFFFFFFFF),
        height: 1.05,
      ),
    );
  }

  Widget _buildDescription() {
    return SizedBox(
      width: double.infinity * 0.8,
      child: Text(
        description,
        style: TextStyleHelper.instance.title12MediumSFProText.copyWith(
          color: Color(0x99FFFFFF),
          height: 1.75,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        _buildAvatarStack(),
        Spacer(),
        if (statusIcon != null || statusText != null) _buildStatusIndicator(),
      ],
    );
  }

  Widget _buildAvatarStack() {
    final displayAvatars = avatarImages ?? [];
    final maxDisplay = 3;
    final displayCount = displayAvatars.length > maxDisplay
        ? maxDisplay
        : displayAvatars.length;

    return Container(
      width: 84.h,
      height: 30.h,
      child: Stack(
        children: [
          // Avatar images
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: (i * 18).toDouble().h,
              child: CustomImageView(
                imagePath: displayAvatars[i],
                width: 28.h,
                height: 30.h,
                radius: BorderRadius.circular(14.h),
              ),
            ),
          // Team count indicator
          if (teamCount != null && teamCount! > 0)
            Positioned(
              right: 0,
              child: Container(
                height: 30.h,
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.h),
                decoration: BoxDecoration(
                  color: Color(0xFF4E56E2),
                  border: Border.all(color: Color(0xFFFFFFFF)),
                  borderRadius: BorderRadius.circular(14.h),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4.h,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgGroup,
                      width: 12.h,
                      height: 12.h,
                    ),
                    Text(
                      '+$teamCount',
                      style: TextStyleHelper.instance.title13BoldInter.copyWith(
                        color: Color(0xFFFFFFFF),
                        height: 1.23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (statusIcon != null)
          CustomImageView(imagePath: statusIcon!, width: 16.h, height: 16.h),
        if (statusIcon != null && statusText != null) SizedBox(width: 2.h),
        if (statusText != null)
          Text(
            statusText!,
            style: TextStyleHelper.instance.title12MediumSFProText.copyWith(
              color: Color(0xFFFFFFFF),
              height: 1.25,
            ),
          ),
      ],
    );
  }
}

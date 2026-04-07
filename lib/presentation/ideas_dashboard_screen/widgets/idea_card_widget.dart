import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/ideas_dashboard_model.dart';
import './team_member_item.dart';

class IdeaCardWidget extends StatelessWidget {
  final IdeaCardModel? idea;
  final VoidCallback? onTap;

  IdeaCardWidget({Key? key, required this.idea, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final backgroundSpec = idea?.backgroundImage ?? '';
    final customColor = _tryParseBackgroundColor(backgroundSpec);
    final assetBackground = _resolveBackgroundAsset(backgroundSpec);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 250.h,
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.h),
          gradient: customColor != null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _shiftColorLightness(customColor, 0.08),
                    _shiftColorLightness(customColor, -0.12),
                  ],
                )
              : null,
          image: customColor == null
              ? DecorationImage(
                  image: AssetImage(assetBackground),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: isRtl
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            _buildCategoryAndPriorityRow(context, isRtl),
            SizedBox(height: 22.h),
            _buildTitleSection(context, isRtl),
            SizedBox(height: 24.h),
            _buildDescriptionSection(context, isRtl),
            Spacer(),
            _buildBottomSection(context, isRtl),
          ],
        ),
      ),
    );
  }

  String _resolveBackgroundAsset(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return ImageConstant.imgRectangle29250x400;
    if (normalized.toLowerCase().startsWith('color:')) {
      return ImageConstant.imgRectangle29250x400;
    }
    if (_parseHexColor(normalized) != null) {
      return ImageConstant.imgRectangle29250x400;
    }
    return normalized;
  }

  Color? _tryParseBackgroundColor(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;

    if (normalized.toLowerCase().startsWith('color:')) {
      return _parseHexColor(normalized.substring('color:'.length));
    }

    return _parseHexColor(normalized);
  }

  Color? _parseHexColor(String value) {
    final cleaned = value.trim().replaceAll('#', '');
    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(cleaned)) return null;
    final full = 'FF${cleaned.toUpperCase()}';
    return Color(int.parse(full, radix: 16));
  }

  Color _shiftColorLightness(Color color, double delta) {
    final hsl = HSLColor.fromColor(color);
    final adjusted = (hsl.lightness + delta).clamp(0.0, 1.0).toDouble();
    return hsl.withLightness(adjusted).toColor();
  }

  Widget _buildCategoryAndPriorityRow(BuildContext context, bool isRtl) {
    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 4.h),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(14.h),
          ),
          child: Text(
            idea?.category ?? '',
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyleHelper.instance.title14SemiBoldPoppins.copyWith(
              color: Color(0xFF000000),
            ),
          ),
        ),
        SizedBox(width: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFFFFFFF)),
            borderRadius: BorderRadius.circular(14.h),
          ),
          child: Text(
            idea?.priority ?? '',
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        Spacer(),
        CustomImageView(
          imagePath: ImageConstant.imgGroupWhiteA700,
          height: 24.h,
          width: 24.h,
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context, bool isRtl) {
    return Text(
      idea?.title ?? '',
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      style: TextStyleHelper.instance.headline20BoldSFProText.copyWith(
        color: Color(0xFFFFFFFF),
        height: 1.05,
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, bool isRtl) {
    return Container(
      width: double.infinity * 0.8,
      child: Text(
        idea?.description ?? '',
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        style: TextStyleHelper.instance.title12MediumSFProText.copyWith(
          color: Color(0x99FFFFFF),
          height: 1.75,
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, bool isRtl) {
    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        _buildTeamMembersSection(context, isRtl),
        Spacer(),
        _buildStatusSection(context, isRtl),
      ],
    );
  }

  Widget _buildTeamMembersSection(BuildContext context, bool isRtl) {
    return Container(
      height: 30.h,
      child: Stack(
        children: [
          ...idea?.teamMembers?.asMap().entries.map((entry) {
                int index = entry.key;
                TeamMemberModel member = entry.value;
                return Positioned(
                  left: isRtl ? null : (index * 18).toDouble().h,
                  right: isRtl ? (index * 18).toDouble().h : null,
                  child: TeamMemberItem(member: member),
                );
              }).toList() ??
              [],
          if (idea?.additionalMembersCount?.isNotEmpty ?? false)
            Positioned(
              left: isRtl
                  ? null
                  : ((idea?.teamMembers?.length ?? 0) * 18).toDouble().h,
              right: isRtl
                  ? ((idea?.teamMembers?.length ?? 0) * 18).toDouble().h
                  : null,
              child: Container(
                width: 28.h,
                height: 30.h,
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Color(0xFF4E56E2),
                  border: Border.all(color: Color(0xFFFFFFFF)),
                  borderRadius: BorderRadius.circular(14.h),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4.h,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgGroup,
                      height: 12.h,
                      width: 12.h,
                    ),
                    Text(
                      idea?.additionalMembersCount?.replaceFirst('+', '') ?? '',
                      style: TextStyleHelper.instance.title13BoldInter.copyWith(
                        color: Color(0xFFFFFFFF),
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

  Widget _buildStatusSection(BuildContext context, bool isRtl) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgGroupAmber300,
          height: 16.h,
          width: 16.h,
        ),
        SizedBox(width: 4.h),
        Text(
          idea?.status ?? '',
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyleHelper.instance.title12MediumSFProText.copyWith(
            color: Color(0xFFFFFFFF),
          ),
        ),
      ],
    );
  }
}

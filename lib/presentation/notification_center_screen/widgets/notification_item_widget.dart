import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import 'package:ai_idea_generator/domain/models/notification_item_model.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItemModel notification;
  final VoidCallback? onTap;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(0xFF1E1E2E)
        : const Color(0x2B3D3DDB);
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final timeColor = isDark
        ? const Color(0xFF6B6B8A)
        : const Color(0xB2000000);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(30.h),
        ),
        child: Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            _buildNotificationIcon(context),
            SizedBox(width: 8.h),
            Expanded(
              child: Column(
                crossAxisAlignment: isRtl
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message ?? '',
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: TextStyleHelper.instance.body14RegularPoppins
                        .copyWith(color: textColor),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgClockForward,
                        height: 20.h,
                        width: 20.h,
                        color: isDark ? const Color(0xFF6B6B8A) : null,
                      ),
                      SizedBox(width: 4.h),
                      Text(
                        notification.timeAgo ?? '',
                        textDirection: isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: TextStyleHelper.instance.label11RegularPoppins
                            .copyWith(color: timeColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    switch (notification.type) {
      case NotificationType.projectReady:
        return CustomIconButton(
          iconPath: ImageConstant.imgGroup1000006182,
          size: 54.h,
          backgroundColor: Color(0xFF2918A6),
          borderRadius: BorderRadius.circular(26.h),
          padding: EdgeInsets.all(12.h),
        );
      case NotificationType.comment:
        return Container(
          height: 62.h,
          width: 62.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(31.h)),
          child: CustomImageView(
            imagePath: notification.userImage ?? ImageConstant.imgImage62x62,
            height: 62.h,
            width: 62.h,
            fit: BoxFit.cover,
          ),
        );
      case NotificationType.newTool:
        return CustomIconButton(
          iconPath: ImageConstant.imgGroup402,
          size: 54.h,
          backgroundColor: Color(0xFF2919A6),
          borderRadius: BorderRadius.circular(26.h),
          padding: EdgeInsets.all(14.h),
        );
      case NotificationType.likes:
        return CustomIconButton(
          iconPath: ImageConstant.imgGroup403,
          size: 54.h,
          backgroundColor: Color(0xFF2919A6),
          borderRadius: BorderRadius.circular(26.h),
          padding: EdgeInsets.all(6.h),
        );
      default:
        return CustomIconButton(
          iconPath: ImageConstant.imgGroup1000006182,
          size: 54.h,
          backgroundColor: Color(0xFF2918A6),
          borderRadius: BorderRadius.circular(26.h),
          padding: EdgeInsets.all(12.h),
        );
    }
  }
}

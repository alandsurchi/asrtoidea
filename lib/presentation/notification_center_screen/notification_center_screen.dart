import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../main_shell_screen/main_shell_screen.dart';
import 'package:ai_idea_generator/domain/models/notification_item_model.dart';
import './notifier/notification_center_notifier.dart';
import './widgets/notification_item_widget.dart';

class NotificationCenterScreen extends ConsumerStatefulWidget {
  NotificationCenterScreen({Key? key}) : super(key: key);

  @override
  NotificationCenterScreenState createState() =>
      NotificationCenterScreenState();
}

class NotificationCenterScreenState
    extends ConsumerState<NotificationCenterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationCenterNotifier.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF000000);
    final subTextColor = isDark
        ? const Color(0xFF6B6B8A)
        : const Color(0xFF848080);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          width: double.maxFinite,
          child: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(notificationCenterNotifier);
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 23.h),
                child: Column(
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildHeader(context, textColor),
                    SizedBox(height: 29.h),
                    _buildNotificationsList(
                      context,
                      state,
                      isRtl,
                      textColor,
                      subTextColor,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color textColor) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        loc.notification,
        style: TextStyleHelper.instance.headline24SemiBoldPoppins.copyWith(
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    NotificationCenterState state,
    bool isRtl,
    Color textColor,
    Color subTextColor,
  ) {
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        _buildTodaySection(context, state, isRtl, subTextColor),
        SizedBox(height: 30.h),
        _buildYesterdaySection(context, state, isRtl, subTextColor),
      ],
    );
  }

  Widget _buildTodaySection(
    BuildContext context,
    NotificationCenterState state,
    bool isRtl,
    Color subTextColor,
  ) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: isRtl
              ? EdgeInsets.only(right: 10.h)
              : EdgeInsets.only(left: 10.h),
          child: Text(
            loc.today,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyleHelper.instance.headline19RegularPoppins.copyWith(
              color: subTextColor,
            ),
          ),
        ),
        SizedBox(height: 18.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              state.notificationCenterModel?.todayNotifications?.length ?? 0,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final notification =
                state.notificationCenterModel?.todayNotifications?[index];
            return NotificationItemWidget(
              notification: notification!,
              onTap: () => onTapNotification(context, notification),
            );
          },
        ),
      ],
    );
  }

  Widget _buildYesterdaySection(
    BuildContext context,
    NotificationCenterState state,
    bool isRtl,
    Color subTextColor,
  ) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: isRtl
              ? EdgeInsets.only(right: 10.h)
              : EdgeInsets.only(left: 10.h),
          child: Text(
            loc.yesterday,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyleHelper.instance.headline19RegularPoppins.copyWith(
              color: subTextColor,
            ),
          ),
        ),
        SizedBox(height: 18.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              state.notificationCenterModel?.yesterdayNotifications?.length ??
              0,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final notification =
                state.notificationCenterModel?.yesterdayNotifications?[index];
            return NotificationItemWidget(
              notification: notification!,
              onTap: () => onTapNotification(context, notification),
            );
          },
        ),
      ],
    );
  }

  void onTapNotification(
    BuildContext context,
    NotificationItemModel notification,
  ) {
    switch (notification.type) {
      case NotificationType.projectReady:
      case NotificationType.comment:
      case NotificationType.likes:
        MainShellScreen.goToTab(1);
        break;
      case NotificationType.newTool:
        MainShellScreen.goToTab(2);
        break;
      case null:
        break;
    }
  }
}

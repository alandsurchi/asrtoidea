import 'package:ai_idea_generator/domain/models/notification_center_model.dart';
import '../../../core/app_export.dart';

part 'notification_center_state.dart';

final notificationCenterNotifier =
    StateNotifierProvider.autoDispose<
      NotificationCenterNotifier,
      NotificationCenterState
    >(
      (ref) => NotificationCenterNotifier(
        NotificationCenterState(
          notificationCenterModel: NotificationCenterModel(),
        ),
      ),
    );

class NotificationCenterNotifier
    extends StateNotifier<NotificationCenterState> {
  NotificationCenterNotifier(NotificationCenterState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      notificationCenterModel: NotificationCenterModel(),
      isLoading: false,
    );
  }

  void markNotificationAsRead(String notificationId) {
    final updatedTodayNotifications = state
        .notificationCenterModel
        ?.todayNotifications
        ?.map((notification) {
          if (notification.id == notificationId) {
            // Mark as read logic can be added here
            return notification;
          }
          return notification;
        })
        .toList();

    final updatedYesterdayNotifications = state
        .notificationCenterModel
        ?.yesterdayNotifications
        ?.map((notification) {
          if (notification.id == notificationId) {
            // Mark as read logic can be added here
            return notification;
          }
          return notification;
        })
        .toList();

    state = state.copyWith(
      notificationCenterModel: state.notificationCenterModel?.copyWith(
        todayNotifications: updatedTodayNotifications,
        yesterdayNotifications: updatedYesterdayNotifications,
      ),
    );
  }

  void refreshNotifications() {
    state = state.copyWith(isLoading: true);

    // Simulate refresh
    Future.delayed(Duration(milliseconds: 500), () {
      state = state.copyWith(
        notificationCenterModel: NotificationCenterModel(),
        isLoading: false,
      );
    });
  }
}

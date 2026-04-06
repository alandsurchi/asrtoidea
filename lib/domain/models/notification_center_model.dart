import '../../../core/app_export.dart';
import './notification_item_model.dart';

/// This class is used in the [notification_center_screen] screen.

// ignore_for_file: must_be_immutable
class NotificationCenterModel extends Equatable {
  NotificationCenterModel({
    this.todayNotifications,
    this.yesterdayNotifications,
  }) {
    todayNotifications = todayNotifications ?? _getDefaultTodayNotifications();
    yesterdayNotifications =
        yesterdayNotifications ?? _getDefaultYesterdayNotifications();
  }

  List<NotificationItemModel>? todayNotifications;
  List<NotificationItemModel>? yesterdayNotifications;

  NotificationCenterModel copyWith({
    List<NotificationItemModel>? todayNotifications,
    List<NotificationItemModel>? yesterdayNotifications,
  }) {
    return NotificationCenterModel(
      todayNotifications: todayNotifications ?? this.todayNotifications,
      yesterdayNotifications:
          yesterdayNotifications ?? this.yesterdayNotifications,
    );
  }

  @override
  List<Object?> get props => [todayNotifications, yesterdayNotifications];

  List<NotificationItemModel> _getDefaultTodayNotifications() {
    return [
      NotificationItemModel(
        id: '1',
        type: NotificationType.projectReady,
        message: 'Your AI-generated project is ready to view',
        timeAgo: '10 min ago',
      ),
      NotificationItemModel(
        id: '2',
        type: NotificationType.comment,
        message: 'Someone commented on your project idea',
        timeAgo: '59 min ago',
        userImage: ImageConstant.imgImage62x62,
      ),
      NotificationItemModel(
        id: '3',
        type: NotificationType.newTool,
        message: 'A new AI tool is now available,try!!!',
        timeAgo: '5 hours ago',
      ),
      NotificationItemModel(
        id: '4',
        type: NotificationType.newTool,
        message: 'A new AI tool is now available,try!!!',
        timeAgo: '9 hours ago',
      ),
      NotificationItemModel(
        id: '5',
        type: NotificationType.likes,
        message: 'Your project received 5 new likes today',
        timeAgo: '15 hours ago',
      ),
    ];
  }

  List<NotificationItemModel> _getDefaultYesterdayNotifications() {
    return [
      NotificationItemModel(
        id: '6',
        type: NotificationType.projectReady,
        message: 'Your AI-generated project is ready to view',
        timeAgo: '10 min ago',
      ),
    ];
  }
}

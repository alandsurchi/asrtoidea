part of 'notification_center_notifier.dart';

class NotificationCenterState extends Equatable {
  final NotificationCenterModel? notificationCenterModel;
  final bool? isLoading;

  NotificationCenterState({
    this.notificationCenterModel,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [notificationCenterModel, isLoading];

  NotificationCenterState copyWith({
    NotificationCenterModel? notificationCenterModel,
    bool? isLoading,
  }) {
    return NotificationCenterState(
      notificationCenterModel:
          notificationCenterModel ?? this.notificationCenterModel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

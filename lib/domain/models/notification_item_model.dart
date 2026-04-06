import '../../../core/app_export.dart';

enum NotificationType { projectReady, comment, newTool, likes }

/// This class is used for individual notification items.

// ignore_for_file: must_be_immutable
class NotificationItemModel extends Equatable {
  NotificationItemModel({
    this.id,
    this.type,
    this.message,
    this.timeAgo,
    this.userImage,
  }) {
    id = id ?? '';
    type = type ?? NotificationType.projectReady;
    message = message ?? '';
    timeAgo = timeAgo ?? '';
    userImage = userImage ?? '';
  }

  String? id;
  NotificationType? type;
  String? message;
  String? timeAgo;
  String? userImage;

  NotificationItemModel copyWith({
    String? id,
    NotificationType? type,
    String? message,
    String? timeAgo,
    String? userImage,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      timeAgo: timeAgo ?? this.timeAgo,
      userImage: userImage ?? this.userImage,
    );
  }

  @override
  List<Object?> get props => [id, type, message, timeAgo, userImage];
}

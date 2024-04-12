part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class AddNotification extends NotificationEvent {
  final MyNotificationModel notification;

  const AddNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}

class UpdateNotification extends NotificationEvent {
  final MyNotificationModel notification;

  const UpdateNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class GetNotifications extends NotificationEvent {}

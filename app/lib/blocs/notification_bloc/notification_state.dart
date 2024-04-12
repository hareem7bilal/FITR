part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<MyNotificationModel> notifications;

  const NotificationsLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationOperationSuccess extends NotificationState {}

class NotificationOperationFailure extends NotificationState {
  final String error;

  const NotificationOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

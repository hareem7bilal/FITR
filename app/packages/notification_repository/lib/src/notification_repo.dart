import 'package:notification_repository/src/models/models.dart';

abstract class NotificationRepository {
  Future<void> addNotification(MyNotificationModel notification);
  Future<void> updateNotification(MyNotificationModel notification);
  Future<MyNotificationModel> getNotification(String notificationId);
  Stream<List<MyNotificationModel>> getNotifications();
  Future<void> deleteNotification(String notificationId);
}

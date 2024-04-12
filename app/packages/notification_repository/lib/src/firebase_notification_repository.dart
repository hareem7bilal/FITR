import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notification_repository/src/entities/my_notification_entity.dart';
import 'package:notification_repository/src/models/my_notification_model.dart';
import 'notification_repo.dart';

class FirebaseNotificationRepository implements NotificationRepository {
  final FirebaseFirestore _firestore;

  FirebaseNotificationRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _notificationsCollection => _firestore.collection('notifications');

  @override
  Future<void> addNotification(MyNotificationModel notification) async {
    try {
      await _notificationsCollection.add(notification.toEntity().toDocument());
    } catch (e) {
      log("Failed to add notification: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> updateNotification(MyNotificationModel notification) async {
    try {
      // Assuming notifications are uniquely identified by 'userId' for simplicity; adjust as necessary.
      await _notificationsCollection.doc(notification.userId).update(notification.toEntity().toDocument());
    } catch (e) {
      log("Failed to update notification: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<MyNotificationModel> getNotification(String notificationId) async {
    try {
      DocumentSnapshot snapshot = await _notificationsCollection.doc(notificationId).get();
      var data = snapshot.data();
      if (data != null) {
        return MyNotificationModel.fromEntity(MyNotificationEntity.fromDocument(data as Map<String, dynamic>));
      } else {
        throw Exception("Notification not found");
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<MyNotificationModel>> getNotifications() {
    return _notificationsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MyNotificationModel.fromEntity(MyNotificationEntity.fromDocument(doc.data() as Map<String, dynamic>))).toList();
    });
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
    } catch (e) {
      log("Failed to delete notification: ${e.toString()}");
      rethrow;
    }
  }
}

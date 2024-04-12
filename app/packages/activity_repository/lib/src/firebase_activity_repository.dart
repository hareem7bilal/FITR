import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:activity_repository/src/entities/my_activity_entity.dart';
import 'package:activity_repository/src/models/my_activity_model.dart';
import 'activity_repo.dart';

class FirebaseActivityRepository implements ActivityRepository {
  final FirebaseFirestore _firestore;

  FirebaseActivityRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _activitiesCollection => _firestore.collection('activities');

  @override
  Future<void> addActivity(MyActivityModel activity) async {
    try {
      await _activitiesCollection.add(activity.toEntity().toDocument());
    } catch (e) {
      log("Failed to add activity: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> updateActivity(MyActivityModel activity) async {
    try {
      // Using 'userId' as the document identifier for this example; adjust if necessary
      await _activitiesCollection.doc(activity.userId).update(activity.toEntity().toDocument());
    } catch (e) {
      log("Failed to update activity: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<MyActivityModel> getActivity(String activityId) async {
    try {
      DocumentSnapshot snapshot = await _activitiesCollection.doc(activityId).get();
      var data = snapshot.data();
      if (data != null) {
        return MyActivityModel.fromEntity(MyActivityEntity.fromDocument(data as Map<String, dynamic>));
      } else {
        throw Exception("Activity not found");
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<MyActivityModel>> getActivities() {
    return _activitiesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MyActivityModel.fromEntity(MyActivityEntity.fromDocument(doc.data() as Map<String, dynamic>))).toList();
    });
  }

  @override
  Future<void> deleteActivity(String activityId) async {
    try {
      await _activitiesCollection.doc(activityId).delete();
    } catch (e) {
      log("Failed to delete activity: ${e.toString()}");
      rethrow;
    }
  }
}

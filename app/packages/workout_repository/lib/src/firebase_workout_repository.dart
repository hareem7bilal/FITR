import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_repository/src/entities/my_workout_entity.dart';
import 'package:workout_repository/src/models/my_workout_model.dart';
import 'workout_repo.dart';

class FirebaseWorkoutRepository implements WorkoutRepository {
  final FirebaseFirestore _firestore;

  FirebaseWorkoutRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _workoutsCollection => _firestore.collection('workouts');

  @override
  Future<void> addWorkout(MyWorkoutModel workout) async {
    try {
      await _workoutsCollection.add(workout.toEntity().toDocument());
    } catch (e) {
      log("Failed to add workout: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> updateWorkout(MyWorkoutModel workout) async {
    try {
      await _workoutsCollection.doc(workout.name).update(workout.toEntity().toDocument());
    } catch (e) {
      log("Failed to update workout: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<MyWorkoutModel> getWorkout(String workoutId) async {
    try {
      DocumentSnapshot snapshot = await _workoutsCollection.doc(workoutId).get();
      var data = snapshot.data();
      if (data != null) {
        return MyWorkoutModel.fromEntity(MyWorkoutEntity.fromDocument(data as Map<String, dynamic>));
      } else {
        throw Exception("Workout not found");
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<MyWorkoutModel>> getWorkouts() {
    return _workoutsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MyWorkoutModel.fromEntity(MyWorkoutEntity.fromDocument(doc.data() as Map<String, dynamic>))).toList();
    });
  }

  @override
  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _workoutsCollection.doc(workoutId).delete();
    } catch (e) {
      log("Failed to delete workout: ${e.toString()}");
      rethrow;
    }
  }
}

import 'package:workout_repository/src/models/models.dart';

abstract class WorkoutRepository {
  Future<void> addWorkout(MyWorkoutModel workout);
  Future<void> updateWorkout(MyWorkoutModel workout);
  Future<MyWorkoutModel> getWorkout(String workoutId);
  Stream<List<MyWorkoutModel>> getWorkoutsByUserId(String userId);
  Future<void> deleteWorkout(String workoutId);
}

part of 'workout_bloc.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object> get props => [];
}

class AddWorkout extends WorkoutEvent {
  final MyWorkoutModel workout;

  const AddWorkout(this.workout);

  @override
  List<Object> get props => [workout];
}

class UpdateWorkout extends WorkoutEvent {
  final MyWorkoutModel workout;

  const UpdateWorkout(this.workout);

  @override
  List<Object> get props => [workout];
}

class DeleteWorkout extends WorkoutEvent {
  final String workoutId;

  const DeleteWorkout(this.workoutId);

  @override
  List<Object> get props => [workoutId];
}

class GetWorkout extends WorkoutEvent {
  final String workoutId;

  const GetWorkout(this.workoutId);

  @override
  List<Object> get props => [workoutId];
}

class GetWorkouts extends WorkoutEvent {
  const GetWorkouts();
}

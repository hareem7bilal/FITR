part of 'workout_bloc.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutOperationSuccess extends WorkoutState {}

class WorkoutOperationFailure extends WorkoutState {
  final String error;

  const WorkoutOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class WorkoutFetchSuccess extends WorkoutState {
  final MyWorkoutModel workout;

  const WorkoutFetchSuccess(this.workout);

  @override
  List<Object> get props => [workout];
}

class WorkoutLoaded extends WorkoutState {
  final List<MyWorkoutModel> workouts;

  const WorkoutLoaded(this.workouts);

  @override
  List<Object> get props => [workouts];
}

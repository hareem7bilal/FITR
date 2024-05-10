import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:workout_repository/workout_repository.dart'; // Adjust this import based on your project structure
//import 'dart:async'; // for StreamSubscription
part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository _workoutRepository;
  //StreamSubscription<List<MyWorkoutModel>>? _workoutsSubscription;

  WorkoutBloc({required WorkoutRepository workoutRepository})
      : _workoutRepository = workoutRepository,
        super(WorkoutInitial()) {
    on<AddWorkout>((event, emit) async {
      try {
        emit(WorkoutLoading());
        await _workoutRepository.addWorkout(event.workout);
        emit(WorkoutOperationSuccess());
      } catch (e, stacktrace) {
        log(e.toString());
        emit(WorkoutOperationFailure(
            error: e.toString(), stackTrace: stacktrace.toString()));
      }
    });

    on<UpdateWorkout>((event, emit) async {
      try {
        emit(WorkoutLoading());
        await _workoutRepository.updateWorkout(event.workout);
        emit(WorkoutOperationSuccess());
      } catch (e, stacktrace) {
        emit(WorkoutOperationFailure(
            error: e.toString(), stackTrace: stacktrace.toString()));
      }
    });

    on<DeleteWorkout>((event, emit) async {
      try {
        emit(WorkoutLoading()); // This might cause the loading spinner
        await _workoutRepository.deleteWorkout(event.workoutId);

        // Get the current state and remove the deleted workout
        if (state is WorkoutLoaded) {
          final currentWorkouts = (state as WorkoutLoaded).workouts;
          final updatedWorkouts =
              currentWorkouts.where((w) => w.id != event.workoutId).toList();
          emit(WorkoutLoaded(updatedWorkouts));
        } else {
          emit(WorkoutOperationSuccess());
        }
      } catch (e, stacktrace) {
        emit(WorkoutOperationFailure(
            error: e.toString(), stackTrace: stacktrace.toString()));
      }
    });

    on<GetWorkout>((event, emit) async {
      try {
        emit(WorkoutLoading());
        final workout = await _workoutRepository.getWorkout(event.workoutId);
        emit(WorkoutFetchSuccess(workout));
      } catch (e, stacktrace) {
        emit(WorkoutOperationFailure(
            error: e.toString(), stackTrace: stacktrace.toString()));
      }
    });

    on<GetWorkouts>((event, emit) async {
      emit(WorkoutLoading());
      try {
        // Directly listen to the stream from the repository
        var workoutsStream =
            _workoutRepository.getWorkoutsByUserId(event.userId);
        await for (var workouts in workoutsStream) {
          emit(WorkoutLoaded(workouts));
        }
      } catch (e, stacktrace) {
        emit(WorkoutOperationFailure(
            error: e.toString(), stackTrace: stacktrace.toString()));
      }
    });
  }
}

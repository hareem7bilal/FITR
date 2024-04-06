import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:workout_repository/workout_repository.dart'; // Adjust this import based on your project structure
import 'dart:async'; // Import required for StreamSubscription
part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository _workoutRepository;
  StreamSubscription<List<MyWorkoutModel>>? _workoutsSubscription;

  WorkoutBloc({required WorkoutRepository workoutRepository})
      : _workoutRepository = workoutRepository,
        super(WorkoutInitial()) {
    on<AddWorkout>((event, emit) async {
      try {
        emit(WorkoutLoading());
        await _workoutRepository.addWorkout(event.workout);
        emit(WorkoutOperationSuccess());
      } catch (e) {
        log(e.toString());
        emit(WorkoutOperationFailure(e.toString()));
      }
    });

    on<UpdateWorkout>((event, emit) async {
      try {
        emit(WorkoutLoading());
        await _workoutRepository.updateWorkout(event.workout);
        emit(WorkoutOperationSuccess());
      } catch (e) {
        log(e.toString());
        emit(WorkoutOperationFailure(e.toString()));
      }
    });

    on<DeleteWorkout>((event, emit) async {
      try {
        emit(WorkoutLoading());
        await _workoutRepository.deleteWorkout(event.workoutId);
        emit(WorkoutOperationSuccess());
      } catch (e) {
        log(e.toString());
        emit(WorkoutOperationFailure(e.toString()));
      }
    });

    on<GetWorkout>((event, emit) async {
      try {
        emit(WorkoutLoading());
        final workout = await _workoutRepository.getWorkout(event.workoutId);
        emit(WorkoutFetchSuccess(workout));
      } catch (e) {
        log(e.toString());
        emit(WorkoutOperationFailure(e.toString()));
      }
    });

    on<GetWorkouts>((event, emit) {
      emit(WorkoutLoading());
      _workoutsSubscription?.cancel(); // Cancel any existing subscription
      _workoutsSubscription = _workoutRepository.getWorkouts().listen(
            (workouts) =>
                emit(WorkoutLoaded(workouts)), // Emit loaded state on new data
            onError: (error) => emit(WorkoutOperationFailure(
                error.toString())), // Emit failure state on error
          );
    });
  }
}

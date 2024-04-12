import 'dart:async'; // Import required for StreamSubscription
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:activity_repository/activity_repository.dart'; // Adjust this import based on your project structure
part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository _activityRepository;
  StreamSubscription<List<MyActivityModel>>? _activitiesSubscription;

  ActivityBloc({required ActivityRepository activityRepository})
      : _activityRepository = activityRepository,
        super(ActivityInitial()) {
    on<AddActivity>((event, emit) async {
      try {
        emit(ActivityLoading());
        await _activityRepository.addActivity(event.activity);
        emit(ActivityOperationSuccess());
      } catch (e) {
        log(e.toString());
        emit(ActivityOperationFailure(e.toString()));
      }
    });

    on<UpdateActivity>((event, emit) async {
      try {
        emit(ActivityLoading());
        await _activityRepository.updateActivity(event.activity);
        emit(ActivityOperationSuccess());
      } catch (e) {
        log(e.toString());
        emit(ActivityOperationFailure(e.toString()));
      }
    });

    on<DeleteActivity>((event, emit) async {
      try {
        emit(ActivityLoading());
        await _activityRepository.deleteActivity(event.activityId);
        emit(ActivityOperationSuccess());
      } catch (e) {
        log(e.toString());
        emit(ActivityOperationFailure(e.toString()));
      }
    });

    on<GetActivity>((event, emit) async {
      try {
        emit(ActivityLoading());
        final activity = await _activityRepository.getActivity(event.activityId);
        emit(ActivityFetchSuccess(activity));
      } catch (e) {
        log(e.toString());
        emit(ActivityOperationFailure(e.toString()));
      }
    });

    on<GetActivities>((event, emit) {
      emit(ActivityLoading());
      _activitiesSubscription?.cancel(); // Cancel any existing subscription
      _activitiesSubscription = _activityRepository.getActivities().listen(
            (activities) =>
                emit(ActivityLoaded(activities)), // Emit loaded state on new data
            onError: (error) => emit(ActivityOperationFailure(
                error.toString())), // Emit failure state on error
          );
    });
  }

  @override
  Future<void> close() {
    _activitiesSubscription?.cancel();
    return super.close();
  }
}

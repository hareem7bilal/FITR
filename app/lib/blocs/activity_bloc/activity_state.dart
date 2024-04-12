part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final List<MyActivityModel> activities;

  const ActivityLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

class ActivityFetchSuccess extends ActivityState {
  final MyActivityModel activity;

  const ActivityFetchSuccess(this.activity);

  @override
  List<Object?> get props => [activity];
}

class ActivityOperationSuccess extends ActivityState {}

class ActivityOperationFailure extends ActivityState {
  final String error;

  const ActivityOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

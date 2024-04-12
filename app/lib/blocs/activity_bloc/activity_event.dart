part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class AddActivity extends ActivityEvent {
  final MyActivityModel activity;

  const AddActivity(this.activity);

  @override
  List<Object?> get props => [activity];
}

class UpdateActivity extends ActivityEvent {
  final MyActivityModel activity;

  const UpdateActivity(this.activity);

  @override
  List<Object?> get props => [activity];
}

class DeleteActivity extends ActivityEvent {
  final String activityId;

  const DeleteActivity(this.activityId);

  @override
  List<Object?> get props => [activityId];
}

class GetActivity extends ActivityEvent {
  final String activityId;

  const GetActivity(this.activityId);

  @override
  List<Object?> get props => [activityId];
}

class GetActivities extends ActivityEvent {}

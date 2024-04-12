import 'package:activity_repository/src/models/models.dart';

abstract class ActivityRepository {
  Future<void> addActivity(MyActivityModel activity);
  Future<void> updateActivity(MyActivityModel activity);
  Future<MyActivityModel> getActivity(String activityId);
  Stream<List<MyActivityModel>> getActivities();
  Future<void> deleteActivity(String activityId);
}

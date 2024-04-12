import 'dart:async'; // Import required for StreamSubscription
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_repository/notification_repository.dart'; // Adjust this import based on your project structure
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;
  StreamSubscription<List<MyNotificationModel>>? _notificationsSubscription;

  NotificationBloc({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(NotificationInitial()) {
    on<AddNotification>((event, emit) async {
      try {
        emit(NotificationLoading());
        await _notificationRepository.addNotification(event.notification);
        emit(NotificationOperationSuccess());
      } catch (e) {
        log(e.toString());
        emit(NotificationOperationFailure(e.toString()));
      }
    });

    on<UpdateNotification>((event, emit) async {
      try {
        emit(NotificationLoading());
        await _notificationRepository.updateNotification(event.notification);
        emit(NotificationOperationSuccess());
      } catch (e) {
        log(e.toString());
        emit(NotificationOperationFailure(e.toString()));
      }
    });

    on<DeleteNotification>((event, emit) async {
      try {
        emit(NotificationLoading());
        await _notificationRepository.deleteNotification(event.notificationId);
        emit(NotificationOperationSuccess());
      } catch (e) {
        log(e.toString());
        emit(NotificationOperationFailure(e.toString()));
      }
    });

    on<GetNotifications>((event, emit) {
      emit(NotificationLoading());
      _notificationsSubscription?.cancel(); // Cancel any existing subscription
      _notificationsSubscription = _notificationRepository.getNotifications().listen(
            (notifications) => emit(NotificationsLoaded(notifications)), // Emit loaded state on new data
            onError: (error) => emit(NotificationOperationFailure(
                error.toString())), // Emit failure state on error
          );
    });
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}

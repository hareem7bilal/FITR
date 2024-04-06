import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({required UserRepository myUserRepository})
      : _userRepository = myUserRepository,
        super(const UserState.loading()) {
    on<GetUser>((event, emit) async {
      try {
        MyUserModel user = await _userRepository.getUserData(event.userId);
        emit(UserState.success(user));
      } catch (e) {
        log(e.toString());
        emit(const UserState.failure());
      }
    });

    on<UpdateUser>((event, emit) async {
      try {
        emit(const UserState
            .updateInProgress()); // Indicate that update is in progress
        await _userRepository.updateUserProfile(
            event.updatedUser); // Pass the updated user details
        emit(UserState.updateSuccess(event.updatedUser)); // Indicate success
      } catch (e) {
        log(e.toString());
        emit(const UserState.updateFailure()); // Indicate failure
      }
    });
  }
}

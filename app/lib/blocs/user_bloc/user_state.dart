part of 'user_bloc.dart';

enum UserStatus { success, loading, failure }


class UserState extends Equatable {
  final UserStatus status;
  final MyUserModel? user;
  final bool updateUserInProgress;
  final bool updateUserSuccess;
  final bool updateUserFailure;

  const UserState._({
    this.status = UserStatus.loading,
    this.user,
    this.updateUserInProgress = false,
    this.updateUserSuccess = false,
    this.updateUserFailure = false,
  });

  // Original factory constructors remain the same
  const UserState.loading() : this._();
  const UserState.success(MyUserModel user)
      : this._(status: UserStatus.success, user: user);
  const UserState.failure()
      : this._(status: UserStatus.failure);

  // Add factory constructors for update process
  const UserState.updateInProgress() 
      : this._(updateUserInProgress: true);

  const UserState.updateSuccess(MyUserModel user) 
      : this._(status: UserStatus.success, user: user, updateUserSuccess: true);

  const UserState.updateFailure() 
      : this._(updateUserFailure: true);

  @override
  List<Object?> get props => [status, user, updateUserInProgress, updateUserSuccess, updateUserFailure];
}


part of 'user_bloc.dart';

enum UserStatus { success, loading, failure }

class UserState extends Equatable {
  final UserStatus status;
  final MyUserModel? user;

  const UserState._({
    this.status = UserStatus.loading,
    this.user,
  });

  const UserState.loading() : this._();
  const UserState.success(MyUserModel user)
      : this._(status: UserStatus.success, user: user);
  const UserState.failure()
      : this._(status: UserStatus.failure);


  @override
  List<Object?> get props => [status, user];
}

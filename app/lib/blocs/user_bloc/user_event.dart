part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object> get props => [];
}

class GetUser extends UserEvent {
  final String userId;
  const GetUser({required this.userId});
   @override
  List<Object> get props => [userId];
}

class UpdateUser extends UserEvent {
  final MyUserModel updatedUser;
  const UpdateUser(this.updatedUser);

  @override
  List<Object> get props => [updatedUser];
}




part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
  @override
  List<Object> get props => [];
}

class SignUpRequired extends SignUpEvent {
  final MyUserModel user;
  final String password;
  const SignUpRequired(this.user, this.password);
  // New
  @override
  List<Object> get props => [user, password];
}
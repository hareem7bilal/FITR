part of 'sign_in_bloc.dart';

@immutable
abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInSuccess extends SignInState {}

final class SignInFailure extends SignInState {
  final String? msg;
  const SignInFailure({this.msg});
  
}

final class SignInProcess extends SignInState {}

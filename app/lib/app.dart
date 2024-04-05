import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart'; 
import 'package:flutter_application_1/blocs/sign_up_bloc/sign_up_bloc.dart'; 
import 'package:flutter_application_1/blocs/sign_in_bloc/sign_in_bloc.dart'; 
import 'package:flutter_application_1/blocs/user_bloc/user_bloc.dart'; 
import 'app_view.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp(this.userRepository, {super.key}); // Fixing the constructor

  @override
  Widget build(BuildContext context) {
    // new
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(value: userRepository),
        RepositoryProvider<SignUpBloc>(
          create: (context) => SignUpBloc(
            myUserRepository: userRepository,
          ),
        ),
        RepositoryProvider<SignInBloc>(
          create: (context) => SignInBloc(
            myUserRepository: userRepository
          ),
        ),
        RepositoryProvider<UserBloc>(
          create: (context) => UserBloc(
            myUserRepository: userRepository,
          ),
        ),
        RepositoryProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            myUserRepository: userRepository,
          ),
        ),
      ], child: const AppView());
  }
}

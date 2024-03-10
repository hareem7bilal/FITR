import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart'; // Import AuthenticationBloc
import 'app_view.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp(this.userRepository, {super.key}); // Fixing the constructor

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
          myUserRepository: userRepository,
        ), // Provide an instance of AuthenticationBloc
      ),
    ], child: const AppView());
  }
}

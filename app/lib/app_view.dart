import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_application_1/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:flutter_application_1/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_application_1/blocs/sign_in_bloc/sign_in_bloc.dart';
// import 'package:flutter_application_1/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:flutter_application_1/views/authentication/welcome_screen.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'views/home/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'Flutter Fitness Tracker',
				theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
        scaffoldBackgroundColor: Colors.white,
      ),
			home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
				builder: (context, state) {
					if(state.status == AuthenticationStatus.authenticated) {
						return MultiBlocProvider(
								providers: [
									BlocProvider(
										create: (context) => SignInBloc(
											userRepository: context.read<AuthenticationBloc>().userRepository
										),
									),
									// BlocProvider(
									// 	create: (context) => UpdateUserInfoBloc(
									// 		userRepository: context.read<AuthenticationBloc>().userRepository
									// 	),
									// ),
									BlocProvider(
										create: (context) => MyUserBloc(
											myUserRepository: context.read<AuthenticationBloc>().userRepository
										)..add(GetMyUser(
											myUserId: context.read<AuthenticationBloc>().state.user!.uid
										)),
									),
									// BlocProvider(
									// 	create: (context) => GetPostBloc(
									// 		postRepository: FirebasePostRepository()
									// 	)..add(GetPosts())
									// )
								],
							child: const HomeScreen(),
						);
					} else {
						return const WelcomeScreen();
					}
				}
			),
		);
  }
}
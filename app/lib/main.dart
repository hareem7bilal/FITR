import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/views/login/signup_view.dart';
import 'package:flutter_application_1/views/login/signin_view.dart';
import 'package:flutter_application_1/views/onboarding/starting_view.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'simple_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart';
// import 'package:user_repository/src/firebase_user_repository.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    ]);
    Bloc.observer = SimpleBlocObserver();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(MyApp(FirebaseUserRepository()));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
			providers: [
				RepositoryProvider<AuthenticationBloc>(
					create: (_) => AuthenticationBloc(
						myUserRepository: this.userRepository
					)
				)
			], 
			child: const MyAppView()
		);
  } 
}

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
        scaffoldBackgroundColor: Colors.white,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder:(context, state) {
          if(state.status == AuthenticationState.authenticated){
            return StartingView(); // Home Page
          } else {
            return SigninView(); // Login Page
          }
        }
      ),
    );
  }
}



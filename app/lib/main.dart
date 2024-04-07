import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'simple_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: kIsWeb ? 
      const FirebaseOptions(
        apiKey: "AIzaSyAQBfCzt8DhBd3kxoxS5Yj_HT8bnE_UhxA",
        appId: "1:993820244946:web:c865f2a368a757590d660b",
        messagingSenderId: "993820244946",
        projectId: "flutterfitnessapp-67e62",
        storageBucket: "flutterfitnessapp-67e62.appspot.com",
      ) : DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Pass the instance of Firestore to your app if needed
  runApp(MyApp(FirebaseUserRepository()));
}

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQBfCzt8DhBd3kxoxS5Yj_HT8bnE_UhxA',
    appId: '1:993820244946:web:c865f2a368a757590d660b',
    messagingSenderId: '993820244946',
    projectId: 'flutterfitnessapp-67e62',
    authDomain: 'flutterfitnessapp-67e62.firebaseapp.com',
    storageBucket: 'flutterfitnessapp-67e62.appspot.com',
    measurementId: 'G-MT0SD0EKZN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhgC71bYaMNTfi1TUrdJiMMFEf8lBD3yE',
    appId: '1:993820244946:android:7134a4e6f979e02d0d660b',
    messagingSenderId: '993820244946',
    projectId: 'flutterfitnessapp-67e62',
    storageBucket: 'flutterfitnessapp-67e62.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB812VckXjtEcVYrrYCEUbA1eH3kcsVAyE',
    appId: '1:993820244946:ios:e6798905e9ef506c0d660b',
    messagingSenderId: '993820244946',
    projectId: 'flutterfitnessapp-67e62',
    storageBucket: 'flutterfitnessapp-67e62.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );
}

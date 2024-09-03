// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyC6_CqX3afu4gFW8ULs9h-_3kvsmuHXjmA',
    appId: '1:547111368215:web:7fd6dd9e6720e638aa4e52',
    messagingSenderId: '547111368215',
    projectId: 'todolistteam-de27a',
    authDomain: 'todolistteam-de27a.firebaseapp.com',
    storageBucket: 'todolistteam-de27a.appspot.com',
    measurementId: 'G-F6FK8J04ME',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtSb88OtaBjQl7tCZtuYjpDz2a_2vast8',
    appId: '1:547111368215:android:d5000b70bc744a70aa4e52',
    messagingSenderId: '547111368215',
    projectId: 'todolistteam-de27a',
    storageBucket: 'todolistteam-de27a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCO9QICxGkAp8MuXPrsjvFOFME4kzm_r-4',
    appId: '1:547111368215:ios:3715d744aa36616baa4e52',
    messagingSenderId: '547111368215',
    projectId: 'todolistteam-de27a',
    storageBucket: 'todolistteam-de27a.appspot.com',
    iosBundleId: 'com.example.todolistTeam',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCO9QICxGkAp8MuXPrsjvFOFME4kzm_r-4',
    appId: '1:547111368215:ios:3715d744aa36616baa4e52',
    messagingSenderId: '547111368215',
    projectId: 'todolistteam-de27a',
    storageBucket: 'todolistteam-de27a.appspot.com',
    iosBundleId: 'com.example.todolistTeam',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC6_CqX3afu4gFW8ULs9h-_3kvsmuHXjmA',
    appId: '1:547111368215:web:469af5da38bf1155aa4e52',
    messagingSenderId: '547111368215',
    projectId: 'todolistteam-de27a',
    authDomain: 'todolistteam-de27a.firebaseapp.com',
    storageBucket: 'todolistteam-de27a.appspot.com',
    measurementId: 'G-GQ6LVTT60W',
  );
}

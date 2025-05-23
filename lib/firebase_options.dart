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
    apiKey: 'AIzaSyBB7LWooGyqf81Duk3cWcoNmIqiz5wh_Lo',
    appId: '1:658144342769:web:3ba3300c5d64a8e0646f50',
    messagingSenderId: '658144342769',
    projectId: 'lunari-project',
    authDomain: 'lunari-project.firebaseapp.com',
    storageBucket: 'lunari-project.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmxxLcyJSKeatMg6-x5GoHiQ3LxFqvFnY',
    appId: '1:658144342769:android:ffd675c91e4df99e646f50',
    messagingSenderId: '658144342769',
    projectId: 'lunari-project',
    storageBucket: 'lunari-project.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBK6oP5mZBurcByz0qMmaLtJREVzNGwx_w',
    appId: '1:658144342769:ios:23ef118fd24b5de4646f50',
    messagingSenderId: '658144342769',
    projectId: 'lunari-project',
    storageBucket: 'lunari-project.firebasestorage.app',
    iosBundleId: 'com.example.lunari',
  );

}
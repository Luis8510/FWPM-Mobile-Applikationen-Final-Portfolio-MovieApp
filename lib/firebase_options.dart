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
    apiKey: 'AIzaSyDTcZJFVWfbgNBrNqxpKJvy2FLuAgetE3Y',
    appId: '1:395677449090:web:4ab85b35e6b7482472ed9b',
    messagingSenderId: '395677449090',
    projectId: 'movieapp-66cc2',
    authDomain: 'movieapp-66cc2.firebaseapp.com',
    storageBucket: 'movieapp-66cc2.firebasestorage.app',
    measurementId: 'G-VYGN2PD357',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQ9eYsJtCABUQECA6Y_pWSNyg5VG48rBc',
    appId: '1:395677449090:android:565d3b4755dd062372ed9b',
    messagingSenderId: '395677449090',
    projectId: 'movieapp-66cc2',
    storageBucket: 'movieapp-66cc2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHG8vtTLrcuIhBSCWcA2iTXLv9jJTnSOI',
    appId: '1:395677449090:ios:b7fd1de57fa3e59b72ed9b',
    messagingSenderId: '395677449090',
    projectId: 'movieapp-66cc2',
    storageBucket: 'movieapp-66cc2.firebasestorage.app',
    iosBundleId: 'com.example.finalportfolio',
  );
}

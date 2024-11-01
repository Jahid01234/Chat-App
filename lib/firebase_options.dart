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
    apiKey: 'AIzaSyC1pqfmA63ksPmsZMvCSkxdcrwGv28rzuE',
    appId: '1:893669676344:web:f29a68cb23491cdc6c1dcd',
    messagingSenderId: '893669676344',
    projectId: 'chat-app-a1129',
    authDomain: 'chat-app-a1129.firebaseapp.com',
    storageBucket: 'chat-app-a1129.appspot.com',
    measurementId: 'G-1GFG1XZ25M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtU0kijJmU0ii4SGkVxXn9eLaOPPLftAM',
    appId: '1:893669676344:android:fb28c9b8c83b59796c1dcd',
    messagingSenderId: '893669676344',
    projectId: 'chat-app-a1129',
    storageBucket: 'chat-app-a1129.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcqaLd-jtAsvucWe1I9Go_Tmm1EDF1WdM',
    appId: '1:893669676344:ios:8b2be39fa0f124f56c1dcd',
    messagingSenderId: '893669676344',
    projectId: 'chat-app-a1129',
    storageBucket: 'chat-app-a1129.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC1pqfmA63ksPmsZMvCSkxdcrwGv28rzuE',
    appId: '1:893669676344:web:d4d5e3c3a11006366c1dcd',
    messagingSenderId: '893669676344',
    projectId: 'chat-app-a1129',
    authDomain: 'chat-app-a1129.firebaseapp.com',
    storageBucket: 'chat-app-a1129.appspot.com',
    measurementId: 'G-9NZDFKYLJB',
  );
}

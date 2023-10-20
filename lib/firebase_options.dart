// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyDkZP0ydn6tLHENh-lRX2bODXG8gylgJCY',
    appId: '1:610851251351:web:240223d72e4993ca7675d2',
    messagingSenderId: '610851251351',
    projectId: 'login-firebase-ae503',
    authDomain: 'login-firebase-ae503.firebaseapp.com',
    storageBucket: 'login-firebase-ae503.appspot.com',
    measurementId: 'G-90LZWS18HM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0fRJIQAhbLsMPQeWCb96G6zVtyWbb1EI',
    appId: '1:610851251351:android:686138400ef5fa747675d2',
    messagingSenderId: '610851251351',
    projectId: 'login-firebase-ae503',
    storageBucket: 'login-firebase-ae503.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJQ_N0cFoetZ5dyZHTif-zjY6Wkz5jjXw',
    appId: '1:610851251351:ios:af64981ebf3db4337675d2',
    messagingSenderId: '610851251351',
    projectId: 'login-firebase-ae503',
    storageBucket: 'login-firebase-ae503.appspot.com',
    androidClientId: '610851251351-86gg2cquimb3br88ap1508clhhv4ovfa.apps.googleusercontent.com',
    iosBundleId: 'com.ogtechdevs.pushNotifications',
  );
}

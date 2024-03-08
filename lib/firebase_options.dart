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
    apiKey: 'AIzaSyBza8S8x-LDqR3KeKoy4_s-YjZ8un7liE0',
    appId: '1:65223931444:web:a6f1c7dda38aad45b6fc61',
    messagingSenderId: '65223931444',
    projectId: 'paginadetareasfime',
    authDomain: 'paginadetareasfime.firebaseapp.com',
    storageBucket: 'paginadetareasfime.appspot.com',
    measurementId: 'G-L52NH3TJ1J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4kQ6ijCfrdudbWiIHs_w_Np3NXkL5KZU',
    appId: '1:65223931444:android:8782beaf418acb1bb6fc61',
    messagingSenderId: '65223931444',
    projectId: 'paginadetareasfime',
    storageBucket: 'paginadetareasfime.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBLaTnVXy_8OhTORhfcIBT549sWUdD_f54',
    appId: '1:65223931444:ios:444e23923c68f321b6fc61',
    messagingSenderId: '65223931444',
    projectId: 'paginadetareasfime',
    storageBucket: 'paginadetareasfime.appspot.com',
    iosClientId: '65223931444-0r5q0hjnf7gm38rqjm03dgap85j4ke1n.apps.googleusercontent.com',
    iosBundleId: 'com.example.appmovilesproyecto17',
  );
}

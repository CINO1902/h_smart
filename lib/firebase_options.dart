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
        return macos;
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
    apiKey: 'AIzaSyBLqba3D_juCUIrfXpLwfB11ArrkhmjeTA',
    appId: '1:323302255274:web:fdae242404dce5f158fed3',
    messagingSenderId: '323302255274',
    projectId: 'hsmart-bb867',
    authDomain: 'hsmart-bb867.firebaseapp.com',
    storageBucket: 'hsmart-bb867.appspot.com',
    measurementId: 'G-HEJV1J6GEZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLiFynk3R1yFWbE0gLPoSr3USV1v9nJ2o',
    appId: '1:323302255274:android:4f73394ae8c3a57858fed3',
    messagingSenderId: '323302255274',
    projectId: 'hsmart-bb867',
    storageBucket: 'hsmart-bb867.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDis5U0fHGjoi5AhcpfA8MdD85PnuWPnJs',
    appId: '1:323302255274:ios:ccd2601d23cf3f1458fed3',
    messagingSenderId: '323302255274',
    projectId: 'hsmart-bb867',
    storageBucket: 'hsmart-bb867.appspot.com',
    iosBundleId: 'com.example.hSmart',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDis5U0fHGjoi5AhcpfA8MdD85PnuWPnJs',
    appId: '1:323302255274:ios:f166437f06020dec58fed3',
    messagingSenderId: '323302255274',
    projectId: 'hsmart-bb867',
    storageBucket: 'hsmart-bb867.appspot.com',
    iosBundleId: 'com.example.hSmart.RunnerTests',
  );
}

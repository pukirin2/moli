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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAha9A22KeDdRcrpY8SDbrdPJGHWBkVJT8',
    appId: '1:928021752473:android:655f21ce80b3ac7265a608',
    messagingSenderId: '928021752473',
    projectId: 'moli-sport',
    storageBucket: 'moli-sport.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXgTbvcjfGA6SpqyCQ9O9PK4vGBib0vSg',
    appId: '1:928021752473:ios:070bcc605f39703e65a608',
    messagingSenderId: '928021752473',
    projectId: 'moli-sport',
    storageBucket: 'moli-sport.appspot.com',
    androidClientId: '928021752473-74pvpg7l5osrb45rmq8dnv2ok25vhe76.apps.googleusercontent.com',
    iosClientId: '928021752473-uagd4n51uujuv4coe4t0a0c3rmfch2ub.apps.googleusercontent.com',
    iosBundleId: 'com.mlt.molisport',
  );
}

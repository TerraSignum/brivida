// Generated file with firebase project configuration
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBc7BIdQT_5NzWlMeaNf9ZkhMgdIGTPARs',
    appId: '1:472055249646:android:0590c7a3c99100985e91ff',
    messagingSenderId: '472055249646',
    projectId: 'brivida-7d98d',
    storageBucket: 'brivida-7d98d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAA6dJMKdLL-9Dh2poai-2WuIZn8h_xvTE',
    appId: '1:472055249646:ios:0f7539e5b34818045e91ff',
    messagingSenderId: '472055249646',
    projectId: 'brivida-7d98d',
    storageBucket: 'brivida-7d98d.firebasestorage.app',
    iosBundleId: 'com.elyra.brivida',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCONbU9eWZBMulWQAI0VFZ0AZjqUoIJ_E0',
    appId: '1:472055249646:web:bab5aa391fe0bb0b5e91ff',
    messagingSenderId: '472055249646',
    projectId: 'brivida-7d98d',
    authDomain: 'brivida-7d98d.firebaseapp.com',
    storageBucket: 'brivida-7d98d.firebasestorage.app',
    measurementId: 'G-XJ7DFB1WHN',
  );

}
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'ISI_API_KEY',
    appId: 'ISI_APP_ID',
    messagingSenderId: 'ISI_SENDER_ID',
    projectId: 'praktikum3-7be3a',
    authDomain: 'praktikum3-7be3a.firebaseapp.com',
    storageBucket: 'praktikum3-7be3a.firebasestorage.app',
  );

  // Android/iOS: sementara pakai konfigurasi web yang sama agar tidak error.
  // Kalau nanti mau jalan di Android, buat app Android di Firebase dan isi sendiri.
  static const FirebaseOptions android = web;
  static const FirebaseOptions ios = web;
}
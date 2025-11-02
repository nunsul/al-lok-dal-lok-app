import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:math_demo/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'YOUR_WEB_API_KEY',                 // 예: AIzaSy...
          appId: 'YOUR_WEB_APP_ID',                   // 예: 1:719019166826:web:xxxxxxxx
          messagingSenderId: '719019166826',          // 콘솔 값
          projectId: 'reroll-a2a74',                  // 콘솔 값
          authDomain: 'reroll-a2a74.firebaseapp.com', // 콘솔 값
          storageBucket: 'reroll-a2a74.appspot.com',  // 콘솔 값
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  }

  runApp(const MathRunApp());
}

class MathRunApp extends StatelessWidget {
  const MathRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash_screen(),
    );
  }
}

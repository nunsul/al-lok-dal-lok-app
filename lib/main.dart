import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:math_demo/login/Main_Login_Screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MathRunApp());
}

class MathRunApp extends StatelessWidget {
  const MathRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Main_Login_Screen(),
    );
  }
}

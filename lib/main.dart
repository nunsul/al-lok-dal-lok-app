import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:math_demo/login/Main_Login_Screen.dart';
import 'package:math_demo/screen/Main_back_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MathRunApp());
}

class MathRunApp extends StatefulWidget {
  const MathRunApp({super.key});
  @override
  State<MathRunApp> createState() => _MathRunAppState();
}
class _MathRunAppState extends State<MathRunApp> {
  String? user;
  @override
  void initState(){
    super.initState();
    _loadMe();
  }
  Future<void> _loadMe() async{
    final db = FirebaseAuth.instance;
    user = db.currentUser?.uid;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (user==null) ? Main_Login_Screen() : MainBackScreen(),
    );
  }
}

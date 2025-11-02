import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_demo/login/main_login.dart';
import '../widget/widget_small.dart';
import 'main_screen.dart';

class Splash_screen extends StatefulWidget{
  const Splash_screen({super.key});
  @override
  State<Splash_screen> createState()=>_splash_screenState();
}
class _splash_screenState extends State<Splash_screen>{
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 2), ()async{
      if(!mounted) return;
    final userCheck = FirebaseAuth.instance.currentUser;
    if(userCheck==null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>main_login()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>main_screen()));
    }
    }
    );
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Text("mathRun",style: TextStyle(fontSize: 40,color: Colors.white),),
    ),
  );
  }
}
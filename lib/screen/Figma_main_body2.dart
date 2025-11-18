import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_demo/login/sign_up.dart';

class Figma_main_body2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(padding: EdgeInsets.only(top: 120,left: 15,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/image2/main2.png',width: 300,fit: BoxFit.cover,),
          SizedBox(height: 25,),
          Text('  세상을 읽는 법을 배우는 AI 문해력 코치',style: TextStyle(color: Color(0xFF6B7583),),),
          SizedBox(height: 70,),
          Row(
            children: [
              SizedBox(width: 10,),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Sign_up()));
              },style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5192FF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal:130,vertical:15),
              ), child: Text('시작하기'))
            ],
          )
          ]
      ),)
    );
  }
}
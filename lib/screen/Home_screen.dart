import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_demo/Game/game_screen.dart';

class Home_screen extends StatefulWidget {
  const Home_screen({super.key});
  @override
  State<Home_screen> createState()=> _Home_screenState();
}
class _Home_screenState extends State<Home_screen>{
  String? name;
  @override
  void initState(){
    super.initState();
    _loadUserData();
  }
  Future<void> _loadUserData() async{
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    final db = FirebaseFirestore.instance;
    final userInf = await db.collection('mr_user').doc(userUid).get();
    setState(() {
      name = (userInf.data()??{})['name'];
    });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name님 안녕하세요'),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.settings))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$name님',style: GoogleFonts.jua(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),),
              SizedBox(height: 30,),
              Text('오늘 하루도🎉',
                style: GoogleFonts.jua(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 2,),
              Text('즐거운 하루 되세요!',style: GoogleFonts.jua(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>GameScreen()));
                  }, child: Text('게임')),
                  ElevatedButton(onPressed: (){

                  }, child: Text('학습')),
                  ElevatedButton(onPressed: (){

                  }, child: Text('AI')),
                ],
              ),
              SizedBox(height: 30,),
              Text('''차후에
추가될
내용이
있을까요?
없으면 배치를 가운데로 하겠습니담              
               ''')
    ],
          )
      ),
    )
    );
  }
}
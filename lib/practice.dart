import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_demo/screen/main_screen.dart';

import 'model/model_firebase.dart';

class practice extends StatefulWidget{
  const practice({super.key});
  @override
  State<practice> createState() => _practiceState();
}
class _practiceState extends State<practice> {
  bool _obscure = true;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _phone = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFBC00),
      body: SafeArea(
      child: SingleChildScrollView(
        child:Center(
          child: Column(
            children: [
              Image.asset('assets/images/login_parts/parts/al_lok_dal_lok.png',width: 200,height: 200,),
              Container(
                width: double.infinity,
                height: 475,
                color: Colors.white,
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("회원가입",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text("이름 name",style: TextStyle(fontWeight: FontWeight.bold),),
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Text('핸드폰 phone',style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                    SizedBox(height: 5,),
                    Text('아이디 ID',style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text('비밀번호 Password',style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _password,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    ElevatedButton(onPressed: () async{
                      final name = _name.text.trim();
                      final email = _email.text.trim();
                      final password = _password.text.trim();
                      final phone = _phone.text.trim();
                      final timestamp = DateTime.now();
                      if (name.isEmpty || email.isEmpty || password.isEmpty ||
                           phone.isEmpty ) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('모든 칸을 채워주세요!')));
                        return;
                      }
                      if(!await _phoneCheck(phone)){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이미 존재하는 전화번호입니다!.')),
                        );
                        return;
                      }
                      if (!_isValidEmail(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이메일 형식이 올바르지 않습니다.')),
                        );
                        return;
                      }
                      if (password.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('비밀번호는 6자 이상이어야 합니다.')),
                        );
                        return;
                      }
                      if (phone.length != 11) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('전화번호는 숫자 11자리여야 합니다.')),
                        );
                        return;
                      }
                      try {
                        final cred = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: email, password: password);
                        final users = mr_user(name: name,
                            timestamp: timestamp,
                            phone: phone,
                           );
                        final userUid = cred.user!.uid;
                        final db = FirebaseFirestore.instance;
                        await db.collection('mr_user').doc(userUid).set(
                            users.toJson());
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('회원가입 성공')));
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => main_screen()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('이미 사용 중인 이메일입니다.')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('오류 발생')),);
                        }
                      }
                    },style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 135,vertical: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ), child: Text('완료',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),))
          ],
          ),
              )
            ],
          ),
        )
      ),
      )
    );
  }
}
Future<bool> _phoneCheck(String phone)async{
  final db = FirebaseFirestore.instance.collection('mr_user');
  final check = await db.where('phone',isEqualTo: phone).limit(1).get();
  return check.docs.isEmpty;
}
bool _isValidEmail(String email) {
  final re = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  return re.hasMatch(email);
}
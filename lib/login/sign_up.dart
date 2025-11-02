import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_demo/model/model_firebase.dart';
import 'package:math_demo/screen/main_screen.dart';
import 'package:math_demo/widget/widget_small.dart';
import 'package:flutter/services.dart';

class Sign_up extends StatefulWidget {
  @override
  State<Sign_up> createState() => _main_loginState();
}
class _main_loginState extends State<Sign_up> {
  TextEditingController _nickname = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _phone = TextEditingController();

  @override
  void dispose() {
    _nickname.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _age.dispose();
    _phone.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('회원정보'), centerTitle: true,),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            SizedBox(height: 40,),
            _input('이름', _name),
            SizedBox(height: 10,),
            _input('닉네임', _nickname),
            SizedBox(height: 10,),
            _input('아이디(이메일)', _email, type: TextInputType.emailAddress),
            SizedBox(height: 10),
            _input('비밀번호', _password, obscure: true),
            SizedBox(height: 10),
            _input('나이', _age,
              type: TextInputType.number,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
            SizedBox(height: 10),
            _input('전화번호', _phone,
              type: TextInputType.phone,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            SizedBox(height: 45),
            ElevatedButton(
                onPressed: ()async {
                  final name = _name.text.trim();
                  final nickname = _nickname.text.trim();
                  final email = _email.text.trim();
                  final password = _password.text.trim();
                  final age = _age.text.trim();
                  final phone = _phone.text.trim();
                  final timestamp = DateTime.now();
                  if (name.isEmpty || email.isEmpty || password.isEmpty ||
                      age.isEmpty || phone.isEmpty || nickname.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('모든 칸을 채워주세요!')));
                    return;
                  }
                  final lowerNickname = nickname.toLowerCase();
                  if(!await _nicknameCheck(lowerNickname)){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이미 존재하는 닉네임입니다!.')),
                    );
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
                        age: age,
                        nickname: nickname,
                        nicknameLowercase: lowerNickname);
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
                }, child: Text('시작하기!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
            )
          ],
        )
    );
  }
}

Future<bool> _nicknameCheck(String lowerNickname)async{
  final db = FirebaseFirestore.instance.collection('mr_user');
  final check = await db.where('nicknameLowercase',isEqualTo: lowerNickname).limit(1).get();
  return check.docs.isEmpty;
}
Future<bool> _phoneCheck(String phone)async{
  final db = FirebaseFirestore.instance.collection('mr_user');
  final check = await db.where('phone',isEqualTo: phone).limit(1).get();
  return check.docs.isEmpty;
}
Widget _input(
    String label,
    TextEditingController controller, {
      bool obscure = false,
      TextInputType? type,
      List<TextInputFormatter>? formatters,
    }) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    keyboardType: type,
    inputFormatters: formatters,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: label,
    ),
  );
}
bool _isValidEmail(String email) {
  final re = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  return re.hasMatch(email);
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_demo/login/sign_up.dart';
import 'package:math_demo/model/model_firebase.dart';
import 'package:math_demo/screen/main_screen.dart';
import 'package:math_demo/widget/widget_small.dart';
import 'package:flutter/services.dart';

import '../screen/Main_back_screen.dart';

class main_login extends StatefulWidget {
  @override
  State<main_login> createState() => _main_loginState();
}
class _main_loginState extends State<main_login> {
  bool _obscure = true;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SafeArea(
          child: SingleChildScrollView(
              child:Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/login_parts/parts/al_lok_dal_lok.png',width: 210,height: 210,),
                    Container(
                      width: double.infinity,
                      height: 450,
                      color: Colors.white,
                      padding: EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("로그인",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                          SizedBox(height: 15,),
                          Text("아이디 ID",style: TextStyle(fontWeight: FontWeight.bold)),
                          TextField(
                            controller: _email,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Text('비밀번호 password',style: TextStyle(fontWeight: FontWeight.bold)),
                          TextField(
                            controller: _password,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          ElevatedButton(onPressed: () async{
                            final email = _email.text.trim();
                            final password = _password.text.trim();
                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('모든 칸을 채워주세요!')));
                            }
                            try {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: email.trim().toLowerCase(),
                                password: password,
                              );
                              if (!mounted) return;
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>MainBackScreen()), (r)=>false);
                            } on FirebaseAuthException catch (e) {
                              // 디버깅용: 실제 코드 확인
                              debugPrint('Auth error → code: ${e.code}, message: ${e.message}');

                              final msg = switch (e.code) {
                                'invalid-credential'   => '이메일 또는 비밀번호가 올바르지 않습니다.',
                                'wrong-password'       => '비밀번호가 올바르지 않습니다.',
                                'user-not-found'       => '가입된 이메일이 없습니다.',
                                'invalid-email'        => '이메일 형식이 올바르지 않습니다.',
                                'user-disabled'        => '비활성화된 계정입니다.',
                                'too-many-requests'    => '요청이 많아 잠시 후 다시 시도해 주세요.',
                                'operation-not-allowed'=> '이메일/비밀번호 로그인이 비활성화되어 있습니다(콘솔 확인).',
                                'network-request-failed'=> '네트워크 오류입니다. 연결을 확인하세요.',
                                _ => '로그인 실패: ${e.code}',
                              };

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                            } catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('알 수 없는 오류가 발생했어요.')),
                              );
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

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

class main_login extends StatefulWidget {
  @override
  State<main_login> createState() => _main_loginState();
}
class _main_loginState extends State<main_login> {
  bool _obscure = true;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        showNotice(context, '''
   🎉 안녕하세요! 매쓰런(MathRun)입니다. 
   공부도 게임처럼!
   여러분의 학습을 재미있게 만들어주는
   매쓰런에 오신 걸 환영해요 😎

   처음 앱을 사용하시기 전에
   간단한 회원정보를 입력하고 로그인하면
   모든 기능을 자유롭게 이용할 수 있어요💡

   ✏️ 로그인 화면에서
   회원정보를 적은 뒤
  ‘시작하기’ 버튼을 눌러주세요!

   이제 우리 함께
   수학 실력을 “런~🏁” 시켜볼까요?

   감사합니다 💖
   오늘도 즐거운 수학 러닝 되세요!
   '''
        )
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Text('ID:',style: TextStyle(fontSize: 20),),
                    SizedBox(width: 30,),
                    Expanded(child:TextField(
                      controller: _email,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                      ),
                    ),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text('PW:',style: TextStyle(fontSize: 20),),
                    SizedBox(width: 20,),
                    Expanded(child:  TextField(
                      controller: _password,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                    ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => main_screen()));
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
                      }, child: Text('로그인')),
                      SizedBox(width: 10,),
                      ElevatedButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Sign_up()));
                      }, child: Text("회원가입"))
                    ]
                )
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_demo/screen/main_screen.dart';

import '../model/model_firebase.dart';
import '../screen/Main_back_screen.dart';

class Sign_up extends StatefulWidget{
  const Sign_up({super.key});
  @override
  State<Sign_up> createState() => _practiceState();
}

class _practiceState extends State<Sign_up> {
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
      backgroundColor: const Color(0xFFFFBC00),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/login_parts/parts/al_lok_dal_lok.png',
                  width: 200,
                  height: 200,
                ),
                Container(
                  width: double.infinity,
                  height: 475,
                  color: Colors.white,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "회원가입",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text("이름 name", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: _name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 5),
                      const Text('핸드폰 phone', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: _phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 5),
                      const Text('아이디 ID', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 5),
                      const Text('비밀번호 Password', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: _password,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          final name = _name.text.trim();
                          final email = _email.text.trim();
                          final password = _password.text.trim();
                          final phone = _phone.text.trim();
                          final timestamp = DateTime.now();

                          if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('모든 칸을 채워주세요!')),
                            );
                            return;
                          }
                          final phoneOk = RegExp(r'^\d{11}$').hasMatch(phone);
                          if (!phoneOk) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('전화번호는 숫자 11자리여야 합니다.')),
                            );
                            return;
                          }
                          if (password.length < 6) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('비밀번호는 6자 이상이어야 합니다.')),
                            );
                            return;
                          }

                          UserCredential? cred;
                          try {
                            cred = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(email: email, password: password);
                            final available = await _phoneCheck(phone);
                            if (!available) {
                              try { await cred.user?.delete(); } catch (_) {}
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('이미 존재하는 전화번호입니다!.')),
                              );
                              return;
                            }
                            final users = mr_user(
                              name: name,
                              timestamp: timestamp,
                              phone: phone,
                            );
                            final data = users.toJson();
                            data['email'] = email;

                            await FirebaseFirestore.instance
                                .collection('mr_user')
                                .doc(cred.user!.uid)
                                .set(data);

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('회원가입 성공')),
                            );
                            if (!mounted) return;
                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>MainBackScreen()), (r)=>false);

                          } on FirebaseAuthException catch (e) {
                            if (!mounted) return;
                            if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('이미 사용 중인 이메일입니다.')),
                              );
                            } else if (e.code == 'operation-not-allowed') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('이메일/비밀번호 로그인이 비활성화되어 있습니다(콘솔 설정 확인).')),
                              );
                            } else if (e.code == 'invalid-email') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('유효하지 않은 이메일입니다.')),
                              );
                            } else if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('비밀번호가 너무 약합니다.')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Auth 오류: ${e.code}')),
                              );
                            }
                          } on FirebaseException catch (e) {
                            // Firestore 쓰기 실패 시 Auth 롤백(고아 계정 방지)
                            try { await cred?.user?.delete(); } catch (_) {}
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('데이터 저장 실패: ${e.code}')),
                            );
                          } catch (_) {
                            try { await cred?.user?.delete(); } catch (_) {}
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('오류 발생')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          '완료',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Future<bool> _phoneCheck(String phone) async {
  final db = FirebaseFirestore.instance.collection('mr_user');
  final check = await db.where('phone', isEqualTo: phone).limit(1).get();
  return check.docs.isEmpty;
}

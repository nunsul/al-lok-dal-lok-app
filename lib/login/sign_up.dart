import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/model_firebase.dart';
import '../screen/2Main_back_screen.dart';

class Sign_up extends StatefulWidget{
  const Sign_up({super.key});
  @override
  State<Sign_up> createState() => _practiceState();
}

class _practiceState extends State<Sign_up> {
  bool _obscure = true;
  bool _agreePrivacy = false;

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

  Widget _socialCircle(String label) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30,left: 15,right: 15,bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/image2/signup1.png',
                width: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView( child:
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF4F4F4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "회원가입",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "이름 Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _name,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '핸드폰 번호 PhoneNumber',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _phone,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '아이디 ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '비밀번호 Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _password,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _agreePrivacy,
                            onChanged: (value) {
                              setState(() {
                                _agreePrivacy = value ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: Colors.black,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '개인정보 동의',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () {
                              // TODO: 약관보기
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              '약관보기',
                              style: TextStyle(
                                fontSize: 11,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // TODO: 구글 로그인
                            },
                            child: _socialCircle('G'),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // TODO: 카카오 로그인
                            },
                            child: _socialCircle('톡'),
                          ),
                        ],
                      ),
                       SizedBox(height: 10,),
                       ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (!_agreePrivacy) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('개인정보 처리방침에 동의해 주세요.')),
                              );
                              return;
                            }

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
                                email: email,
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
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_)=>Main_back_screen()),
                                    (r)=>false,
                              );

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
                            backgroundColor: const Color(0xFF5192FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            '완료',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              )
            ],
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

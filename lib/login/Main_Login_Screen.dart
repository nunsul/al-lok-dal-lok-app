import 'package:flutter/material.dart';
import 'package:math_demo/login/sign_up.dart';
import '../practice.dart';
import '../screen/Figma_main_body_screen.dart';
import 'main_login.dart';

class Main_Login_Screen extends StatelessWidget {
  const Main_Login_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFBC00),
      body: Stack(
        children: [
          Figma_main_body_screen(
            FigmaW: 414,
            FigmaH: 896,
            cover: true,
            checkFrame: false,
            parts: [
              // ▼▼▼ 애니메이션 옵션만 추가됨(fromX/fromY/delay/dur/curve) ▼▼▼
              location_login(
                'assets/images/login_parts/parts/love.png',
                x: -45, y: 690, w: 258.02,
                fromX: -240, fromY: 120,                         // ★ NEW
                delay: const Duration(milliseconds: 100),        // ★ NEW
              ),
              location_login(
                'assets/images/login_parts/parts/palette.png',
                x: 198, y: 658, w: 258,
                fromY: 220,                                      // ★ NEW
                delay: const Duration(milliseconds: 150),        // ★ NEW
              ),
              location_login(
                'assets/images/login_parts/parts/star.png',
                x: 180, y: -65, w: 320,
                fromY: -260,                                     // ★ NEW
                delay: Duration.zero,                            // ★ NEW
              ),
              location_login(
                'assets/images/login_parts/parts/math.png',
                x: 303, y: 138, w: 148.89,
                fromX: 220,                                      // ★ NEW
                delay: const Duration(milliseconds: 250),        // ★ NEW
              ),
              location_login(
                'assets/images/login_parts/parts/watermelon.png',
                x: -30.15, y: 227.13, w: 105,
                fromX: -180,                                     // ★ NEW
                delay: const Duration(milliseconds: 200),        // ★ NEW
              ),
              location_login(
                'assets/images/login_parts/parts/wizard.png',
                x: -110, y: -80, w: 450,
                fromX: -260, fromY: -200,                        // ★ NEW
                delay: const Duration(milliseconds: 50),         // ★ NEW
                dur: const Duration(milliseconds: 700),          // ★ NEW
                curve: Curves.easeOutBack,                       // ★ NEW
              ),
              location_login(
                'assets/images/login_parts/parts/al_lok_dal_lok.png',
                x: 66, y: 325, w: 288,
                fromY: 140,                                      // ★ NEW
                delay: const Duration(milliseconds: 300),        // ★ NEW
              ),
              // ▲▲▲ 여기까지만 추가/수정. 나머지는 동일 ▲▲▲
            ],
          ),
          Align(
            alignment: const Alignment(0, 0.52),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  """오늘도 나만의 Ai알고리즘으로
맞춤형 수학 공부를 해볼까요?""",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => main_login()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('로그인'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Sign_up()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('회원가입'),
                ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

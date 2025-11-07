import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Mypage/My_page.dart';
import '../chat/Chat_main.dart';

class MainBackScreen extends StatefulWidget {
  const MainBackScreen({super.key});
  @override
  State<MainBackScreen> createState() => _MainShellState();
}

class _MainShellState extends State<MainBackScreen> {
  int _index = 0;
  bool _centerSelected = false;

  static const int _kCenterPage = 4; // 학사모 전용 페이지 인덱스
  final List<Widget> _pages = const [
    _HomePage(),
    Chat_main(),
    _GamePage(),
     My_page(),
    _CenterFabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final int visibleIndex = _centerSelected ? _kCenterPage : _index;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 15),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          extendBody: false,

          body: IndexedStack(index: visibleIndex, children: _pages),

          floatingActionButton: SizedBox(
            height: 90,
            width: 90,
            child: FloatingActionButton(
              heroTag: 'center-fab',
              shape: const CircleBorder(),
              backgroundColor:
              _centerSelected ? const Color(0xFF2F6BFF) : const Color(0xFFFFBC00),
              elevation: 8,
              onPressed: () {
                setState(() {
                  _centerSelected = true;
                });
              },
              child: const Icon(Icons.school_outlined, size: 26, color: Colors.white),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: Padding(
            padding: EdgeInsets.zero,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(blurRadius: 20, offset: Offset(0, 10), color: Color(0x1A000000)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BottomAppBar(
                  color: Colors.white,
                  elevation: 0,
                  shape: const CircularNotchedRectangle(),
                  notchMargin: 2,
                  child: SizedBox(
                    height: 72,
                    child: Row(
                      children: [
                        _NavItem(
                          icon: Icons.home_outlined,
                          selected: !_centerSelected && _index == 0,
                          onTap: () {
                            setState(() {
                              _index = 0;
                              _centerSelected = false;
                            });
                          },
                        ),
                        _NavItem(
                          icon: CupertinoIcons.chat_bubble,
                          selected: !_centerSelected && _index == 1,
                          onTap: () {
                            setState(() {
                              _index = 1;
                              _centerSelected = false;
                            });
                          },
                        ),
                        const Spacer(), // FAB 자리
                        _NavItem(
                          icon: Icons.sports_esports_outlined,
                          selected: !_centerSelected && _index == 2,
                          onTap: () {
                            setState(() {
                              _index = 2;
                              _centerSelected = false;
                            });
                          },
                        ),
                        _NavItem(
                          icon: Icons.person_outline,
                          selected: !_centerSelected && _index == 3,
                          onTap: () {
                            setState(() {
                              _index = 3;
                              _centerSelected = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF2F6BFF) : const Color(0xFFB8C0CC);
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        highlightShape: BoxShape.circle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Icon(icon, color: color, size: 26),
        ),
      ),
    );
  }
}

/// 예시 페이지들이에요
class _HomePage extends StatelessWidget {
  const _HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('홈페이지'),centerTitle: true,),);
  }
}

class _GamePage extends StatelessWidget {
  const _GamePage();
  @override
  Widget build(BuildContext context) {
    return Align(
     alignment: Alignment.bottomCenter,
     child: Text("dddddddddddd"),
    );
  }
}

class _CenterFabPage extends StatelessWidget {
  const _CenterFabPage();
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(child: Text('센터(학사모) 페이지', style: TextStyle(fontSize: 22))),
    );
  }
}

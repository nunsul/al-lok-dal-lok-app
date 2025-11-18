import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class main_main_screen extends StatelessWidget {
  const main_main_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          leadingWidth: 140,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
              'assets/logo/mainlogo.png',
              fit: BoxFit.contain, // 주어진 영역 안에서 꽉 차게
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(140),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF5192FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '김영훈님 안녕하세요!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '함께 뉴스를 읽고 요약해 보실까요?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 탭바
                TabBar(
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 6),
                        child: Text(
                          '홈',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 6),
                        child: Text(
                          '정치',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 6),
                        child: Text(
                          '경제',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 6),
                        child: Text(
                          '사회',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 6),
                        child: Text(
                          '생활/문화',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 6),
                        child: Text(
                          'IT/ 과학',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        body: const TabBarView(
          children: [
            Center(child: Text('홈')),
            Center(child: Text('정치')),
            Center(child: Text('경제')),
            Center(child: Text('사회')),
            Center(child: Text('생활')),
            Center(child: Text('IT')),
          ],
        ),
      ),
    );
  }
}

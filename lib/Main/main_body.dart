import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class main_body extends StatefulWidget{
  const main_body({super.key});
  @override
  State<main_body> createState()=> _main_bodyState();
}

class _main_bodyState extends State<main_body>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    children: [
                      const Text(
                        '다른 사용자의 뉴스 요약 보기',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'best',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ]
                ),
                const SizedBox(height: 25),
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.yellow,
                ),
                const SizedBox(height: 10),
                const Text(
                  '뉴스 확인하기',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),

                // 여기 Row 안만 추가
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.today_outlined, size: 28),
                            Text(
                              '오늘의\n추천 뉴스',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.recommend_outlined, size: 28),
                            Text(
                              '내 관심사 기반\n추천 뉴스',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

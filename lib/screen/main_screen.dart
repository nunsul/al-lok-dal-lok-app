import 'package:flutter/material.dart';
import 'package:math_demo/Mypage/My_page.dart';
import 'package:math_demo/screen/Home_screen.dart';
import '../chat/Chat_main.dart';

class main_screen extends StatefulWidget {
  const main_screen({super.key});
  @override
  State<main_screen> createState() => _main_screenState();
}
class _main_screenState extends State<main_screen> {
  int selectedIndex = 1;
  final List<Widget> _page = [
    Chat_main(),
    Home_screen(),
    My_page()
  ];
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: _page[selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
      onTap: (i)=>setState(()=>selectedIndex=i),
    currentIndex: selectedIndex,
  selectedItemColor: Colors.black,
  unselectedItemColor: Colors.grey,
  selectedLabelStyle: TextStyle(color: Colors.black),
  unselectedLabelStyle: TextStyle(color: Colors.grey),
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.chat),label: '채팅'),
    BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
  ],
  )
  );
  }
}

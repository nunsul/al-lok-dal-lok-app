
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Main/main_main_screen.dart';

class Main_back_screen extends StatefulWidget {
  const Main_back_screen({super.key});
  @override
  State<Main_back_screen> createState()=> _Main_back_screenState();
}
class _Main_back_screenState extends State<Main_back_screen>{
  int _index = 0;
  final List<Widget> _pages = [
    main_main_screen(),
    Center(child: Text('뉴스확인'),),
    Center(child: Text('메모공유'),),
    Center(child: Text('마이페이지'),)
    ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: _pages[_index],
      bottomNavigationBar: Padding(padding: EdgeInsets.only(bottom: 5),
    child:ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _index,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            color: Colors.black
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            color: Colors.grey
          ),
          onTap: (index){
            setState(() {
              _index = index;
            });
          },
          items: const[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined),label: '뉴스 확인'),
            BottomNavigationBarItem(icon: Icon(Icons.edit_outlined),label: '메모 공유'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline),label: '마이페이지')
          ]
      ),
      ),
      )
    );
  }
}
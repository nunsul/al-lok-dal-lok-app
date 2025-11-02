import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class My_page extends StatefulWidget {
  const My_page({super.key});
  @override
  State<My_page> createState()=> _Chat_mainState();
}
class _Chat_mainState extends State<My_page>{
  String displayName = '';
  String email = '';
  int stat1 = 124; // 점수
  int stat2 = 58;  // 친구
  int stat3 = 12;  // 업적
  @override
  void initState(){
    super.initState();
    _loadMyInf();
  }
  Future<void> _loadMyInf()async{
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    final db = FirebaseFirestore.instance;
    final doc = await db.collection('mr_user').doc(userUid).get();
    if(!mounted) return;
    setState(() {
      displayName = (doc.data()??{})['name'] ?? '';
      email = FirebaseAuth.instance.currentUser!.email.toString() ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                   Text("$displayName 님", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  SizedBox(height: 2,),
                  Text(email, style: const TextStyle(fontSize: 14)),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatTile(value: stat1, label: '점수'),
                        _StatTile(value: stat2, label: '친구'),
                        _StatTile(value: stat3, label: '업적'),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            label: const Text('프로필 편집'),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 5,),
                  const Divider(height: 24),
                    Text('업적', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(height: 10,),
                  const _BadgesSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
//widget
class _StatTile extends StatelessWidget {
  final int value; final String label;
  const _StatTile({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}
class _BadgesSection extends StatelessWidget {
  const _BadgesSection();

  @override
  Widget build(BuildContext context) {
    final badges = [
      (Icons.star, '첫 런 완주'),
      (Icons.school, '연속 학습 7일'),
      (Icons.speed, '스피드러너'),
      (Icons.military_tech, '랭커 달성'),
      (Icons.emoji_events, '일일 퀘스트 10회'),
      (Icons.workspace_premium, '프리미엄 도전자'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 10, runSpacing: 10,
        children: badges.map((b) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFD28C)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(b.$1, color: const Color(0xFFFB8C00), size: 18),
            const SizedBox(width: 8),
            Text(b.$2),
          ]),
        )).toList(),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat_main extends StatefulWidget {
  const Chat_main({super.key});
  @override
  State<Chat_main> createState() => _Chat_mainState();
}

class _Chat_mainState extends State<Chat_main> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardOpen = bottomInset > 0;
    final double bottomPadding = isKeyboardOpen ? bottomInset : 45.0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text("채팅"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.grid_view),
        ),
      ),

      body: Column(
        children: [
          // ===== 메시지 리스트 =====
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('mr_chat')
                  .doc('open_chat')
                  .collection('message')
                  .orderBy('timestamp', descending: true)
                  .limit(30)
                  .snapshots(),
              builder: (context, snaps) {
                if (!snaps.hasData) {
                  // 최초 로딩일 때만 로딩 표시
                  return const Center(child: CircularProgressIndicator());
                }

                final snap = snaps.data!.docs;
                if (snap.isEmpty) {
                  return const Center(
                    child: Text(
                      '''아직 대화가 없습니다!\n처음으로 대화를 보내보세요!''',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final myUid = FirebaseAuth.instance.currentUser!.uid;

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 10),
                  reverse: true,
                  itemCount: snap.length,
                  itemBuilder: (context, index) {
                    final data =
                    snap[index].data() as Map<String, dynamic>;
                    final isMe = data['uid'] == myUid;
                    final msg = data['content'] ?? '';

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: isMe
                              ? Colors.yellow[300]
                              : Colors.grey[200],
                        ),
                        child: Text(msg),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          AnimatedPadding(
            duration: const Duration(milliseconds: 120),
            padding: EdgeInsets.only(
              bottom: (isKeyboardOpen) ? 200 : bottomPadding+5,
            ),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: " 질문을 입력해주세요.",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: _sendMessage,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1.3,
                  ),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _controller.text.trim().isEmpty) return;

    final msg = _controller.text.trim();
    _controller.clear();

    await FirebaseFirestore.instance
        .collection('mr_chat')
        .doc('open_chat')
        .collection('message')
        .add({
      'uid': user.uid,
      'content': msg,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

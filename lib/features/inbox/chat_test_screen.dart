import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatTestScreen extends StatelessWidget {
  final TextEditingController _chatController = TextEditingController();
  final String chatRoomId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ChatTestScreen({
    super.key,
    required this.chatRoomId,
  });

  Future<void> sendMessage(String chatRoomId, bool isMe, String message) async {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'isMe': isMe,
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('timestamp')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 15, left: 100, bottom: 20),
                    child: ListTile(
                      title: Padding(
                          padding: const EdgeInsets.only(left: 200),
                          child: Text(data['message'])),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 200),
                        child: Text(data['isMe'].toString()),
                      ),
                      tileColor: Colors.blue.shade100,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 100, left: 15, bottom: 20),
                    child: ListTile(
                      title: Text(data['message']),
                      subtitle: Text(data['isMe'].toString()),
                      tileColor: Colors.green.shade100,
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _chatController,
                decoration: const InputDecoration(
                  hintText: 'Enter message',
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                sendMessage(chatRoomId, true, _chatController.text);
                _chatController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}

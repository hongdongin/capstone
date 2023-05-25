import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _currentUserId;
  late String _currentUserName;
  List<DocumentSnapshot> _messages = [];

  @override
  void initState() {
    super.initState();

    _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _messages = snapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final userId = message['userId'];
          final userName = message['userName'];
          final messageText = message['message'];

          return Align(
            alignment: userId == _currentUserId
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: userId == _currentUserId ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                '$userName: $messageText',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          );
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter a message',
          ),
          onSubmitted: (message) {
            _firestore.collection('messages').add({
              'userId': _currentUserId,
              'userName': _currentUserName,
              'message': message,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            }).then((doc) {
              print('Message sent');
            });
          },
        ),
      ),
    );
  }
}

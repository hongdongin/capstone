import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class ChatTestScreen extends ConsumerStatefulWidget {
  static const String routeName = "chats";
  static const String routeUrl = "/chats";

  final String chatRoomId;

  const ChatTestScreen({
    super.key,
    required this.chatRoomId,
  });

  @override
  ConsumerState<ChatTestScreen> createState() => _ChatTestScreenState();
}

class _ChatTestScreenState extends ConsumerState<ChatTestScreen> {
  final TextEditingController _chatController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            appBar: AppBar(
              title: const Text('Chat Room'),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chat_rooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Column(
                      crossAxisAlignment: data['isMe'] == true
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        data['isMe'] == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(0),
                                    ),
                                  ),
                                  child: Text(data['message']),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade300,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(0),
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Text(data['message']),
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
                      sendMessage(widget.chatRoomId,
                          data.uid == widget.chatRoomId, _chatController.text);
                      _chatController.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
  }
}

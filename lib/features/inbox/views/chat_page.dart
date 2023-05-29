import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String meetingId;
  const ChatPage({
    super.key,
    required this.meetingId,
  });

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage> {
  final _formKey = GlobalKey<FormState>();
  late String _message;

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
              title: const Text('chat'),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('meetings')
                  .doc(widget.meetingId)
                  .collection('messages')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(document['text']),
                      subtitle: Text(data.bio.toString()),
                      leading: Avatar(
                        uid: data.uid,
                        name: data.bio,
                        avatarSize: Sizes.size24,
                        hasAvatar: data.hasAvatar,
                      ),
                    );
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('메시지 보내기'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('취소'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('보내기'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              // Send the message to Firebase
                              FirebaseFirestore.instance
                                  .collection('meetings')
                                  .doc(widget.meetingId)
                                  .collection('messages')
                                  .add({
                                'text': _message,
                                'timestamp': DateTime.now(),
                              });
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                      content: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: '메시지'),
                              validator: (value) =>
                                  value!.isEmpty ? '메시지를 작성해 주세요.' : null,
                              onSaved: (value) => _message = value!,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
  }
}

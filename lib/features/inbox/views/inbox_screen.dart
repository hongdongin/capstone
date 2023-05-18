import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/mode_config/mode_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/views/chat_test_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final bool isNull = false;
  late final String chatRoomId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _onDmPressed({required String chatRoomId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatTestScreen(
          chatRoomId: chatRoomId,
        ),
      ),
    );
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
              elevation: 1,
              shadowColor: modeConfig.autoMode ? Colors.white : Colors.black,
              title: const Text('Inbox'),
              actions: [
                IconButton(
                  onPressed: () => _onDmPressed(chatRoomId: data.uid),
                  icon: const FaIcon(
                    FontAwesomeIcons.paperPlane,
                    size: Sizes.size20,
                  ),
                )
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: GestureDetector(
                            onTap: () => _onDmPressed(chatRoomId: data['uid']),
                            child: ListTile(
                              title: Text(data['bio'].toString()),
                              tileColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        );
  }
}

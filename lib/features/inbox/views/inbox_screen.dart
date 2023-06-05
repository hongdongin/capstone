import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/mode_config/mode_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/views/chat_page.dart';
import 'package:tiktok_clone/features/meeting/create_meeting_page.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final bool isNull = false;
  late final String chatRoomId;

  void _onDmPressed({required String chatRoomId}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateMeetingPage()),
    );
  }

  void _onChatTap({required String chatRoomId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          meetingId: chatRoomId,
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
              title: const Text('모임'),
              actions: [
                IconButton(
                  onPressed: () => _onDmPressed(chatRoomId: data.uid),
                  icon: const FaIcon(
                    FontAwesomeIcons.plus,
                    size: Sizes.size20,
                  ),
                )
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('meetings').snapshots(),
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
                    return GestureDetector(
                      onTap: () => _onChatTap(chatRoomId: 'chat room'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(document['title']),
                          subtitle: Text(document['description']),
                          tileColor: Colors.green.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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

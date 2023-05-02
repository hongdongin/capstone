import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = "chats";
  static const String routeUrl = "/chats";

  const ChatsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final Duration _duration = const Duration(milliseconds: 500);

  void _addItem() {}

  void _deleteItem(int index) {}

  void _onChatTap(String chatRoomId, String yourUid) {
    context.pushNamed(
      extra: {
        'chatRoomId': chatRoomId,
        'yourUid': yourUid,
      },
      ChatDetailScreen.routeName,
    );
  }

  Widget _makeTile(int index, snapshot) {
    final String myUid = ref.read(authRepo).user!.uid;
    final String chatRoomId = snapshot.data![index]['chatRoomId'];
    String yourUid = "";
    String yourName = "";
    final String personA = snapshot.data![index]['personA'];
    final String personB = snapshot.data![index]['personB'];
    if (personA == myUid) {
      yourUid = personB;
      yourName = snapshot.data![index]['nameOfPersonB'];
    } else {
      yourUid = personA;
      yourName = snapshot.data![index]['nameOfPersonA'];
    }

    final Timestamp time = snapshot.data![index]['createdAt'];
    final lastMessageTime = time.toDate().toString().substring(0, 16);

    return ListTile(
      onTap: () => _onChatTap(chatRoomId, yourUid),
      onLongPress: () => _deleteItem(index),
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F$yourUid?alt=media&",
        ),
        child: Text(
          yourName,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            yourName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            lastMessageTime,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: Text(
        snapshot.data![index]['lastMessage'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.read(authRepo).user!.uid;
    Future<List<Map<String, dynamic>>> chatRoomList =
        ref.read(chatRoomProvider.notifier).getChatRoomModelList(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Direct messages",
        ),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
        centerTitle: true,
        elevation: 1,
      ),
      body: FutureBuilder(
        future: chatRoomList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data);
            return Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: Breakpoints.lg,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size10,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _makeTile(index, snapshot);
                  },
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

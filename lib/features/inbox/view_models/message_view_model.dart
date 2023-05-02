import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repos/message_repo.dart';

class MessagesViewModel extends FamilyAsyncNotifier<void, String> {
  late final MessagesRepo _repo;
  late final String _chatRoomId;

  @override
  FutureOr<void> build(String chatRoomId) {
    _chatRoomId = chatRoomId;
    _repo = ref.read(messagesRepo);
  }

  Future<void> sendMessage(String text, String yourUid) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      _repo.sendMessage(
        message: message,
        chatRoomId: _chatRoomId,
        personA: user.uid,
        personB: yourUid,
      );
    });
  }
}

final messagesProvider =
    AsyncNotifierProvider.family<MessagesViewModel, void, String>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.family
    .autoDispose<List<MessageModel>, String>((ref, _chatRoomId) {
  final db = FirebaseFirestore.instance;

  return db
      .collection("chat_rooms")
      .doc(_chatRoomId)
      .collection("texts")
      .orderBy("createdAt")
      .snapshots()
      .map((event) => event.docs
          .map(
            (doc) => MessageModel.fromJson(doc.data()),
          )
          .toList());
});

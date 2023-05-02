import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required MessageModel message,
    required String chatRoomId,
    required String personA,
    required String personB,
  }) async {
    await _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("texts")
        .add(message.toJson());

    await _db.collection("chat_rooms").doc(chatRoomId).update({
      "lastMessage": message.text,
      "createdAt": DateTime.now(),
    });

    await _db
        .collection("users")
        .doc(personA)
        .collection("chat_rooms")
        .doc(chatRoomId)
        .update({
      "lastMessage": message.text,
      "createdAt": DateTime.now(),
    });

    await _db
        .collection("users")
        .doc(personB)
        .collection("chat_rooms")
        .doc(chatRoomId)
        .update({
      "lastMessage": message.text,
      "createdAt": DateTime.now(),
    });
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_room_repo.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

class ChatRoomViewModel extends AsyncNotifier<void> {
  late final ChatRoomRepo _chatRoomRepo;
  late final UserRepository _userRepository;
  late List<String> chatRoomIdList = [];
  late List<String> userList = [];

  @override
  FutureOr<void> build() {
    _chatRoomRepo = ref.read(chatRoomRepo);
    _userRepository = ref.read(userRepo);
  }

  Future<void> createChatRoom(
      {required Map<String, dynamic> yourUserProfile}) async {
    final myUid = ref.read(authRepo).user!.uid;
    final myUserProfile = await _userRepository.findProfile(myUid);

    await _chatRoomRepo.createChatRoom(
        chatRoomModel: ChatRoomModel(
          personA: myUid,
          personB: yourUserProfile['uid'],
          chatRoomId: "${myUid}000${yourUserProfile['uid']}",
          createdAt: DateTime.now(),
          nameOfPersonA: myUserProfile!['name'],
          nameOfPersonB: yourUserProfile['name'],
          lastMessage: "",
        ),
        myUid: myUid,
        yourUid: yourUserProfile['uid']);
  }

  Future<List<Map<String, dynamic>>> getUserList() async {
    final userList = _userRepository.getUserList();

    return userList;
  }

  Future<List<Map<String, dynamic>>> getChatRoomModelList(String userId) async {
    return await _chatRoomRepo.getChatRoomModelList(userId);
  }

  Future<void> getChatRoomIdList(String userId) async {
    final list = await getChatRoomModelList(userId);
    if (list.isEmpty) return;

    for (var element in list) {
      chatRoomIdList.add(element['chatRoomId']);
    }
  }

  Future<void> getChatRoomUsers(String userId) async {
    final list = await getChatRoomModelList(userId);

    if (list.isEmpty) {
      return;
    } else {
      for (var element in list) {
        userList.add(element['personA']);
        userList.add(element['personB']);
      }
    }
  }

  Future<Map<String, dynamic>?> getChatRoomInfo(String chatRoomId) async {
    return await _chatRoomRepo.getChatRoomInfo(chatRoomId);
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatRoomViewModel, void>(
  () => ChatRoomViewModel(),
);

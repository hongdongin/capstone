import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("user").doc(uid).get();
    return doc.data();
  }

  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage.ref().child("avatars/$fileName");
    await fileRef.putFile(file);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  Future<bool> getIsLiked(String uid, String videoId) async {
    final likes = await _db
        .collection("users")
        .doc(uid)
        .collection("likes")
        .doc(videoId)
        .get();
    return likes.exists;
  }

  Future<List<Map<String, dynamic>>> getUserList() async {
    List<Map<String, dynamic>> userList = [];
    final usersQuery = _db.collection("users").get();

    await usersQuery.then((users) {
      for (var user in users.docs) {
        userList.add(user.data());
      }
      return userList;
    });
    return userList;
  }
}

final userRepo = Provider(
  (ref) => UserRepository(),
);

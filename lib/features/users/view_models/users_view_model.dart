import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile_model.dart';

class UserViewModel extends AsyncNotifier<UserProfileModel> {
  @override
  FutureOr<UserProfileModel> build() {
    return UserProfileModel.empty();
  }

  Future<void> createAccount(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("가입이 필요합니다.");
    }
    UserProfileModel(
        bio: "없음",
        link: "없음",
        email: credential.user!.email ?? "필수!!",
        uid: credential.user!.uid,
        name: credential.user!.displayName ?? "없음!");
  }
}

final usersProvider = AsyncNotifierProvider(
  () => UserViewModel(),
);

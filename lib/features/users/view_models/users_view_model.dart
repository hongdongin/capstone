import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

import '../models/user_profile_model.dart';

class UserViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _userRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _userRepository
          .findProfile(_authenticationRepository.user!.uid);
      print(profile);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createProfile({
    required UserCredential credential,
    String uid = "",
    String email = "",
    String name = "",
    String birthday = "",
    String creator = "",
  }) async {
    if (credential.user == null) {
      throw Exception("가입이 필요합니다.");
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      hasAvatar: false,
      bio: "update impormation",
      link: "update link",
      email: credential.user!.email ?? "signup plz",
      name: credential.user!.displayName ?? "update name",
      uid: credential.user!.uid,
      birthday: birthday,
      creator: creator,
    );
    await _userRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _userRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> updateProfile({
    required String bio,
    required String link,
  }) async {
    final uid = _authenticationRepository.user!.uid;
    state = AsyncValue.data(state.value!.copyWith(bio: bio, link: link));
    await _userRepository.updateUser(uid, {"bio": bio, "link": link});
  }
}

final usersProvider = AsyncNotifierProvider<UserViewModel, UserProfileModel>(
  () => UserViewModel(),
);

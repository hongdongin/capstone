import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/image/models/image_model.dart';
import 'package:tiktok_clone/features/image/repos/images_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class UploadImageViewModel extends AsyncNotifier<void> {
  late final ImageRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(imageRepo);
  }

  Future<void> uploadImage(File image, BuildContext context) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repository.uploadImageFile(
          image,
          user!.uid,
        );
        if (task.metadata != null) {
          await _repository.saveImage(
            ImageModel(
              title: "From Flutter!",
              description: "Hell yeah!",
              fileUrl: await task.ref.getDownloadURL(),
              creatorUid: user.uid,
              likes: 0,
              comments: 0,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              creator: userProfile.name,
            ),
          );
          context.pushReplacement("/home");
        }
      });
    }
  }
}

final uploadImageProvider = AsyncNotifierProvider<UploadImageViewModel, void>(
  () => UploadImageViewModel(),
);

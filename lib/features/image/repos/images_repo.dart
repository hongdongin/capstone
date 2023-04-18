import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/image/models/image_model.dart';

class ImageRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload a video file

  UploadTask uploadImageFile(File image, String uid) {
    final fileRef = _storage.ref().child(
          "/images/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}",
        );
    return fileRef.putFile(image);
  }

  Future<void> saveImage(ImageModel data) async {
    await _db.collection("images").add(data.toJson());
  }
}

final imageRepo = Provider((ref) => ImageRepository());

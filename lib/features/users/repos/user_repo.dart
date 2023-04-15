import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createProfile() async {}
}

final userRepository = Provider(
  (ref) => UserRepository(),
);

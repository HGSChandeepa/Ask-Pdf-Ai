import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  //Firebase storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage({required Uint8List profileImage}) async {
    Reference ref =
        _storage.ref().child("user-profile").child(_auth.currentUser!.uid);

    UploadTask task = ref.putData(profileImage);

    TaskSnapshot snapshot = await task;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

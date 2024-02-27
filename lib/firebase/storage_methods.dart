import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageMethods {
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: "upoint-d4fc3.appspot.com");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childname, Uint8List file, bool isPost, String? postId) async {
    try {
      // Uint8List _file = await convertImageToPng(file);
      Reference ref =
          _storage.ref().child(childname).child(_auth.currentUser!.uid);

      if (isPost) {
        ref = ref.child(postId!);
      }
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint(e.toString());
    }
    return "";
  }
}

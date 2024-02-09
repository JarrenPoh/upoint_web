import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:uuid/uuid.dart';
import '../models/organizer_model.dart';
import '../models/user_model.dart';
import 'storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //註冊用戶
  Future<String> signUpToStore(
    String role,
    String email,
    User currentUser,
  ) async {
    String res = 'some error occur';
    try {
      switch (role) {
        case "organizer":
          OrganizerModel user = OrganizerModel(
            email: email,
            uid: currentUser.uid,
          );
          //上傳firestore
          await _firestore
              .collection('organizers')
              .doc(currentUser.uid)
              .set(user.toJson());
          break;
        case "user":
          UserModel user = UserModel(
            email: email,
            uuid: currentUser.uid,
          );
          //上傳firestore
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .set(user.toJson());
          break;
      }

      res = 'success';
    } catch (e) {
      res = e.toString();
      print(res);
    }
    return res;
  }

  //尋找
  //上傳貼文
  Future<String> uploadPost(OrganizerModel organizer) async {
    String res = "some error occur";
    String? photoUrl;
    Uint8List file;
    String postId = const Uuid().v1();
    String getPost = UserSimplePreference.getpost();
    String? getForm = UserSimplePreference.getform() == ""
        ? null
        : UserSimplePreference.getform();
    PostModel post = PostModel.fromMap(jsonDecode(getPost));
    try {
      file = base64Decode(post.photo!);
      photoUrl = await StorageMethods()
          .uploadImageToStorage('posts', file, true, postId);
      post.photo = photoUrl;
      //以下尚未填過
      post.form = getForm;
      post.postId = postId;
      post.datePublished = DateTime.now();
      post.organizerName = organizer.userName;
      post.organizerPic = organizer.pic;
      post.organizerUid = organizer.uid;
      post.signList = [];
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
      print(res);
    }
    return res;
  }

  //上傳報名表單
  // Future<String> uploadForm(PostModel post, OrganModel organizer) async {
  //   String res = "some error occur";
  //   String? photoUrl;
  //   Uint8List? file;
  //   String postId = const Uuid().v1();
  //   try {
  //     file = await post.photos!.first;
  //     photoUrl = await StorageMethods()
  //         .uploadImageToStorage('posts', file!, true, postId);
  //     post.photos!.first = photoUrl;
  //     post.postId = postId;
  //     post.datePublished = DateTime.now();
  //     post.uid = organizer.uid;
  //     post.pic = organizer.pic;
  //     await _firestore.collection('posts').doc(postId).set(post.toJson());
  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }
}

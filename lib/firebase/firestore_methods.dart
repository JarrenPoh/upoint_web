import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/models/sign_form_model.dart';
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
  Future<Map> uploadPost(OrganizerModel organizer) async {
    String res = "some error occur";
    String? formUrl;
    String? photoUrl;
    Uint8List file;
    String postId = const Uuid().v1();
    String getPost = UserSimplePreference.getpost();
    String? getForm = UserSimplePreference.getform() == "null"
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
      post.startDateTime =
          DateFormat("yyyy-MM-dd/h:mm a").parse(post.startDateTime);
      post.endDateTime =
          DateFormat("yyyy-MM-dd/h:mm a").parse(post.endDateTime);
      if (post.formDateTime != null) {
        post.formDateTime =
            DateFormat("yyyy-MM-dd/h:mm a").parse(post.formDateTime);
      }
      post.organizerName = organizer.username;
      post.organizerPic = organizer.pic;
      post.organizerUid = organizer.uid;
      post.signFormsLength = 0;
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
      await UserSimplePreference.removeform();
      await UserSimplePreference.removepost();
      print('上傳成功');
      print('here1:$getForm');
      if (getForm == null) {
        formUrl = null;
      } else if (getForm.substring(0, 4) == "http") {
        formUrl = getForm;
      } else {
        formUrl = "https://upoint/signForm?id=$postId";
      }
    } catch (err) {
      res = err.toString();
      print(res);
      await UserSimplePreference.removeform();
      await UserSimplePreference.removepost();
    }
    return {
      "status": res,
      "formUrl": formUrl,
    };
  }

  //上傳報名表單
  Future<String> uploadSignForm(UserModel user, String postId) async {
    String res = "some error occur";
    String signFormId = const Uuid().v1();
    String getSignFormBody = UserSimplePreference.getSignForm();
    try {
      //以下尚未填過
      SignFormModel signForm = SignFormModel(
        uuid: user.uuid,
        fcmToken: user.fcmToken,
        body: getSignFormBody,
        datePublished: DateTime.now(),
        signFormId: signFormId,
      );
      // 上傳到posts collection下的signForms collection
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('signForms')
          .doc(signFormId)
          .set(signForm.toJson());
      // 幫posts文件的signFormsLength加一
      await _firestore.collection('posts').doc(postId).update({
        "signFormsLength": FieldValue.increment(1),
      });
      res = 'success';
      await UserSimplePreference.removeSignForm();
    } catch (err) {
      res = err.toString();
      print('err${err.toString()}');
    }
    return res;
  }
}

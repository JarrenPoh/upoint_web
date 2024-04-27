import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upoint_web/firebase/function_methods.dart';
import 'package:upoint_web/globals/time_transfer.dart';
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
    String email,
    User currentUser,
  ) async {
    String res = 'some error occur';
    try {
      UserModel user = UserModel(
        email: email,
        uuid: currentUser.uid,
      );
      //上傳firestore
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(user.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
      debugPrint(res);
    }
    return res;
  }

  //註冊用戶
  Future<String> signUpOrganizerToStore(
    OrganizerModel organizer,
  ) async {
    String res = 'some error occur';
    try {
      //上傳firestore
      await _firestore
          .collection('organizers')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(organizer.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
      debugPrint(res);
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
      if (post.remindDateTime != null) {
        post.remindDateTime =
            DateFormat("yyyy-MM-dd/h:mm a").parse(post.remindDateTime);
      }
      post.organizerName = organizer.username;
      post.organizerPic = organizer.pic;
      post.organizerUid = organizer.uid;
      post.signFormsLength = 0;
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
      await UserSimplePreference.removeform();
      await UserSimplePreference.removepost();
      debugPrint('上傳成功');
      if (getForm == null) {
        // 不用報名
        formUrl = null;
      } else if (getForm.substring(0, 4) == "http") {
        // 外部表單
        formUrl = getForm;
      } else {
        // 本表單
        formUrl = "https://upoint.tw/signForm?id=$postId";
        // 觸發創建通知task
        if (post.remindDateTime != null) {
          await FunctionMethods().createPostReminderTask(
            postId,
            "活動提醒",
            "提醒您報名的活動 “${post.title}” 將在${TimeTransfer.timeTrans06(Timestamp.fromDate(post.startDateTime))}開始，活動地點於 “${post.location}進行”",
            post.remindDateTime,
          );
        }
      }
      // 幫organizer的postLength加一
      await _firestore.collection('organizers').doc(organizer.uid).update({
        "postLength": FieldValue.increment(1),
      });
    } catch (err) {
      res = err.toString();
      debugPrint(res);
    }
    if (res != "success") {
      // 失敗情除local storage
      UserSimplePreference.removeform();
      UserSimplePreference.removepost();
    }
    return {
      "status": res,
      "formUrl": formUrl,
    };
  }

  // 更新貼文
  Future<String> updatePost(PostModel post) async {
    Uint8List file;
    String postId = post.postId!;
    String res = "some error occur";
    try {
      if (post.photo?.substring(0, 4) != "http") {
        file = base64Decode(post.photo!);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('posts', file, true, postId);
        post.photo = photoUrl;
      }
      //以下尚未填過
      post.startDateTime =
          DateFormat("yyyy-MM-dd/h:mm a").parse(post.startDateTime);
      post.endDateTime =
          DateFormat("yyyy-MM-dd/h:mm a").parse(post.endDateTime);
      await _firestore.collection('posts').doc(postId).update({
        "photo": post.photo,
        "title": post.title,
        "capacity": post.capacity,
        "location": post.location,
        "contact": post.contact,
        "phoneNumber": post.phoneNumber,
        "startDateTime": post.startDateTime,
        "endDateTime": post.endDateTime,
        "introduction": post.introduction,
        "content": post.content,
        "reward": post.reward,
        "link": post.link,
        "postType": post.postType,
        "rewardTagId": post.rewardTagId,
        "tags": post.tags,
      });
      res = 'success';
      debugPrint('更新成功');
    } catch (err) {
      res = err.toString();
      debugPrint(res);
    }
    return res;
  }

  //上傳報名表單
  Future<String> uploadSignForm(UserModel? user, String postId) async {
    String res = "some error occur";
    String signFormId = const Uuid().v1();
    String getSignFormBody = UserSimplePreference.getSignForm();
    List<String> _signList = user?.signList ?? [];
    try {
      //以下尚未填過
      SignFormModel signForm = SignFormModel(
        uuid: user?.uuid ?? "匿名登入",
        fcmToken: user?.fcmToken,
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
      // 幫users文件的signList加上postId
      if (user != null) {
        _signList.add(postId);
        await _firestore.collection('users').doc(user.uuid).update({
          "signList": _signList,
        });
      }
      res = 'success';
      await UserSimplePreference.removeSignForm();
    } catch (err) {
      res = err.toString();
      debugPrint('err${err.toString()}');
    }
    return res;
  }
}

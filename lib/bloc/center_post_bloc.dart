import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/models/post_model.dart';

class CenterPostBloc {
  CenterPostBloc(String postId) {
    fetchForm(postId);
  }
  final ValueNotifier<Map> postValueNotifier = ValueNotifier({
    "post": null,
    "isLoading": true,
  });

  fetchForm(String postId) async {
    try {
      if (postId == "") {
        postId = "error";
      }
      DocumentSnapshot? fetchPost = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();
      debugPrint('找了1則貼文');
      PostModel? _post =
          fetchPost.exists == false ? null : PostModel.fromSnap(fetchPost);
      postValueNotifier.value["post"] = _post;
      postValueNotifier.value["isLoading"] = false;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      postValueNotifier.notifyListeners();
    } catch (e) { 
      debugPrint('error:$e');
    }
  }

  List<OptionModel> fixCommon = [
    OptionModel(
      type: "username",
      subtitle: "姓名",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
    OptionModel(
      type: "phoneNumber",
      subtitle: "聯絡電話",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
    OptionModel(
      type: "email",
      subtitle: "email",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
  ];
}

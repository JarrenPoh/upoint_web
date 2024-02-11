import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';

class CenterBloc {
  CenterBloc(OrganizerModel organizer) {
    fetchPosts(organizer);
  }
  int step = 1;
  ValueNotifier<List<PostModel>?> postValueNotifier = ValueNotifier(null);

  fetchPosts(OrganizerModel organizer) async {
    try {
      QuerySnapshot<Map<String, dynamic>> fetchPost = await FirebaseFirestore
          .instance
          .collection('posts')
          .where('organizerUid', isEqualTo: organizer.uid)
          .orderBy('datePublished', descending: false)
          .limit(5)
          .get();
      print('找了${fetchPost.docs.length}則貼文');
      List<dynamic> _list = fetchPost.docs.toList();
      if (_list.isEmpty) {
        postValueNotifier.value = [];
      } else {
        postValueNotifier.value = [];
        postValueNotifier.value
            ?.addAll(_list.map((e) => PostModel.fromSnap(e)).toList());
      }
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      postValueNotifier.notifyListeners();
    } catch (e) {
      print('索取提文失敗：$e');
    }
  }
}

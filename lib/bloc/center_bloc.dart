import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';

class CenterBloc {
  late OrganizerModel organizer;
  CenterBloc(OrganizerModel _organizer) {
    organizer = _organizer;
    fetchInitialPosts();
    allPage = (organizer.postLength / limit).ceil();
  }
  int currentPage = 1;
  late int allPage;
  DocumentSnapshot? lastDocument; // 用于分页
  List<DocumentSnapshot> allDocuments = [];
  final int limit = 5;
  ValueNotifier<int> pageValueNotifier = ValueNotifier(1);
  ValueNotifier<List<PostModel>?> postValueNotifier = ValueNotifier(null);

  fetchInitialPosts() async {
    try {
      var _query = FirebaseFirestore.instance
          .collection('posts')
          .where('organizerUid', isEqualTo: organizer.uid)
          .orderBy('datePublished', descending: false)
          .limit(limit);
      QuerySnapshot<Map<String, dynamic>> fetchPost = await _query.get();
      List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
      print('找了${_list.length}則貼文');
      if (_list.isEmpty) {
        postValueNotifier.value = [];
      } else {
        lastDocument = _list.last;
        allDocuments.addAll(_list);
        postValueNotifier.value = [];
        postValueNotifier.value =
            (_list.map((e) => PostModel.fromSnap(e)).toList());
      }
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      postValueNotifier.notifyListeners();
    } catch (e) {
      print('索取提文失敗：$e');
    }
  }

  // 加载下一页
  Future<void> fetchNextPosts(int _page) async {
    pageValueNotifier.value = _page;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    pageValueNotifier.notifyListeners();
    int _start = (_page - 1) * limit;
    int _end = limit;
    try {
      print('換頁');
      var _query = FirebaseFirestore.instance
          .collection('posts')
          .where('organizerUid', isEqualTo: organizer.uid)
          .orderBy('datePublished', descending: false)
          .startAfterDocument(lastDocument!)
          .limit(limit);
      // 如果文章不夠了
      if (allDocuments.length < _start + 1) {
        print('文章不夠了');
        QuerySnapshot<Map<String, dynamic>> fetchPost = await _query.get();
        List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
        print('找了${_list.length}則貼文');
        if (_list.isNotEmpty) {
          lastDocument = _list.last;
          allDocuments.addAll(_list);
        }
      }
      _end = (allDocuments.length - _start) >= limit
          ? limit
          : (allDocuments.length - _start) % limit;
      List _list = allDocuments.getRange(_start, _start + _end).toList();
      postValueNotifier.value =
          (_list.map((doc) => PostModel.fromSnap(doc)).toList());
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      postValueNotifier.notifyListeners();
    } catch (e) {
      print('索取提文失敗：$e');
    }
  }
}

// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';

class CenterBloc {
  late OrganizerModel organizer;
  CenterBloc(OrganizerModel _organizer) {
    organizer = _organizer;
    fetchInitialPosts();
  }
  List<QueryDocumentSnapshot> _allList = [];
  final int limit = 5;
  ValueNotifier<Map> pageValueNotifier = ValueNotifier({
    "currPage": 1,
    "allPage": 1,
  });
  ValueNotifier<List<PostModel>?> postValueNotifier = ValueNotifier(null);
  String searchStatus = "即將開始的活動";

  fetchPost() async {
    DateTime _now = DateTime.now();
    var _a = FirebaseFirestore.instance
        .collection('posts')
        .where('organizerUid', isEqualTo: organizer.uid);
    debugPrint(organizer.uid);
    bool _descending = true;
    try {
      switch (searchStatus) {
        case "全選":
          _allList = (await _a.get()).docs.toList();
          break;
        case "即將開始的活動":
          _allList = (await _a
                  .where('startDateTime', isGreaterThan: _now)
                  .orderBy("startDateTime", descending: _descending)
                  .get())
              .docs
              .toList();

          break;
        case "進行中的活動":
          _allList = (await _a
                  .where('endDateTime', isGreaterThan: _now)
                  .orderBy("endDateTime", descending: _descending)
                  .get())
              .docs
              .where((doc) {
            var startDateTime = doc['startDateTime'] as Timestamp;
            return startDateTime.toDate().isBefore(_now);
          }).toList();

          break;
        case "已結束的活動":
          _allList = (await _a
                  .where('endDateTime', isLessThan: _now)
                  .orderBy("endDateTime", descending: _descending)
                  .get())
              .docs
              .toList();

          break;
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
    }
  }

  fetchInitialPosts() async {
    await fetchPost();
    try {
      debugPrint('找了${_allList.length}則貼文');
      if (_allList.isEmpty) {
        postValueNotifier.value = [];
      } else {
        postValueNotifier.value = [];
        int _end =
            (_allList.length) >= limit ? limit : (_allList.length) % limit;
        List<QueryDocumentSnapshot> _list = _allList;
        postValueNotifier.value = (_list
            .getRange(0, _end)
            .map((e) => PostModel.fromSnap(e))
            .toList());
      }
      pageValueNotifier.value["allPage"] =
          _allList.isEmpty ? 1 : (_allList.length / limit).ceil();
      pageValueNotifier.notifyListeners();
      postValueNotifier.notifyListeners();
    } catch (e) {
      debugPrint('索取提文失敗：$e');
    }
  }

  // 加载下一页
  Future<void> changePage(int _page) async {
    pageValueNotifier.value["currPage"] = _page;
    pageValueNotifier.notifyListeners();
    int _start = (_page - 1) * limit;
    debugPrint('換頁');
    int _end = (_allList.length - _start) >= limit
        ? limit
        : (_allList.length - _start) % limit;

    List<QueryDocumentSnapshot> _list =
        _allList.getRange(_start, _start + _end).toList();
    postValueNotifier.value =
        (_list.map((doc) => PostModel.fromSnap(doc)).toList());
    postValueNotifier.notifyListeners();
  }
}

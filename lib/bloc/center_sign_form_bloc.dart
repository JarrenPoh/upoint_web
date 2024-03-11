// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/models/sign_form_model.dart';

class CenterSignFormBloc {
  CenterSignFormBloc(String postId) {
    fetchForm(postId);
  }
  final ValueNotifier<Map> postValueNotifier = ValueNotifier({
    "post": null,
    "isLoading": true,
    "form": null,
    "isForm": null,
    "signFormList": null
  });
  PostModel? _post;
  List<SignFormModel> signFormList=[];

  fetchForm(String postId) async {
    if (postId == "") {
      postId = "error";
    }
    DocumentSnapshot? fetchPost =
        await FirebaseFirestore.instance.collection('posts').doc(postId).get();
    debugPrint('在center_sign_form找了1則貼文');
    _post = fetchPost.exists == false ? null : PostModel.fromSnap(fetchPost);
    QuerySnapshot<Map<String, dynamic>>? fetchSignForms =
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('signForms')
            .get();
    debugPrint('在center_sign_form找了${fetchSignForms.docs.length}則報名名單');

    // 處理貼文
    postValueNotifier.value["post"] = _post;
    // 處理表單
    String? _form = _post?.form;
    if (_form == null || _form.substring(0, 4) == 'http') {
      debugPrint('沒有用UPoint表單');
      postValueNotifier.value["isForm"] = false;
    } else {
      List<FormModel> formModel =
          (jsonDecode(_form) as List).map((e) => FormModel.fromMap(e)).toList();
      formModel.first.options.insertAll(0, fixCommon);
      postValueNotifier.value["isForm"] = true;
      postValueNotifier.value["form"] = formModel;
    }
    //處理報名名單
    signFormList = fetchSignForms.docs.isNotEmpty
        ? fetchSignForms.docs
            .toList()
            .map((e) => SignFormModel.fromSnap(e))
            .toList()
        : [];
    postValueNotifier.value["signFormList"] = signFormList;

    postValueNotifier.value["isLoading"] = false;
    postValueNotifier.notifyListeners();
  }

  exportExcel(BuildContext context) {
    if (signFormList.isEmpty) {
      //沒有人報名
      Messenger.dialog("錯誤", "目前該活動無人報名，無法匯出檔案", context);
    } else {
      var excel = Excel.createExcel(); // Create a new Excel document.
      String? sheetName = "Sheet1";
      Sheet sheetObject = excel[sheetName]; // Or create a new sheet.
      List<List> listsOfLists =
          signFormList.map((e) => (jsonDecode(e.body) as List)).toList();
      // 創建一個Set來存儲所有唯一的標題（即subtitle）
      Set<String> allSubtitles = {};

      // 遍歷所有List<Map>來收集所有唯一的subtitle
      listsOfLists.forEach((list) {
        list.forEach((map) {
          if (map.containsKey("subtitle")) {
            allSubtitles.add(map["subtitle"]!);
          }
        });
      });

      // 將標題轉換成List並排序（如果需要的話）
      List<String> headers = allSubtitles.toList()..sort();
      debugPrint('header:${headers.map((e) => TextCellValue(e)).toList()}');
      // 將標題行加入到Excel
      sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

      // 遍歷每個List<Map>，整理並加入到Excel
      listsOfLists.forEach((list) {
        Map<String, String> rowValues = Map.fromIterable(headers,
            key: (item) => item, value: (item) => "無");

        // 更新當前行的值
        list.forEach((map) {
          String subtitle = map["subtitle"] ?? "";
          String value = map["value"] ?? "無";
          if (rowValues.containsKey(subtitle)) {
            rowValues[subtitle] = value;
          }
        });
        // 根據headers順序添加值到行
        List<String> row = headers.map((header) => rowValues[header]!).toList();
        debugPrint('row:${row.map((e) => TextCellValue(e)).toList()}');

        sheetObject.appendRow(row.map((e) => TextCellValue(e)).toList());
      });

      // Save the Excel file
      var fileBytes = excel.save(fileName: "${_post!.title}.xlsx");
      File("yyyy.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
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

// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_form_bloc.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';

class CreateStep2Bloc {
  late CreateFormBloc createFormBloc;
  late ValueNotifier<PostModel> postValue;
  late bool _isEdit;
  CreateStep2Bloc({
    required List<FormModel> formModel,
    required bool isEdit,
    required PostModel post,
  }) {
    createFormBloc = CreateFormBloc(formModel: formModel, isEdit: isEdit);
    _isEdit = isEdit;
    postValue = ValueNotifier(post);
    if (postValue.value.remindDateTime != null) {
      needReminder.value = true;
    }
  }
  ValueNotifier<String> formOptionValue = ValueNotifier("form");
  ValueNotifier<bool> needReminder = ValueNotifier(false);
  List<Map> formOptions = [
    {
      "text": "使用本系統表單",
      "type": "form",
    },
    {
      "text": "使用外部連結",
      "type": "link",
    },
    {
      "text": "無需報名",
      "type": "null",
    },
  ];

  List<Map> signOptions = [
    {
      "title": "報名截止日期",
      "type": "date",
      "index": "formDateTime",
    },
    {
      "title": "發送活動提醒日期",
      "type": "date",
      "index": "remindDateTime",
    },
  ];

  tapOption(String type) {
    formOptionValue.value = type;
    formOptionValue.notifyListeners();
  }

  String link = "";
  linkTextChanged(String text) {
    link = text;
  }

  dateFunc(String index, String? dateText, String? timeText) async {
    if (index == "formDateTime") {
      postValue.value.formDateTime = "$dateText/$timeText";
    } else if (index == "remindDateTime") {
      if (dateText == null && timeText == null) {
        postValue.value.remindDateTime = null;
      } else {
        postValue.value.remindDateTime = "$dateText/$timeText";
      }
    }
    postValue.notifyListeners();
    if (!_isEdit) {
      await UserSimplePreference.setpost(
        jsonEncode(PostModel.toMap(postValue.value)),
      );
    }
  }

  changeNeedReminder(bool _b, String _index) {
    needReminder.value = _b;
    needReminder.notifyListeners();
    if (_b == false) {
      dateFunc(
        _index,
        null,
        null,
      );
    }
  }

  //  檢查step2有沒有沒寫完的
  String? checkFunc() {
    //確認要檢查什麼類型
    String type = formOptionValue.value;
    String? errorText;
    bool _check(String? v) {
      return v == null || v == "" || v == "null";
    }

    List _formList = postValue.value.formDateTime == null
        ? ["", ""]
        : (postValue.value.formDateTime as String).split('/');
    List _remindList = postValue.value.remindDateTime == null
        ? ["", ""]
        : (postValue.value.remindDateTime as String).split('/');
    switch (type) {
      case "link":
        if (link == "") {
          errorText = "請填寫外部報名連結";
        } else if (_check(_formList[0])) {
          errorText = '“表單截止日期”尚未填寫';
        } else if (_check(_formList[1])) {
          errorText = '“表單截止時間”尚未填寫';
        }
        break;
      case "form":
        List<FormModel> formList = createFormBloc.valueNotifier.value;
        for (var form in formList) {
          if (_check(_formList[0])) {
            errorText = '“表單截止日期”尚未填寫';
            break;
          } else if (_check(_formList[1])) {
            errorText = '“表單截止時間”尚未填寫';
            break;
          } else if (needReminder.value) {
            if (_check(_remindList[0])) {
              errorText = '“發送活動提醒日期”尚未填寫';
              break;
            } else if (_check(_remindList[1])) {
              errorText = '“發送活動提醒時間”尚未填寫';
              break;
            }
          }
          if (_check(form.title)) {
            errorText = '大標題不能為空！';
            break;
          }
          for (var option in form.options) {
            if (_check(option.subtitle)) {
              errorText = '"${form.title}"有副標尚未填寫內容';
              break;
            } else if (option.explain != null && option.explain == "") {
              errorText = '"${option.subtitle}"的說明文字尚未填寫內容';
              break;
            } else if (option.type == "multi" &&
                option.body.any((e) => _check(e))) {
              errorText = '"${option.subtitle}"有選項尚未填寫內容';
              break;
            } else if (option.type == "single" &&
                option.body.any((e) => _check(e))) {
              errorText = '"${option.subtitle}"有選項尚未填寫內容';
              break;
            } else if (option.type == "drop_down" &&
                option.body.any((e) => _check(e))) {
              errorText = '"${option.subtitle}"有選項尚未填寫內容';
              break;
            }
          }
        }
        break;
    }
    return errorText;
  }

  // 送出
  confirmSend({
    required BuildContext context,
    required OrganizerModel organizer,
    required Function(int) jumpToPage,
    required bool isVisible,
  }) async {
    await _checkType();
    PostModel post =
        PostModel.fromMap(jsonDecode(UserSimplePreference.getpost()));
    post.isVisible = isVisible;
    post.isSendCreateMessaging = isVisible == true;
    UserSimplePreference.setpost(jsonEncode(PostModel.toMap(post)));
    //到完成頁
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(true);
    jumpToPage(2);
  }

  // 確認是選什麼類型，link的話要換一下userSimplePreference
  _checkType() async {
    String type = formOptionValue.value;
    if (type == "link") {
      await UserSimplePreference.setform(link);
    } else if (type == "null") {
      await UserSimplePreference.setform("null");
    }
  }
}

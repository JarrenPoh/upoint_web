import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_form_bloc.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/organizer_model.dart';

class CreateStep2Bloc {
  late CreateFormBloc createFormBloc;
  CreateStep2Bloc(List<FormModel> formModel) {
    createFormBloc = CreateFormBloc(formModel);
  }
  ValueNotifier<String> formOptionValue = ValueNotifier("form");
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

  tapOption(String type) {
    formOptionValue.value = type;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    formOptionValue.notifyListeners();
  }

  String _link = "";
  linkTextChanged(String text) {
    _link = text;
  }

  //  檢查step2有沒有沒寫完的
  String? checkFunc() {
    //確認要檢查什麼類型
    String type = formOptionValue.value;
    String? errorText;
    bool _check(String? v) {
      return v == null || v == "";
    }

    switch (type) {
      case "link":
        if (_link == "") {
          errorText = "請填寫外部報名連結";
        }
        break;
      case "form":
        List<FormModel> formList = createFormBloc.valueNotifier.value;
        for (var form in formList) {
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

  //送出
  confirmSend(
    BuildContext context,
    OrganizerModel organizer,
    Function(int) jumpToPage,
  ) async {
    //確認是選什麼類型，link的話要換一下userSimplePreference
    String type = formOptionValue.value;
    if (type == "link") {
      await UserSimplePreference.setform(_link);
    } else if (type == "null") {
      await UserSimplePreference.setform("null");
    }
    //到完成頁
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(true);
    jumpToPage(2);
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/option_model.dart';

class CreateFormBloc {
  late ValueNotifier<List<FormModel>> valueNotifier;
  late final ValueNotifier<List> commonLeftValue;
  late final ValueNotifier<List> schoolLeftValue;
  late final ValueNotifier<List> customLeftValue;

  CreateFormBloc(List<FormModel> formModel) {
    valueNotifier = ValueNotifier(formModel);
    commonLeftValue = ValueNotifier(commonFields);
    schoolLeftValue = ValueNotifier(schoolFields);
    customLeftValue = ValueNotifier(customFields);
  }

  addToForm(String feildType, OptionModel option) {
    int _index;
    if (feildType == "common") {
      _index = 0;
      if (option.type == "gender") {
        option.body = ["男", "女"];
      } else if (option.type == "meal") {
        option.body = ["葷", "素"];
      }
    } else if (feildType == "school") {
      _index = 1;
    } else {
      //加到最下面
      _index = valueNotifier.value.length - 1;
    }
    //如果沒學校，先加學校
    if (feildType == "school" && valueNotifier.value.length == 1) {
      valueNotifier.value.add(FormModel(title: "學校相關", options: [option]));
    } else {
      valueNotifier.value[_index].options.add(option);
    }
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    valueNotifier.notifyListeners();
    UserSimplePreference.setform(
        jsonEncode(valueNotifier.value.map((form) => form.toJson()).toList()));
  }

  removeFromForm(Map optionMap, bool isTapDesignBlock) {
    List<FormModel> _value = valueNotifier.value;
    if (isTapDesignBlock) {
      OptionModel _op = OptionModel.fromMap(optionMap);
      for (var i = 0; i < _value.length; i++) {
        _value[i].options.removeWhere((e) => e.type == _op.type);
      }
    } else {
      _value[optionMap["lindex"]].options.removeAt(optionMap["index"]);
    }
    checkTitleIsEmpty(_value);
  }

  addLeftOrangeOuter(String feildType, int index) {
    ValueNotifier<List<dynamic>> _leftValue;
    if (feildType == "common") {
      _leftValue = commonLeftValue;
    } else if (feildType == "school") {
      _leftValue = schoolLeftValue;
    } else {
      _leftValue = customLeftValue;
    }
    _leftValue.value[index]['selected'] = true;
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    _leftValue.notifyListeners();
  }

  removeLeftOrangeOuter(String type) {
    int index;
    if (commonFields.any((e) => e["type"] == type)) {
      index = commonFields.indexWhere((e) => e["type"] == type);
      commonLeftValue.value[index]['selected'] = false;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      commonLeftValue.notifyListeners();
    } else if (schoolFields.any((e) => e["type"] == type)) {
      index = schoolFields.indexWhere((e) => e["type"] == type);
      schoolLeftValue.value[index]['selected'] = false;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      schoolLeftValue.notifyListeners();
    }
  }

  //檢查有沒有標題下面沒選項，沒選項的標題自動刪除
  checkTitleIsEmpty(List<FormModel> _value) {
    //檢查如果區塊下沒東西，刪掉標題
    _value.removeWhere((e) => e.title != "基本資料" && e.options.isEmpty);
    valueNotifier.value = _value;
    // ignore: invalid_use_of_visible_for_testing_member,, invalid_use_of_protected_member
    valueNotifier.notifyListeners();
    UserSimplePreference.setform(
        jsonEncode(valueNotifier.value.map((form) => form.toJson()).toList()));
  }

  //說明文字, 其他, 必填
  checkBox(String type, OptionModel option) {
    switch (type) {
      case "explain":
        if (option.explain == null) {
          option.explain = "";
        } else {
          option.explain = null;
        }
        break;
      case "other":
        if (option.other == null) {
          option.other = "其他..";
        } else {
          option.other = null;
        }
        break;
      case "necessary":
        if (option.necessary == false) {
          option.necessary = true;
        } else {
          option.necessary = false;
        }
        break;
      case "removeBody":
        option.body.removeLast();
        break;
      case "addBody":
        option.body.add("");
        break;
    }
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    valueNotifier.notifyListeners();
    UserSimplePreference.setform(
        jsonEncode(valueNotifier.value.map((form) => form.toJson()).toList()));
  }

  //解釋的文字
  Timer? debounce;
  explainTextChanged(String text, OptionModel option) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 250), () async {
      option.explain = text;
      UserSimplePreference.setform(jsonEncode(
          valueNotifier.value.map((form) => form.toJson()).toList()));
    });
  }

  //多選跟單選的選項文字
  onTextChanged(String text, OptionModel option, int index) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 250), () async {
      option.body[index] = text;
      UserSimplePreference.setform(jsonEncode(
          valueNotifier.value.map((form) => form.toJson()).toList()));
    });
  }

  onSubtitleChanged(String text, OptionModel option) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 250), () async {
      option.subtitle = text;
      UserSimplePreference.setform(jsonEncode(
          valueNotifier.value.map((form) => form.toJson()).toList()));
    });
  }

  //自定義formModel的標題文字
  onTitleChanged(String text, FormModel form) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 250), () async {
      form.title = text;
      UserSimplePreference.setform(jsonEncode(
          valueNotifier.value.map((form) => form.toJson()).toList()));
    });
  }

  // 初始化，如果之前有填過內容，橘色外匡耀預設出現
  initLeftOrangeOuter() {
    for (FormModel form in valueNotifier.value) {
      for (OptionModel option in form.options) {
        List _commons = commonFields.map((e) => e["type"]).toList();
        List _schools = schoolFields.map((e) => e["type"]).toList();
        if (_commons.contains(option.type)) {
          int _i = _commons.indexWhere((e) => e == option.type);
          addLeftOrangeOuter(
            "common",
            _i,
          );
        } else if (_schools.contains(option.type)) {
          int _i = _schools.indexWhere((e) => e == option.type);
          addLeftOrangeOuter(
            "school",
            _i,
          );
        }
      }
    }
  }

  List<Map> commonFields = [
    {
      "subtitle": "性別",
      "hover": false,
      "selected": false,
      "type": "gender",
    },
    {
      "subtitle": "身分證字號",
      "hover": false,
      "selected": false,
      "type": "id",
    },
    {
      "subtitle": "出生年月日(西元年)",
      "hover": false,
      "selected": false,
      "type": "date2002",
    },
    {
      "subtitle": "出生年月日(民國年)",
      "hover": false,
      "selected": false,
      "type": "date91",
    },
    {
      "subtitle": "飲食需求(葷素)",
      "hover": false,
      "selected": false,
      "type": "meal",
    },
    {
      "subtitle": "地址",
      "hover": false,
      "selected": false,
      "type": "address",
    },
  ];

  List fixCommon = [
    {
      "subtitle": "姓名",
      "type": "username",
    },
    {
      "subtitle": "聯絡電話",
      "type": "phonenumber",
    },
    {
      "subtitle": "email",
      "type": "email",
    },
  ];

  List<Map> schoolFields = [
    {
      "subtitle": "學校名稱",
      "hover": false,
      "selected": false,
      "type": "school",
    },
    {
      "subtitle": "學院",
      "hover": false,
      "selected": false,
      "type": "department0",
    },
    {
      "subtitle": "系所",
      "hover": false,
      "selected": false,
      "type": "department1",
    },
    {
      "subtitle": "年級",
      "hover": false,
      "selected": false,
      "type": "grade",
    },
    {
      "subtitle": "班級",
      "hover": false,
      "selected": false,
      "type": "class",
    },
  ];

  List<Map> customFields = [
    {
      "subtitle": "新增標題",
      "hover": false,
      "selected": false,
      "type": "add_title",
    },
    {
      "subtitle": "簡答文字",
      "hover": false,
      "selected": false,
      "type": "short",
    },
    {
      "subtitle": "詳答文字",
      "hover": false,
      "selected": false,
      "type": "detail",
    },
    {
      "subtitle": "單選項目",
      "hover": false,
      "selected": false,
      "type": "single",
    },
    {
      "subtitle": "複選項目",
      "hover": false,
      "selected": false,
      "type": "multi",
    },
    {
      "subtitle": "下拉選單",
      "hover": false,
      "selected": false,
      "type": "drop_down",
    },
    {
      "subtitle": "日期",
      "hover": false,
      "selected": false,
      "type": "date",
    },
    {
      "subtitle": "時間",
      "hover": false,
      "selected": false,
      "type": "time",
    },
  ];
}

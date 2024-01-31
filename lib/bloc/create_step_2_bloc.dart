import 'package:flutter/material.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/option_model.dart';

class CreateStep2Bloc {
  final ValueNotifier<List<FormModel>> valueNotifier =
      ValueNotifier([FormModel(title: "基本資料", options: [])]);
  late final ValueNotifier<List> commonLeftValue;
  late final ValueNotifier<List> schoolLeftValue;
  late final ValueNotifier<List> customLeftValue;

  CreateStep2Bloc() {
    commonLeftValue = ValueNotifier(commonFields);
    schoolLeftValue = ValueNotifier(schoolFields);
    customLeftValue = ValueNotifier(customFields);
  }

  addToForm(String feildType, OptionModel option) {
    int _index;
    if (feildType == "common") {
      _index = 0;
      if (option.type == "gender") {
        option.body = ["葷", "素"];
      } else if (option.type == "meal") {
        option.body = ["男", "女"];
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

  checkTitleIsEmpty(List<FormModel> _value) {
    //檢查如果區塊下沒東西，刪掉標題
    _value.removeWhere((e) => e.title != "基本資料" && e.options.isEmpty);
    valueNotifier.value = _value;
    // ignore: invalid_use_of_visible_for_testing_member,, invalid_use_of_protected_member
    valueNotifier.notifyListeners();
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

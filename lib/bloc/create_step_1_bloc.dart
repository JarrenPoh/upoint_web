// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/models/tag_model.dart';

class CreateStep1Bloc {
  CreateStep1Bloc(PostModel postModel) {
    valueNotifier = ValueNotifier(postModel);
    // 加初始
    if (UserSimplePreference.getCustomTags() != null) {
      List<String> _list = UserSimplePreference.getCustomTags()!;
      for (var i in _list) {
        tagList[2].tagValue.insert(
          0,
          {
            "index": i,
            "isChecked": false,
            "isCustom": true,
          },
        );
      }
    }
  }
  late ValueNotifier<PostModel> valueNotifier;
  List createInformList = [
    {
      "title": "活動名稱",
      "index": "title",
      "type": "normal",
    },
    {
      "title": "活動地點",
      "index": "location",
      "type": "normal",
    },
    {
      "title": "活動負責人（稱謂）",
      "index": "contact",
      "type": "normal",
    },
    {
      "title": "聯絡方式",
      "index": "phoneNumber",
      "type": "normal",
    },
    {
      "title": "活動名額（限阿拉伯數字 如：10,20,30）",
      "index": "capacity",
      "type": "checkNull",
    },
    {
      "title": "活動獎勵",
      "index": "reward",
      "type": "checkNull",
    },
    {
      "title": "其他參考連結",
      "index": "link",
      "type": "checkNull",
    },
    {
      "title": "活動開始日期",
      "index": "startDate",
      "type": "date",
    },
    {
      "title": "活動結束日期",
      "index": "endDate",
      "type": "date",
    },
    {
      "title": "活動簡介",
      "index": "introduction",
      "type": "normal",
    },
  ];

  List<TagModel> tagList = [
    TagModel(
      type: "postType",
      title: "活動類別（APP內活動分類）",
      tagValue: [
        {"index": "演講講座", "isChecked": false},
        {"index": "實習就業", "isChecked": false},
        {"index": "志工服務", "isChecked": false},
        {"index": "藝術人文", "isChecked": false},
        {"index": "資訊科技", "isChecked": false},
        {"index": "學習成長", "isChecked": false},
        {"index": "戶外探索", "isChecked": false},
        {"index": "競賽活動", "isChecked": false},
      ],
    ),
    TagModel(
      type: "rewardTag",
      title: "獎勵標籤（限選1項）",
      tagValue: [
        {"index": "無", "id": null, "isChecked": false},
        {"index": "中式便當", "id": "002", "isChecked": false},
        {"index": "麵包餐盒", "id": "004", "isChecked": false},
        {"index": "麥當勞", "id": "001", "isChecked": false},
        {"index": "附餐", "id": "003", "isChecked": false},
        {"index": "飲料", "id": "005", "isChecked": false},
        {"index": "獎金", "id": "006", "isChecked": false},
      ],
    ),
    TagModel(
      type: "tags",
      title: "搜尋標籤（增加搜尋時的觸及關鍵字，不限次數）",
      tagValue: [
        {"index": "體驗活動", "isChecked": false},
        {"index": "實習就業", "isChecked": false},
        {"index": "語言學習", "isChecked": false},
        {"index": "志工服務", "isChecked": false},
        {"index": "藝文欣賞", "isChecked": false},
        {"index": "DIY手作", "isChecked": false},
        {"index": "電腦軟體", "isChecked": false},
        {"index": "程式語言", "isChecked": false},
        {"index": "戶外活動", "isChecked": false},
        {"index": "系學會", "isChecked": false},
        {"index": "運動", "isChecked": false},
        {"index": "大自然", "isChecked": false},
        {"index": "文化交流", "isChecked": false},
        {"index": "營隊", "isChecked": false},
        {"index": "藝術人文", "isChecked": false},
      ],
    ),
  ];

  //選取照片
  // File? _image;
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // 选取图片
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    // 更新 UI
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      valueNotifier.value.photo = base64Image;
      valueNotifier.notifyListeners();
      await UserSimplePreference.setpost(
        jsonEncode(PostModel.toMap(valueNotifier.value)),
      );
    }
  }

  //輸入文字
  Timer? debounce01;

  void onTextChanged(String? text, int index) {
    if (debounce01?.isActive ?? false) debounce01!.cancel();
    debounce01 = Timer(const Duration(milliseconds: 250), () async {
      String _type = createInformList[index]["index"];
      switch (_type) {
        case "title":
          valueNotifier.value.title = text;
          break;
        case "location":
          valueNotifier.value.location = text;
          break;
        case "contact":
          valueNotifier.value.contact = text;
          break;
        case "phoneNumber":
          valueNotifier.value.phoneNumber = text;
          break;
        case "capacity":
          valueNotifier.value.capacity = text == null ? null : int.parse(text);
          break;
        case "introduction":
          valueNotifier.value.introduction = text;
          break;
        case "reward":
          valueNotifier.value.reward = text;
          break;
        case "link":
          valueNotifier.value.link = text;
      }
      await UserSimplePreference.setpost(
        jsonEncode(PostModel.toMap(valueNotifier.value)),
      );
    });
  }

  deleteCustomTag(String text) async {
    // 元數據刪除標籤
    tagList[2].tagValue.removeWhere((e) => e["index"] == text);
    // 電腦刪除標籤
    List<String> _list = UserSimplePreference.getCustomTags() ?? [];
    _list.removeWhere((e) => e == text);
    await UserSimplePreference.setCustomTags(_list);
    // valueNotifier刪除
    if (valueNotifier.value.tags!.contains(text)) {
      valueNotifier.value.tags!.removeWhere((e) => e == text);
    }
    valueNotifier.notifyListeners();
  }

  addCustomTag(String text) async {
    // 元數據新增標籤
    Map _map = {"index": text, "isChecked": true, "isCustom": true};
    tagList[2].tagValue.insert(0, _map);
    // 新增標籤加到電腦
    List<String> _list = UserSimplePreference.getCustomTags() ?? [];
    _list.add(text);
    await UserSimplePreference.setCustomTags(_list);
    // 加到valueNotifier
    tagPick(2, text);
    valueNotifier.notifyListeners();
  }

  // 選取tag
  tagPick(int index, String text) async {
    String _type = tagList[index].type;
    switch (_type) {
      case "postType":
        valueNotifier.value.postType = text;
      case "rewardTag":
        int i = tagList[index].tagValue.indexWhere((e) => e["index"] == text);
        String? rewardTagId = tagList[index].tagValue[i]["id"];
        valueNotifier.value.rewardTagId = rewardTagId;
        break;
      case "tags":
        if (valueNotifier.value.tags!.contains(text)) {
          valueNotifier.value.tags!.removeWhere((e) => e == text);
        } else {
          valueNotifier.value.tags!.add(text);
        }
        break;
    }
    await UserSimplePreference.setpost(
      jsonEncode(PostModel.toMap(valueNotifier.value)),
    );
  }

  //  輸入quill
  Timer? debounce02;
  onQuillChanged(Delta delta) {
    if (debounce01?.isActive ?? false) debounce01!.cancel();
    debounce01 = Timer(const Duration(milliseconds: 250), () async {
      String json = jsonEncode(delta.toJson());
      valueNotifier.value.content = json;
      await UserSimplePreference.setpost(
        jsonEncode(PostModel.toMap(valueNotifier.value)),
      );
    });
  }

  dateTimeFunc(String? dateText, String? timeText, int index) async {
    String _type = createInformList[index]["index"];
    switch (_type) {
      case "startDate":
        valueNotifier.value.startDateTime = "$dateText/$timeText";
        break;
      case "endDate":
        valueNotifier.value.endDateTime = "$dateText/$timeText";
    }
    // valueNotifier.notifyListeners();
    await UserSimplePreference.setpost(
      jsonEncode(PostModel.toMap(valueNotifier.value)),
    );
  }

  // timeFunc(String text, int index) async {
  //   String _type = createInformList[index]["index"];
  //   switch (_type) {
  //     case "startDate":
  //       valueNotifier.value.startTime = text;
  //       break;
  //     case "endDate":
  //       valueNotifier.value.endTime = text;
  //       break;
  //     case "formDate":
  //       valueNotifier.value.formTime = text;
  //       break;
  //   }
  //   // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  //   valueNotifier.notifyListeners();
  //   await UserSimplePreference.setpost(
  //     jsonEncode(PostModel.toMap(valueNotifier.value)),
  //   );
  // }

  //  檢查step1有沒有沒寫完的˝
  String? checkFunc() {
    PostModel post = valueNotifier.value;
    String? text;
    bool _check(String? v) {
      return v == null || v == "";
    }

    List _startList = post.startDateTime == null
        ? ["", ""]
        : (post.startDateTime as String).split('/');
    List _endList = post.endDateTime == null
        ? ["", ""]
        : (post.endDateTime as String).split('/');

    if (_check(post.photo)) {
      text = '“照片”尚未填寫';
    } else if (_check(post.title)) {
      text = '“活動名稱”尚未填寫';
    } else if (_check(post.capacity.toString())) {
      text = '“不限人數”尚未填寫';
    } else if (_check(post.location)) {
      text = '“活動地點”尚未填寫';
    } else if (_check(post.contact)) {
      text = '“活動負責人”尚未填寫';
    } else if (_check(post.phoneNumber)) {
      text = '“聯絡方式”尚未填寫';
    } else if (_check(_startList[0])) {
      text = '“開始日期”尚未填寫';
    } else if (_check(_startList[1])) {
      text = '“開始時間”尚未填寫';
    } else if (_check(_endList[0])) {
      text = '“結束日期”尚未填寫';
    } else if (_check(_endList[1])) {
      text = '“結束時間”尚未填寫';
    } else if (_check(post.introduction)) {
      text = '“活動簡介”尚未填寫';
    } else if (_check(post.content)) {
      text = '“活動詳情”尚未填寫';
    } else if (_check(post.reward.toString())) {
      text = '"活動獎勵"尚未填寫';
    } else if (_check(post.link.toString())) {
      text = '"其他參考連結"尚未填寫';
    }
    return text;
  }
}

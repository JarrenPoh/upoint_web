import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/post_model.dart';

class CreateStep1Bloc {
  CreateStep1Bloc(PostModel postModel) {
    valueNotifier = ValueNotifier(postModel);
  }
  late ValueNotifier<PostModel> valueNotifier;
  List createInformList = [
    {
      "title": "活動名稱",
      "index": "title",
      "type": "normal",
    },
    {
      "title": "活動名額（限阿拉伯數字 如：10,20,30）",
      "index": "capacity",
      "type": "capacity",
    },
    {
      "title": "活動地點",
      "index": "location",
      "type": "normal",
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
      "title": "報名截止日期",
      "index": "formDate",
      "type": "date",
    },
    {
      "title": "活動獎勵",
      "index": "reward",
      "type": "normal",
    },
    {
      "title": "活動簡介",
      "index": "introduction",
      "type": "normal",
    },
  ];

  List tagList = [
    {
      "title": "獎勵標籤（限選1項）",
      "type": "rewardTag",
      "tag": [
        {"index": "無", "id": null, "isChecked": false},
        {"index": "中式便當", "id": "002", "isChecked": false},
        {"index": "麵包餐盒", "id": "004", "isChecked": false},
        {"index": "麥當勞", "id": "001", "isChecked": false},
        {"index": "飲料", "id": "005", "isChecked": false},
      ]
    },
    {
      "title": "獎勵標籤（選填）",
      "type": "tag",
      "tag": [
        {"index": "體驗活動", "isChecked": false},
        {"index": "實習就業", "isChecked": false},
        {"index": "語言學習", "isChecked": false},
        {"index": "志工服務", "isChecked": false},
        {"index": "藝文欣賞", "isChecked": false},
      ]
    },
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
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
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
        case "capacity":
          valueNotifier.value.capacity = text;
          break;
        case "introduction":
          valueNotifier.value.introduction = text;
          break;
        case "reward":
          valueNotifier.value.reward = text;
          break;
      }
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      await UserSimplePreference.setpost(
        jsonEncode(PostModel.toMap(valueNotifier.value)),
      );
    });
  }

  //選取tag
  tagPick(int index, String text) async {
    String _type = tagList[index]["type"];
    switch (_type) {
      case "rewardTag":
        int i = (tagList[index]["tag"] as List)
            .indexWhere((e) => e["index"] == text);
        String? rewardTagId = tagList[index]["tag"][i]["id"];
        valueNotifier.value.rewardTagId = rewardTagId;
        break;
      case "tag":
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
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
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
      case "formDate":
        valueNotifier.value.formDateTime = "$dateText/$timeText";
    }
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    valueNotifier.notifyListeners();
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
      return v == null || v == "" || v == "null";
    }

    List _startList = post.startDateTime == null
        ? ["", ""]
        : (post.startDateTime as String).split('/');
    List _endList = post.endDateTime == null
        ? ["", ""]
        : (post.endDateTime as String).split('/');
    List _formList = post.formDateTime == null
        ? ["", ""]
        : (post.formDateTime as String).split('/');

    if (_check(post.photo)) {
      text = '“照片”尚未填寫';
    } else if (_check(post.title)) {
      text = '“活動名稱”尚未填寫';
    } else if (_check(post.capacity)) {
      text = '“不限人數”尚未填寫';
    } else if (_check(post.location)) {
      text = '“活動地點”尚未填寫';
    } else if (_check(_startList[0])) {
      text = '“開始日期”尚未填寫';
    } else if (_check(_startList[1])) {
      text = '“開始時間”尚未填寫';
    } else if (_check(_endList[0])) {
      text = '“結束日期”尚未填寫';
    } else if (_check(_endList[1])) {
      text = '“結束時間”尚未填寫';
    } else if (_check(_formList[0])) {
      text = '“表單截止日期”尚未填寫';
    } else if (_check(_formList[1])) {
      text = '“表單截止時間”尚未填寫';
    } else if (_check(post.introduction)) {
      text = '“活動簡介”尚未填寫';
    } else if (_check(post.content)) {
      text = '“活動詳情”尚未填寫';
    } else if (_check(post.reward)) {
      text = '"活動獎勵"尚未填寫，若無寫“無”';
    }
    return text;
  }
}

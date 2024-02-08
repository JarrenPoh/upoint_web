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
    },
    {
      "title": "活動名額（限阿拉伯數字 如：10,20,30）",
      "index": "capacity",
    },
    {
      "title": "活動地點",
      "index": "location",
    },
    {
      "title": "開始日期",
      "index": "startDate",
    },
    {
      "title": "結束日期",
      "index": "endDate",
    },
    {
      "title": "活動簡介",
      "index": "introduction",
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
    debounce01 = Timer(const Duration(seconds: 1), () async {
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
      }
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      await UserSimplePreference.setpost(
        jsonEncode(PostModel.toMap(valueNotifier.value)),
      );
    });
  }

  //  輸入quill
  Timer? debounce02;
  onQuillChanged(Delta delta) {
    if (debounce02?.isActive ?? false) debounce02!.cancel();
    debounce02 = Timer(const Duration(seconds: 1), () async {
      String json = jsonEncode(delta.toJson());
      valueNotifier.value.content = json;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      await UserSimplePreference.setpost(
        jsonEncode(PostModel.toMap(valueNotifier.value)),
      );
    });
  }

  dateFunc(String text, int index) async {
    String _type = createInformList[index]["index"];
    switch (_type) {
      case "startDate":
        valueNotifier.value.startDate = text;
        break;
      case "endDate":
        valueNotifier.value.endDate = text;
        break;
    }
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    valueNotifier.notifyListeners();
    await UserSimplePreference.setpost(
      jsonEncode(PostModel.toMap(valueNotifier.value)),
    );
  }

  timeFunc(String text, int index) async {
    String _type = createInformList[index]["index"];
    switch (_type) {
      case "startDate":
        valueNotifier.value.startTime = text;
        break;
      case "endDate":
        valueNotifier.value.endTime = text;
        break;
    }
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    valueNotifier.notifyListeners();
    await UserSimplePreference.setpost(
      jsonEncode(PostModel.toMap(valueNotifier.value)),
    );
  }

  //  檢查step1有沒有沒寫完的
  String? checkFunc() {
    PostModel post = valueNotifier.value;
    String? text;
    if (post.photo == null) {
      text = '“照片”尚未填寫';
    } else if (post.title == null) {
      text = '“活動名稱”尚未填寫';
    } else if (post.capacity == null) {
      text = '“不限人數”尚未填寫';
    } else if (post.location == null) {
      text = '“活動地點”尚未填寫';
    } else if (post.startDate == null) {
      text = '“開始日期”尚未填寫';
    } else if (post.startTime == null) {
      text = '“開始時間”尚未填寫';
    } else if (post.endDate == null) {
      text = '“結束日期”尚未填寫';
    } else if (post.endTime == null) {
      text = '“結束時間”尚未填寫';
    }else if (post.introduction == null) {
      text = '“活動簡介”尚未填寫';
    }else if (post.content == null) {
      text = '“活動詳情”尚未填寫';
    }
    return text;
  }
}

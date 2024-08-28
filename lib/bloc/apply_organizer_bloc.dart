import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/models/organizer_model.dart';

import '../firebase/firestore_methods.dart';
import '../firebase/storage_methods.dart';

class ApplyOrganizerBloc {
  String? referralCode;
  ApplyOrganizerBloc(String? _referralCode) {
    referralCode = _referralCode;
    organizer.referralCode = "無";
  }
  OrganizerModel organizer = OrganizerModel(
    uid: FirebaseAuth.instance.currentUser!.uid,
    email: FirebaseAuth.instance.currentUser!.email!,
    myTags: [],
    postLength: 0,
    unit: "中原大學",
    followers: [],
    followersFcm: [],
    actBio: "",
    actLocation: "",
    actTime: "",
    links: [],
  );
  List<Map> commonList = [
    {
      "title": "主辦單位所屬單位",
      "index": "unit",
    },
    {
      "title": "主辦單位名稱",
      "index": "username",
    },
    {
      "title": "主辦單位簡介",
      "index": "bio",
    },
  ];
  List<Map> contactList = [
    {
      "title": "聯絡人姓名",
      "index": "contact",
    },
    {
      "title": "聯絡電話",
      "index": "phoneNumber",
    },
    {
      "title": "Email",
      "index": "email",
    },
  ];
  List<Map> unitList = [
    {
      "title": "主要活動時間",
      "index": "actTime",
    },
    {
      "title": "主要活動舉辦地點",
      "index": "actLocation",
    },
    {
      "title": "主要活動內容介紹",
      "index": "actBio",
    },
  ];

  Timer? debounce01;
  void onTextChanged(String index, String text) {
    if (debounce01?.isActive ?? false) debounce01!.cancel();
    debounce01 = Timer(const Duration(milliseconds: 250), () async {
      switch (index) {
        case "username":
          organizer.username = text;
          break;
        case "bio":
          organizer.bio = text;
          break;
        case "contact":
          organizer.contact = text;
          break;
        case "phoneNumber":
          organizer.phoneNumber = text;
          break;
        case "email":
          organizer.email = text;
          break;
        case "actTime":
          organizer.actTime = text;
          break;
        case "actLocation":
          organizer.actLocation = text;
          break;
        case "actBio":
          organizer.actBio = text;
          break;
      }
      print('organizer:${organizer.toJson()}}');
    });
  }

  Function(String base64Image)? refreshImage;
  // 選照片
  Future<void> pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // 更新 UI
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      // 刷新apply_organizer_avatar_layout
      refreshImage!(base64Image);
      organizer.pic = base64Image;
    }
  }

  bool isEditComplete(BuildContext context) {
    for (String key in organizer.toJson().keys) {
      var value = organizer.toJson()[key];
      if (value == null || value == "") {
        print("value:$key");
        Messenger.dialog(
          "尚有欄位未填寫完畢：'$key'",
          "請檢查所有欄位是否都填寫，如有問題請洽詢：service.upoint@gmail.com",
          context,
        );
        return false;
      }
    }
    return true;
  }

  //送出申請
  Future<String> sendAppply() async {
    String res = "some error occur";
    try {
      // 上傳organizer pic
      Uint8List file = base64Decode(organizer.pic ?? "");
      String ppic = await StorageMethods()
          .uploadImageToStorage('organizers', file, false, null);
      organizer.pic = ppic;
      if (referralCode != null) {
        organizer.referralCode = referralCode;
      }
      // 上傳organizer firestore
      await FirestoreMethods().signUpOrganizerToStore(organizer);
      res = "success";
    } catch (e) {
      res = e.toString();
      print("error message: ${e.toString()}");
    }
    return res;
  }
}

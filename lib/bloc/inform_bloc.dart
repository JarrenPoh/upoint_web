// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/models/organizer_model.dart';

import '../firebase/storage_methods.dart';

class InformBloc {
  ValueNotifier<List<Map>> commonValue = ValueNotifier([]);
  ValueNotifier<List<Map>> contactValue = ValueNotifier([]);
  InformBloc(OrganizerModel organizer) {
    init(organizer);
  }
  ValueNotifier<bool> isEditValue = ValueNotifier(false);
  init(OrganizerModel organizer) {
    commonValue = ValueNotifier([
      {
        "title": "主辦單位所屬單位",
        "index": "unit",
        "value": organizer.unit,
      },
      {
        "title": "主辦單位名稱",
        "index": "username",
        "value": organizer.username,
      },
      {
        "title": "主辦單位簡介",
        "index": "bio",
        "value": organizer.bio,
      },
    ]);
    contactValue = ValueNotifier([
      {
        "title": "聯絡人姓名",
        "index": "contact",
        "value": organizer.contact,
      },
      {
        "title": "聯絡電話",
        "index": "phoneNumber",
        "value": organizer.phoneNumber,
      },
      {
        "title": "Email",
        "index": "email",
        "value": organizer.email,
      },
    ]);
    commonValue.value.forEach((e) {
      initController(e);
    });
    contactValue.value.forEach((e) {
      initController(e);
    });
  }

  initController(Map e) {
    e["controller"] = TextEditingController(text: e["value"]);
    (e["controller"] as TextEditingController).addListener(() {
      if (commonValue.value.any(
        (e) =>
            e["controller"].text != e["value"] ||
            contactValue.value.any(
              (e) => e["controller"].text != e["value"],
            ),
      )) {
        isEditValue.value = true;
      } else {
        isEditValue.value = false;
      }
    });
  }

  Future<String> changeEdit(String uid, BuildContext context) async {
    String res = "some error occur";
    var way = FirebaseFirestore.instance.collection('organizers').doc(uid);
    //上傳
    try {
      commonValue.value.forEach((e) async {
        if (e["value"] != e["controller"].text) {
          await way.update({e["index"]: e["controller"].text});
          e["value"] = e["controller"].text;
        }
      });
      contactValue.value.forEach((e) async {
        if (e["value"] != e["controller"].text) {
          await way.update({e["index"]: e["controller"].text});
          e["value"] = e["controller"].text;
        }
      });
      isEditValue.value = false;
      res = "success";
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      res = e.toString();
      Messenger.snackBar(context, "更改失敗");
    }
    //更新元數據
    return res;
  }

  // File? _image;
  Future<Map> pickImage(OrganizerModel organizer, BuildContext context) async {
    Map res = {};
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Uint8List imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        Uint8List file = base64Decode(base64Image);
        String pic = await StorageMethods()
            .uploadImageToStorage('organizers', file, false, null);
        await FirebaseFirestore.instance
            .collection('organizers')
            .doc(organizer.uid)
            .update({"pic": pic});
        res = {"status": "success", "pic": pic};
      }
    } catch (e) {
      Messenger.snackBar(context, "更換照片失敗");
      debugPrint("error:${e.toString()}");
    }
    return res;
  }
}

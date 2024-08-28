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
  ValueNotifier<List<Map>> unitValue = ValueNotifier([]);
  List<Map<String, String>> originalLinks = []; // 用於保存原始狀態的連結

  InformBloc(OrganizerModel organizer) {
    init(organizer);
  }

  ValueNotifier<bool> isEditValue = ValueNotifier(false);

  void init(OrganizerModel organizer) {
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

    unitValue = ValueNotifier([
      {
        "title": "主要活動時間",
        "index": "actTime",
        "value": organizer.actTime ?? "",
      },
      {
        "title": "主要活動舉辦地點",
        "index": "actLocation",
        "value": organizer.actLocation ?? "",
      },
      {
        "title": "主要活動內容介紹",
        "index": "actBio",
        "value": organizer.actBio ?? "",
      },
      {
        "title": "相關連結",
        "index": "links",
        "value": organizer.links ?? [],
      },
    ]);

    // 保存原始狀態的連結快照
    originalLinks = (organizer.links ?? []).map((link) {
      return {
        "text": link["text"] as String,
        "url": link["url"] as String,
      };
    }).toList();

    commonValue.value.forEach(initController);
    contactValue.value.forEach(initController);
    unitValue.value.forEach(initController);
    // 初始化並監聽 links 中的每個控制器
    for (var link in unitValue.value
        .firstWhere((element) => element['index'] == 'links')['value']) {
      initLinkControllers(link);
    }
  }

  void initController(Map e) {
    if (e["index"] != "links") {
      e["controller"] = TextEditingController(text: e["value"]);
      (e["controller"] as TextEditingController).addListener(() {
        _checkForChanges();
      });
    }
  }

  void initLinkControllers(Map<String, dynamic> link) {
    link["textController"] = TextEditingController(text: link["text"]);
    link["urlController"] = TextEditingController(text: link["url"]);
    link["textController"].addListener(() => _checkForChanges());
    link["urlController"].addListener(() => _checkForChanges());
  }

  void _checkForChanges() {
    bool hasChanges = false;

    for (var item in commonValue.value) {
      if (item["controller"].text != item["value"]) {
        hasChanges = true;
        print("${item["index"]} 有更改");
      }
    }

    for (var item in contactValue.value) {
      if (item["controller"].text != item["value"]) {
        hasChanges = true;
        print("${item["index"]} 有更改");
      }
    }

    for (var item in unitValue.value) {
      if (item["index"] != 'links' &&
          item["controller"].text != item["value"]) {
        hasChanges = true;
        print("${item["index"]} 有更改");
      } else if (item["index"] == 'links') {
        // 比較當前狀態與原始狀態
        if (!_compareWithOriginalState()) {
          hasChanges = true;
        }
      }
    }

    isEditValue.value = hasChanges;
  }

  void addLink({
    required String text,
    required String url,
  }) {
    Map<String, dynamic> newLink = {
      "textController": TextEditingController(text: text),
      "urlController": TextEditingController(text: url),
    };

    unitValue.value
        .firstWhere((element) => element['index'] == 'links')['value']
        .add(newLink);
    print("unitValue: ${unitValue.value}");
    unitValue.notifyListeners();
    isEditValue.value = true;
  }

  void updateLink(
      {required String url, required String text, required int index}) {
    // 找到 `links` 對應的 Map
    List links = unitValue.value
        .firstWhere((element) => element['index'] == 'links')['value'];

    if (index >= 0 && index < links.length) {
      // 同步更新 TextEditingController
      (links[index]['textController'] as TextEditingController).text = text;
      (links[index]['urlController'] as TextEditingController).text = url;
    }
    unitValue.notifyListeners();
    _checkForChanges();
  }

  void removeLink(int index) {
    var links = unitValue.value
        .firstWhere((element) => element['index'] == 'links')['value'];
    links.removeAt(index);
    unitValue.notifyListeners();
    _checkForChanges();
  }

  Future<String> changeEdit(String uid, BuildContext context) async {
    String res = "some error occur";
    var way = FirebaseFirestore.instance.collection('organizers').doc(uid);

    try {
      for (var e in commonValue.value) {
        if (e["value"] != e["controller"].text) {
          await way.update({e["index"]: e["controller"].text});
          e["value"] = e["controller"].text;
        }
      }

      for (var e in contactValue.value) {
        if (e["value"] != e["controller"].text) {
          await way.update({e["index"]: e["controller"].text});
          e["value"] = e["controller"].text;
        }
      }

      for (var e in unitValue.value) {
        if (e["index"] == "links") {
          if (!_compareWithOriginalState()) {
            var linksToUpdate = unitValue.value
                .firstWhere((element) => element['index'] == 'links')['value']
                .map((link) => {
                      "text": link["textController"].text,
                      "url": link["urlController"].text
                    })
                .toList();

            await way.update({"links": linksToUpdate});
            unitValue.value
                .firstWhere((element) => element['index'] == 'links')['value']
                .forEach((link) {
              link["text"] = link["textController"].text;
              link["url"] = link["urlController"].text;
            });
          }
        } else {
          if (e["value"] != e["controller"].text) {
            await way.update({e["index"]: e["controller"].text});
            e["value"] = e["controller"].text;
          }
        }
      }

      isEditValue.value = false;
      res = "success";
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      res = e.toString();
      Messenger.snackBar(context, "更改失敗");
    }

    return res;
  }

  bool _compareWithOriginalState() {
    List currentLinks = unitValue.value
        .firstWhere((element) => element['index'] == 'links')['value'];

    if (currentLinks.length != originalLinks.length) {
      return false;
    }

    for (int i = 0; i < currentLinks.length; i++) {
      if (currentLinks[i]["textController"].text != originalLinks[i]["text"] ||
          currentLinks[i]["urlController"].text != originalLinks[i]["url"]) {
        return false;
      }
    }

    return true;
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

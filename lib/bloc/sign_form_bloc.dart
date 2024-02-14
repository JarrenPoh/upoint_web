import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/firebase/firestore_methods.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/layouts/sign_form_finish_layout.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/models/user_model.dart';

class SignFormBloc {
  SignFormBloc(String postId) {
    fetchForm(postId);
  }
  final ValueNotifier<Map> postValueNotifier = ValueNotifier({
    "post": null,
    "isLoading": true,
    "isForm": false,
    "form": null,
  });

  fetchForm(String postId) async {
    try {
      if (postId == "") {
        postId = "error";
      }
      DocumentSnapshot? fetchPost = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();
      print('找了1則貼文，拿出它的表單');
      PostModel? _post =
          fetchPost.exists == false ? null : PostModel.fromSnap(fetchPost);
      String? _form = _post?.form;
      if (_form == null || _form.substring(0, 4) == 'http') {
        postValueNotifier.value["isForm"] = false;
      } else {
        List<FormModel> formModel = (jsonDecode(_form) as List)
            .map((e) => FormModel.fromMap(e))
            .toList();
        formModel.first.options.insertAll(0, fixCommon);
        postValueNotifier.value["isForm"] = true;
        postValueNotifier.value["form"] = formModel;
        if (UserSimplePreference.getSignForm() == "")
          await _firstSignForm(formModel);
      }
      postValueNotifier.value["post"] = _post;
      postValueNotifier.value["isLoading"] = false;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      postValueNotifier.notifyListeners();
    } catch (e) {
      print('error:$e');
    }
  }

  Future _firstSignForm(List<FormModel> formModel) async {
    List<Map> _list = [];
    for (var form in formModel)
      // ignore: curly_braces_in_flow_control_structures
      for (var option in form.options) {
        _list.add({
          "subtitle": option.subtitle,
          "value": "",
        });
      }
    UserSimplePreference.setSignForm(jsonEncode(_list));
  }

  // longField 的 textChanged
  onLongFieldChanged(String text, int index) {
    List _signForm = [];
    if (UserSimplePreference.getSignForm() != "") {
      _signForm = jsonDecode(UserSimplePreference.getSignForm());
    }
    _signForm[index]["value"] = text;
    UserSimplePreference.setSignForm(jsonEncode(_signForm));
  }

  // shortField 的 textChanged
  onShortFieldChanged(List list, int index) {
    List _signForm = [];
    if (UserSimplePreference.getSignForm() != "") {
      _signForm = jsonDecode(UserSimplePreference.getSignForm());
    }
    _signForm[index]["value"] = list;
    UserSimplePreference.setSignForm(jsonEncode(_signForm));
  }

  String? checkFunc(List<FormModel> formList) {
    String? _errorText;
    List _signForm = jsonDecode(UserSimplePreference.getSignForm());
    var _i = 0;
    for (var form in formList) {
      for (var option in form.options) {
        if (option.necessary == true && _signForm[_i]["value"] == "") {
          _errorText = "${_signForm[_i]["subtitle"]}是必填欄位";
          break;
        }
        _i++;
      }
    }
    return _errorText;
  }

  confirmSend(UserModel user, String postId, BuildContext context) async {
    print('傳送報名表單');
    String res = await FirestoreMethods().uploadSignForm(user, postId);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignFormFinishLayout(
          user: user,
          res: res,
        ),
      ),
    );
  }

  List<OptionModel> fixCommon = [
    OptionModel(
      type: "username",
      subtitle: "姓名",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
    OptionModel(
      type: "phoneNumber",
      subtitle: "聯絡電話",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
    OptionModel(
      type: "email",
      subtitle: "email",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
  ];
}

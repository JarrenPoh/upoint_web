import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/form_model.dart';

class UserSimplePreference {
  static SharedPreferences? _preferences;

  static const _post = 'post';
  static const _form = 'form';
  static const _signForm = 'signForm';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //organizer create post
  static Future setpost(String post) async {
    debugPrint('存：$post');
    await _preferences?.setString(_post, post);
  }

  static Future removepost() async {
    await _preferences?.remove(_post);
  }

  static String getpost() {
    return _preferences?.getString(_post) ?? "";
  }

  //organizer create form
  static Future setform(String form) async {
    debugPrint('存：$form');
    await _preferences?.setString(_form, form);
  }

  static Future removeform() async {
    await _preferences?.remove(_form);
  }

  static String getform() {
    return _preferences?.getString(_form) ??
        jsonEncode([FormModel(title: "基本資料", options: [])]
            .map((form) => form.toJson())
            .toList());
  }

  //user sign form
  static Future setSignForm(String signForm) async {
    debugPrint('存：$signForm');
    await _preferences?.setString(_signForm, signForm);
  }

  static Future removeSignForm() async {
    await _preferences?.remove(_signForm);
  }

  static String getSignForm() {
    return _preferences?.getString(_signForm) ?? "";
  }
}

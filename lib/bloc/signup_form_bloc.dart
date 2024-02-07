import 'package:flutter/material.dart';
import 'package:upoint_web/models/form_model.dart';

class SignUpFormBloc {
  final ValueNotifier<List<FormModel>> valueNotifier =
      ValueNotifier([FormModel(title: "基本資料", options: [])]);
}

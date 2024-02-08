import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_2_bloc.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_left_layout.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_right_layout.dart';

class CreateStep2Layout extends StatelessWidget {
  CreateStep2Layout({super.key});
  final String getForm = UserSimplePreference.getform();

  @override
  Widget build(BuildContext context) {
    final CreateStep2Bloc _bloc = CreateStep2Bloc(getForm.isEmpty
        ? [FormModel(title: "基本資料", options: [])]
        : (jsonDecode(getForm) as List)
            .map((jsonItem) => FormModel.fromMap(jsonItem))
            .toList());
    return ResponsiveLayout(
      tabletLayout: tabletLayout(_bloc),
      webLayout: webLayout(_bloc),
    );
  }

  Widget tabletLayout(CreateStep2Bloc _bloc) {
    print('切換到 tabletLayout');
    return CreatePage(
      isWeb: false,
      step: 2,
      checkFunc: () {},
      child: Column(
        children: [
          //左邊區塊
          CreateStep2LeftLayout(bloc: _bloc),
          //右邊區塊
          CreateStep2RightLayout(bloc: _bloc)
        ],
      ),
    );
  }

  Widget webLayout(CreateStep2Bloc _bloc) {
    print('切換到 desktopLayout');
    return CreatePage(
      isWeb: true,
      step: 2,
      checkFunc: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //左邊區塊
          CreateStep2LeftLayout(bloc: _bloc),
          const SizedBox(width: 24),
          //右邊區塊
          CreateStep2RightLayout(bloc: _bloc)
        ],
      ),
    );
  }
}

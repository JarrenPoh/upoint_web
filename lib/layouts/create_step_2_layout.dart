import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_2_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_pick_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_left_layout.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_right_layout.dart';

class CreateStep2Layout extends StatelessWidget {
  CreateStep2Layout({
    super.key,
    required this.organizer,
    required this.jumpToPage,
  });
  final String getForm = UserSimplePreference.getform();
  final Function(int) jumpToPage;

  final OrganizerModel organizer;
  @override
  Widget build(BuildContext context) {
    final CreateStep2Bloc _bloc = CreateStep2Bloc(getForm.isEmpty
        ? [FormModel(title: "基本資料", options: [])]
        : (jsonDecode(getForm) as List)
            .map((jsonItem) => FormModel.fromMap(jsonItem))
            .toList());
    return ResponsiveLayout(
      tabletLayout: tabletLayout(context, _bloc),
      webLayout: webLayout(context, _bloc),
    );
  }

  Widget tabletLayout(BuildContext context, CreateStep2Bloc _bloc) {
    print('切換到 tabletLayout');
    Widget formWidget = Column(
      children: [
        //左邊區塊
        CreateStep2LeftLayout(bloc: _bloc.createFormBloc),
        const SizedBox(height: 20),
        //右邊區塊
        CreateStep2RightLayout(bloc: _bloc.createFormBloc)
      ],
    );
    return CreatePage(
      isWeb: false,
      step: 2,
      nextStep: () => nextStep(context, _bloc),
      jumpToPage: jumpToPage,
      child: CreateStep2PickLayout(
        bloc: _bloc,
        child: formWidget,
      ),
    );
  }

  Widget webLayout(BuildContext context, CreateStep2Bloc _bloc) {
    print('切換到 desktopLayout');
    Widget formWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //左邊區塊
        CreateStep2LeftLayout(bloc: _bloc.createFormBloc),
        const SizedBox(width: 24),
        //右邊區塊
        CreateStep2RightLayout(bloc: _bloc.createFormBloc)
      ],
    );
    return CreatePage(
      isWeb: true,
      step: 2,
      nextStep: () => nextStep(context, _bloc),
      jumpToPage: jumpToPage,
      child: CreateStep2PickLayout(
        bloc: _bloc,
        child: formWidget,
      ),
    );
  }

  nextStep(BuildContext context, CreateStep2Bloc _bloc) {
    String? errorText = _bloc.checkFunc();
    if (errorText != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: MediumText(
              color: grey400,
              size: 16,
              text: "有欄位尚未填寫完畢",
            ),
            content: MediumText(
              color: grey500,
              size: 20,
              text: errorText,
            ),
            actions: <Widget>[
              TextButton(
                child: MediumText(
                  color: grey500,
                  size: 16,
                  text: "確定",
                ),
                onPressed: () {
                  // ... 执行删除操作
                  Navigator.of(context).pop(true); //关闭对话框
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: MediumText(
              color: grey400,
              size: 16,
              text: "提示",
            ),
            content: MediumText(
              color: grey500,
              size: 20,
              text: "確定發送嗎",
            ),
            actions: <Widget>[
              TextButton(
                child: MediumText(
                  color: grey500,
                  size: 16,
                  text: "確定",
                ),
                onPressed: () =>
                    _bloc.confirmSend(context, organizer, jumpToPage),
              ),
            ],
          );
        },
      );
    }
  }
}

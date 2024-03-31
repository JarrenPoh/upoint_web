import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_2_bloc.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_pick_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_left_layout.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_right_layout.dart';

class CreateStep2Layout extends StatefulWidget {
  const CreateStep2Layout({
    super.key,
    required this.organizer,
    required this.jumpToPage,
  });
  final Function(int) jumpToPage;

  final OrganizerModel organizer;

  @override
  State<CreateStep2Layout> createState() => _CreateStep2LayoutState();
}

class _CreateStep2LayoutState extends State<CreateStep2Layout> {
  @override
  void initState() {
    super.initState();
  }

  final String getForm = UserSimplePreference.getform();

  @override
  Widget build(BuildContext context) {
    final CreateStep2Bloc _bloc = CreateStep2Bloc((jsonDecode(getForm) as List)
        .map((jsonItem) => FormModel.fromMap(jsonItem))
        .toList());
    return ResponsiveLayout(
      tabletLayout: tabletLayout(context, _bloc),
      webLayout: webLayout(context, _bloc),
    );
  }

  Widget tabletLayout(BuildContext context, CreateStep2Bloc _bloc) {
    debugPrint('切換到 tabletLayout');
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
      jumpToPage: widget.jumpToPage,
      child: CreateStep2PickLayout(
        bloc: _bloc,
        child: formWidget,
        isWeb: false,
      ),
    );
  }

  Widget webLayout(BuildContext context, CreateStep2Bloc _bloc) {
    debugPrint('切換到 desktopLayout');
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
      jumpToPage: widget.jumpToPage,
      child: CreateStep2PickLayout(
        bloc: _bloc,
        child: formWidget,
        isWeb: true,
      ),
    );
  }

  nextStep(BuildContext context, CreateStep2Bloc _bloc) async {
    String? errorText = _bloc.checkFunc();
    if (errorText != null) {
      Messenger.dialog("有欄位尚未填寫完畢", errorText, context);
    } else {
      String res = await Messenger.dialog(
        "提示",
        "確定發送嗎",
        context,
      );
      if (res == "success") {
        _bloc.confirmSend(context, widget.organizer, widget.jumpToPage);
      }
    }
  }
}

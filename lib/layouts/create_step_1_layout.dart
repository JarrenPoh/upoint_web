import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_1_bloc.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/create_step_1/create_step_1_body_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

import '../globals/custom_messengers.dart';

class CreateStep1Layout extends StatelessWidget {
  final OrganizerModel organizer;
  final Function(int) jumpToPage;
  const CreateStep1Layout({
    super.key,
    required this.organizer,
    required this.jumpToPage,
  });
  @override
  Widget build(BuildContext context) {
    String getPost = UserSimplePreference.getpost();
    final CreateStep1Bloc _bloc = CreateStep1Bloc(
      getPost.isEmpty
          ? PostModel(tags: [],postType: "演講講座")
          : PostModel.fromMap(jsonDecode(getPost)),
    );

    return ResponsiveLayout(
      tabletLayout: tabletLayout(_bloc, context),
      webLayout: webLayout(_bloc, context),
    );
  }

  Widget tabletLayout(
    CreateStep1Bloc _bloc,
    BuildContext context,
  ) {
    return CreatePage(
      isWeb: false,
      step: 1,
      nextStep: () => nextStep(context, _bloc),
      child: CreateStep1BodyLayout(isWeb: false, bloc: _bloc),
    );
  }

  Widget webLayout(
    CreateStep1Bloc _bloc,
    BuildContext context,
  ) {
    return CreatePage(
      isWeb: true,
      step: 1,
      nextStep: () => nextStep(context, _bloc),
      child: CreateStep1BodyLayout(isWeb: true, bloc: _bloc),
    );
  }

  nextStep(BuildContext context, CreateStep1Bloc _bloc) {
    String? errorText = _bloc.checkFunc();
    if (errorText != null) {
      Messenger.dialog("有欄位尚未填寫完畢", errorText, context);
    } else {
      jumpToPage(1);
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_1_bloc.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/create_step_1/create_step_1_body_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

class CreateStep1Layout extends StatelessWidget {
  const CreateStep1Layout({super.key});
  @override
  Widget build(BuildContext context) {
    String getPost = UserSimplePreference.getpost();
    final CreateStep1Bloc _bloc = CreateStep1Bloc(
      getPost.isEmpty ? PostModel() : PostModel.fromMap(jsonDecode(getPost)),
    );
    return ResponsiveLayout(
      tabletLayout: tabletLayout(_bloc),
      webLayout: webLayout(_bloc),
    );
  }

  Widget tabletLayout(CreateStep1Bloc _bloc) {
    return CreatePage(
      isWeb: false,
      step: 1,
      addToGlobal: () {},
      child: CreateStep1BodyLayout(isWeb: false, bloc: _bloc),
    );
  }

  Widget webLayout(CreateStep1Bloc _bloc) {
    return CreatePage(
      isWeb: true,
      step: 1,
      addToGlobal: () {},
      child: CreateStep1BodyLayout(isWeb: true, bloc: _bloc),
    );
  }
}

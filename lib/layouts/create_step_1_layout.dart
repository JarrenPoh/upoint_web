import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_1_bloc.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/create_step_1/create_step_1_body_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

class CreateStep1Layout extends StatelessWidget {
  CreateStep1Layout({super.key});
  final CreateStep1Bloc _bloc = CreateStep1Bloc();
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(),
      webLayout: webLayout(),
    );
  }

  Widget tabletLayout() {
    return CreatePage(
      isWeb: false,
      step: 1,
      child: CreateStep1BodyLayout(isWeb: false, bloc: _bloc),
    );
  }

  Widget webLayout() {
    return CreatePage(
      isWeb: true,
      step: 1,
      child: CreateStep1BodyLayout(isWeb: true, bloc: _bloc),
    );
  }
}

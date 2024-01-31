import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_2_bloc.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_left_layout.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_right_layout.dart';

class CreateStep2Layout extends StatelessWidget {
  CreateStep2Layout({super.key});

  final CreateStep2Bloc _bloc = CreateStep2Bloc();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(),
      webLayout: webLayout(),
    );
  }

  Widget tabletLayout() {
    print('切換到 tabletLayout');
    return CreatePage(
      isWeb: false,
      step: 2,
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

  Widget webLayout() {
    print('切換到 desktopLayout');
    return CreatePage(
      isWeb: true,
      step: 2,
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

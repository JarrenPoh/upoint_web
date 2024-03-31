import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/apply_organizer_bloc.dart';
import 'package:upoint_web/pages/apply_organizer_page.dart';
import 'package:upoint_web/widgets/apply_organizer/apply_organizer_avatar_layout.dart';
import 'package:upoint_web/widgets/apply_organizer/apply_organizer_common_layout.dart';
import 'package:upoint_web/widgets/apply_organizer/apply_organizer_contact_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

class ApplyLayout extends StatelessWidget {
  ApplyLayout({super.key});
  final ApplyOrganizerBloc bloc = ApplyOrganizerBloc();
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(),
      webLayout: webLayout(),
    );
  }

  Widget tabletLayout() {
    return ApplyOrganizerPage(
      isWeb: false,
      bloc: bloc,
      child: Column(
        children: [
          //頭像
          Row(
            children: [
              _avaterLayout(),
            ],
          ),
          const SizedBox(height: 30),
          //基本資料
          _commonLayout(false),
          const SizedBox(height: 30),
          //第二列
          _contactLayout(false),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget webLayout() {
    return ApplyOrganizerPage(
      isWeb: true,
      bloc: bloc,
      child: Column(
        children: [
          Row(
            children: [
              //頭像
              _avaterLayout(),
              const SizedBox(width: 37),
              //基本資料
              Expanded(
                child: _commonLayout(true),
              )
            ],
          ),
          const SizedBox(height: 57),
          //第二列
          _contactLayout(true),
          const SizedBox(height: 96),
        ],
      ),
    );
  }

  Widget _avaterLayout() {
    return ApplyOrganizerAvatarLayout(bloc: bloc);
  }

  Widget _commonLayout(bool isWeb) {
    return ApplyOrganizerCommonLayout(isWeb: isWeb, bloc: bloc);
  }

  Widget _contactLayout(bool isWeb) {
    return ApplyOrganizerContactLayout(isWeb: isWeb, bloc: bloc);
  }
}

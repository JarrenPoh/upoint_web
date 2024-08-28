import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/apply_organizer_bloc.dart';
import 'package:upoint_web/pages/apply_organizer_page.dart';
import 'package:upoint_web/widgets/apply_organizer/apply_organizer_avatar_layout.dart';
import 'package:upoint_web/widgets/apply_organizer/apply_organizer_common_layout.dart';
import 'package:upoint_web/widgets/apply_organizer/apply_organizer_contact_layout.dart';
import 'package:upoint_web/widgets/apply_organizer/apply_organizer_unit_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

class ApplyLayout extends StatefulWidget {
  ApplyLayout({
    super.key,
    required this.referralCode,
  });
  final String? referralCode;

  @override
  State<ApplyLayout> createState() => _ApplyLayoutState();
}

class _ApplyLayoutState extends State<ApplyLayout> {
  late ApplyOrganizerBloc bloc = ApplyOrganizerBloc(widget.referralCode);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: mobileLayout(),
      tabletLayout: tabletLayout(),
      webLayout: webLayout(),
    );
  }

  Widget mobileLayout() {
    return ApplyOrganizerPage(
      layoutType: LayoutType.mobile,
      bloc: bloc,
      child: Column(
        children: [
          //頭像
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _avaterLayout(),
            ],
          ),
          const SizedBox(height: 30),
          //基本資料
          _commonLayout(false),
          const SizedBox(height: 30),
          // 單位資料
          _unitLayout(true),
          const SizedBox(height: 30),
          //第二列
          _contactLayout(false),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget tabletLayout() {
    return ApplyOrganizerPage(
      layoutType: LayoutType.tablet,
      bloc: bloc,
      child: Column(
        children: [
          //頭像
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _avaterLayout(),
            ],
          ),
          const SizedBox(height: 30),
          //基本資料
          _commonLayout(false),
          const SizedBox(height: 30),
          // 單位資料
          _unitLayout(true),
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
      layoutType: LayoutType.web,
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
          _unitLayout(true),
          //第二列
          const SizedBox(height: 57),
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

  Widget _unitLayout(bool isWeb) {
    return ApplyOrganizerUnitLayout(bloc: bloc, isWeb: isWeb);
  }

  Widget _contactLayout(bool isWeb) {
    return ApplyOrganizerContactLayout(isWeb: isWeb, bloc: bloc);
  }
}

import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/inform_bloc.dart';
import 'package:upoint_web/pages/inform_page.dart';
import 'package:upoint_web/widgets/inform/inform_avatar_layout.dart';
import 'package:upoint_web/widgets/inform/inform_common_layout.dart';
import 'package:upoint_web/widgets/inform/inform_contact_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

class InformLayout extends StatelessWidget {
  InformLayout({super.key});
  final InformBloc _bloc = InformBloc();
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(),
      webLayout: webLayout(),
    );
  }

  Widget tabletLayout() {
    return InformPage(
      isWeb: false,
      bloc: _bloc,
      child: Column(
        children: [
          //頭像
          const Row(
            children: [
              InformAvatarLayout(),
            ],
          ),
          const SizedBox(height: 30),
          //基本資料
          InformCommonLayout(
            list: _bloc.commonList,
            isWeb: false,
          ),
          const SizedBox(height: 30),
          //第二列
          InformContactLayout(
            list: _bloc.contactList,
            isWeb: false,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget webLayout() {
    return InformPage(
      isWeb: true,
      bloc: _bloc,
      child: Column(
        children: [
          Row(
            children: [
              //頭像
              const InformAvatarLayout(),
              const SizedBox(width: 37),
              //基本資料
              Expanded(
                child: InformCommonLayout(
                  list: _bloc.commonList,
                  isWeb: true,
                ),
              )
            ],
          ),
          const SizedBox(height: 57),
          //第二列
          InformContactLayout(
            list: _bloc.contactList,
            isWeb: true,
          ),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}

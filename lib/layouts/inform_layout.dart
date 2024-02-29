import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/inform_bloc.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/pages/inform_page.dart';
import 'package:upoint_web/widgets/inform/inform_avatar_layout.dart';
import 'package:upoint_web/widgets/inform/inform_common_layout.dart';
import 'package:upoint_web/widgets/inform/inform_contact_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

class InformLayout extends StatelessWidget {
  final OrganizerModel organizer;
  InformLayout({
    super.key,
    required this.organizer,
  });
  late final InformBloc _bloc = InformBloc(organizer);
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(),
      webLayout: webLayout(),
    );
  }

  Widget tabletLayout() {
    return InformPage(
      organizer: organizer,
      isWeb: false,
      bloc: _bloc,
      child: Column(
        children: [
          //頭像
          Row(
            children: [
              InformAvatarLayout(organizer: organizer, bloc: _bloc),
            ],
          ),
          const SizedBox(height: 30),
          //基本資料
          InformCommonLayout(
            bloc: _bloc,
            isWeb: false,
          ),
          const SizedBox(height: 30),
          //第二列
          InformContactLayout(
            bloc: _bloc,
            isWeb: false,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget webLayout() {
    return InformPage(
      organizer: organizer,
      isWeb: true,
      bloc: _bloc,
      child: Column(
        children: [
          Row(
            children: [
              //頭像
              InformAvatarLayout(organizer: organizer, bloc: _bloc),
              const SizedBox(width: 37),
              //基本資料
              Expanded(
                child: InformCommonLayout(
                  bloc: _bloc,
                  isWeb: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 57),
          //第二列
          InformContactLayout(
            bloc: _bloc,
            isWeb: false,
          ),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}

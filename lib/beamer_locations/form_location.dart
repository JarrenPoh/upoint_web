// ignore_for_file: invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/layouts/signup_form_layout.dart';
import 'package:upoint_web/widgets/custom_navigation_bar.dart';

class FormLocation extends BeamLocation {
  List<String> get pathBlueprints => [
        '/form',
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    var screenSize = MediaQuery.of(context).size;

    Widget page = const Center(child: Text("page not found"));
    Uri uri = state.toRouteInformation().uri;
    print('uri: $uri');
    final id = uri.queryParameters['id'];
    print('id: $id');
    // 根据id决定显示哪个页面
    if (id != null) {
      // 假设你有一个根据id来显示表单内容的Widget
      page = SignUpFormLayout();
    }

    return [
      BeamPage(
        key: ValueKey(uri),
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: PreferredSize(
            preferredSize: Size(screenSize.width, 80),
            child: CustomNavigationBar(
              onIconTapped: () {},
              isForm: true,
            ),
          ),
          body: page,
        ),
      )
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBlueprints;
}

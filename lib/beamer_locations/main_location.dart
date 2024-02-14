// ignore_for_file: invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';

class MainLocation extends BeamLocation {
  List<String> get pathBlueprints => [
        '/main',
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    var screenSize = MediaQuery.of(context).size;

    Widget page = const Center(child: Text("page not found"));
    Uri uri = state.toRouteInformation().uri;
    print('uri: $uri');
    // if (uri.pathSegments.contains('inform')) {
    //   page =  InformLayout();
    // } else if (uri.pathSegments.contains('center')) {
    //   page = Container();
    // } else if (uri.pathSegments.contains('create')) {
    //   String step = uri.pathSegments[2];
    //   // final step = state.pathParameters['step'] ?? '0';
    //   switch (step) {
    //     case 'step1':
    //       page =  CreateStep1Layout();
    //       break;
    //     case 'step2':
    //       page = CreateStep2Layout();
    //       break;
    //   }
    // }
    return [
      BeamPage(
        key: ValueKey(uri),
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: PreferredSize(
            preferredSize: Size(screenSize.width, 80),
            child: Container()
          ),
          body: SingleChildScrollView(child: page),
        ),
      )
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBlueprints;
}


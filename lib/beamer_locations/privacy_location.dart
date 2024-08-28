// ignore_for_file: invalid_use_of_protected_member
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../privacy_page.dart';

class PrivacyLocation extends BeamLocation {
  List<String> get pathBlueprints => [
        '/privacy',
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    // var screenSize = MediaQuery.of(context).size;
    // Widget page = const Center(child: Text("page not found"));
    Uri uri = state.toRouteInformation().uri;
    debugPrint('uri: $uri');

    return [
      BeamPage(
        key: ValueKey(uri),
        child: PrivacyPage(),
      )
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBlueprints;
}

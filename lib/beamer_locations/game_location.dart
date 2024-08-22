// ignore_for_file: invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/games/game_page.dart';

class GameLocation extends BeamLocation {
  List<String> get pathBlueprints => [
        '/game',
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
        child: GamePage(
          centerX: MediaQuery.of(context).size.width / 2,
          centerY: MediaQuery.of(context).size.height * 3 / 5,
        ),
      )
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBlueprints;
}

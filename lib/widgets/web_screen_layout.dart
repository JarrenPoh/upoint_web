import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/beamer_locations/main_location.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/widgets/custom_navigation_bar.dart';

class WebScreenLayout extends StatefulWidget {
  final int initialPage;
  const WebScreenLayout({
    super.key,
    required this.initialPage,
  });

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int currentStep = 1;
  void onIconTapped(int index) {
    String url = '';
    if (index == 0) {
      url = "/inform";
    } else if (index == 1) {
      url = "/center";
    } else {
      url = "/create/step$currentStep";
    }
    _beamerKey.currentState?.routerDelegate.beamToNamed(url);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _beamerKey = GlobalKey<BeamerState>();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 80),
        child: CustomNavigationBar(
          onIconTapped: onIconTapped,
        ),
      ),
      body: Beamer(
        key: _beamerKey,
        routerDelegate: BeamerDelegate(
          locationBuilder: BeamerLocationBuilder(
            beamLocations: [
              MainLocation(),
            ],
          ),
        ),
      ),
    );
  }
}

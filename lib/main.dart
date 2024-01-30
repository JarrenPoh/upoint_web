import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/beamer_locations/main_location.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/secret.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseApiKey,
      appId: firebaseAppId,
      messagingSenderId: firebaseMessagingSenderId,
      projectId: firebaseProjectId,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        unselectedWidgetColor: grey300,
        primaryColor: grey500,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: grey500,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: BeamerParser(),
      routerDelegate: BeamerDelegate(
        initialPath: '/main/form',
        transitionDelegate: const NoAnimationTransitionDelegate(),
        locationBuilder: BeamerLocationBuilder(
          beamLocations: [
            MainLocation(),
          ],
        ),
      ),
    );
  }
}

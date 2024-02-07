import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/layouts/create_step_1_layout.dart';
import 'package:upoint_web/layouts/create_step_2_layout.dart';
import 'package:upoint_web/layouts/inform_layout.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/pages/login_page.dart';
import 'package:upoint_web/widgets/custom_navigation_bar.dart';

class OrganizerLocation extends BeamLocation {
  List<String> get pathBlueprints => [
        '/organizer/inform',
        '/organizer/center',
        '/organizer/create/step1',
        '/organizer/create/step2',
      ];
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    var screenSize = MediaQuery.of(context).size;
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
      Beamer.of(context).beamToNamed('/organizer' + url);
    }

    Widget page = const Center(child: Text("page not found"));
    Uri uri = state.toRouteInformation().uri;
    if (uri.pathSegments.contains('inform')) {
      page = InformLayout();
    } else if (uri.pathSegments.contains('center')) {
      page = Container();
    } else if (uri.pathSegments.contains('create')) {
      String step = uri.pathSegments[2];
      // final step = state.pathParameters['step'] ?? '0';
      switch (step) {
        case 'step1':
          page = CreateStep1Layout(
          );
          break;
        case 'step2':
          page = CreateStep2Layout(
          );
          break;
      }
    }
    return [
      BeamPage(
        key: ValueKey(uri),
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: PreferredSize(
            preferredSize: Size(screenSize.width, 80),
            child: CustomNavigationBar(
              onIconTapped: onIconTapped,
              isForm: false,
            ),
          ),
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (snapshot.hasData) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('organizers')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      OrganizerModel? organizer =
                          OrganizerModel.fromMap(snapshot.data?.data());
                      if (organizer == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MediumText(
                                color: grey500,
                                size: 18,
                                text: "非常抱歉，此帳號似乎並非官方核准的主辦方帳號",
                              ),
                              MediumText(
                                color: grey500,
                                size: 18,
                                text:
                                    "如想加入UPoint活動主辦方，請洽詢service.upoint@gmail.com",
                              ),
                            ],
                          ),
                        );
                      } else {
                        return page;
                      }
                    }
                  },
                );
              } else if (snapshot.hasError) {
                print('firebase authState error');
                return Center(child: Text('${snapshot.error}'));
              } else {
                return const Center(child: LoginPage(role: "organizer"));
              }
            },
          ),
        ),
      )
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBlueprints;
}

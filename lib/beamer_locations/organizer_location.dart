import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/firebase/auth_methods.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/layouts/center_layout.dart';
import 'package:upoint_web/layouts/create_step_1_layout.dart';
import 'package:upoint_web/layouts/create_step_2_layout.dart';
import 'package:upoint_web/layouts/create_step_3_layout.dart';
import 'package:upoint_web/layouts/inform_layout.dart';
import 'package:upoint_web/layouts/login_layout.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/widgets/custom_navigation_bar.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

import '../layouts/center_post_layout.dart';
import '../layouts/center_sign_form_layout.dart';

class OrganizerLocation extends BeamLocation {
  List<String> get pathBluedebugPrints => [
        '/organizer',
        '/organizer/inform',
        '/organizer/center',
        '/organizer/center/post',
        '/organizer/center/signForm',
        '/organizer/create',
      ];
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    var screenSize = MediaQuery.of(context).size;
    void onIconTapped(int index) {
      String url = '';
      if (index == 0) {
        url = "/inform";
      } else if (index == 1) {
        url = "/center";
      } else {
        url = "/create";
      }
      Beamer.of(context).beamToNamed('/organizer$url');
    }

    Widget Function(OrganizerModel) page =
        (o) => const Center(child: Text("page not found"));
    Uri uri = state.toRouteInformation().uri;
    if (uri.pathSegments.length == 1 && uri.pathSegments.first == 'organizer') {
      Beamer.of(context).beamToNamed('/organizer/inform');
      return []; // Return an empty list as beamToNamed will handle navigation
    }
    if (uri.pathSegments.contains('inform')) {
      // 個人簡介
      page = (o) => InformLayout(organizer: o);
    } else if (uri.pathSegments.contains('post')) {
      // 活動中心點進去的貼文頁面
      final id = uri.queryParameters['id'];
      debugPrint('id:$id');
      if (id != null) {
        page = (o) => CenterPostLayout(
              organizer: o,
              postId: id,
            );
      } else {
        page = (u) => const Center(child: Text("Page not found"));
      }
    } else if (uri.pathSegments.contains('signForm')) {
      // 貼文的報名資訊
      final id = uri.queryParameters['id'];
      debugPrint('id:$id');
      if (id != null) {
        page = (o) => CenterSignFormLayout(
              organizer: o,
              postId: id,
            );
      } else {
        page = (u) => const Center(child: Text("Page not found"));
      }
    } else if (uri.pathSegments.contains('center')) {
      // 活動中心
      page = (o) => CenterLayout(organizer: o);
    } else if (uri.pathSegments.contains('create')) {
      //創建列表頁面
      final PageController _controller = PageController();
      jumpToPage(int i) {
        _controller.jumpToPage(i);
      }

      page = (o) => PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CreateStep1Layout(
                organizer: o,
                jumpToPage: jumpToPage,
              ),
              CreateStep2Layout(
                organizer: o,
                jumpToPage: jumpToPage,
              ),
              CreateStep3Layout(
                organizer: o,
                jumpToPage: jumpToPage,
              ),
            ],
          );
    }
    return [
      BeamPage(
        key: ValueKey(uri),
        child: Scaffold(
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
                      debugPrint('拿了身份：${organizer?.toJson()}');
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
                              const SizedBox(height: 15),
                              SizedBox(
                                width: 150,
                                child: TapHoverContainer(
                                  text: "登出",
                                  padding: 15,
                                  hoverColor: secondColor,
                                  borderColor: Colors.transparent,
                                  textColor: Colors.white,
                                  color: primaryColor,
                                  onTap: () => AuthMethods().signOut(),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Scaffold(
                          backgroundColor: bgColor,
                          appBar: PreferredSize(
                            preferredSize: Size(screenSize.width, 80),
                            child: CustomNavigationBar(
                              onIconTapped: onIconTapped,
                              organizer: organizer,
                              isForm: false,
                            ),
                          ),
                          body: page(organizer),
                        );
                      }
                    }
                  },
                );
              } else if (snapshot.hasError) {
                debugPrint('firebase authState error');
                return Center(child: Text('${snapshot.error}'));
              } else {
                return Center(child: LoginLayout(role: "organizer"));
              }
            },
          ),
        ),
      )
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBluedebugPrints;
}

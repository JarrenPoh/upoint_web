import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/firebase/auth_methods.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/layouts/apply_organizer_layout.dart';
import 'package:upoint_web/layouts/center_layout.dart';
import 'package:upoint_web/layouts/create_step_1_layout.dart';
import 'package:upoint_web/layouts/create_step_2_layout.dart';
import 'package:upoint_web/layouts/create_step_3_layout.dart';
import 'package:upoint_web/layouts/inform_layout.dart';
import 'package:upoint_web/layouts/login_layout.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/pages/email_verified_page.dart';
import 'package:upoint_web/widgets/circular_loading.dart';
import 'package:upoint_web/widgets/custom_navigation_bar.dart';
import '../layouts/center_post_layout.dart';
import '../layouts/center_sign_form_layout.dart';
import '../widgets/tap_hover_container.dart';

class OrganizerLocation extends BeamLocation {
  final GlobalKey<CustomNavigationBarState> _navBarKey =
      GlobalKey<CustomNavigationBarState>();
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

    Widget Function(OrganizerModel?) page =
        (o) => const Center(child: Text("page not found"));
    Uri uri = state.toRouteInformation().uri;
    if (uri.pathSegments.length == 1 && uri.pathSegments.first == 'organizer') {
      Beamer.of(context).beamToNamed('/organizer/inform');
    }
    if (uri.pathSegments.contains('inform')) {
      // 個人簡介
      String? referralCode = uri.queryParameters['rc'];
      debugPrint("推薦碼：$referralCode");
      page = (o) => o == null
          ? ApplyLayout(referralCode: referralCode)
          : InformLayout(organizer: o);
    } else if (uri.pathSegments.contains('post')) {
      // 活動中心點進去的貼文頁面
      final id = uri.queryParameters['id'];
      if (id != null) {
        page = (o) => o == null
            ? notOrganizerText(context)
            : CenterPostLayout(
                organizer: o,
                postId: id,
              );
      } else {
        page = (u) => const Center(child: Text("Page not found"));
      }
    } else if (uri.pathSegments.contains('signForm')) {
      // 貼文的報名資訊
      final id = uri.queryParameters['id'];
      if (id != null) {
        page = (o) =>
            o == null ? notOrganizerText(context) : centerSignFormLayout(o, id);
      } else {
        page = (u) => const Center(child: Text("Page not found"));
      }
    } else if (uri.pathSegments.contains('center')) {
      // 活動中心
      page = (o) =>
          o == null ? notOrganizerText(context) : CenterLayout(organizer: o);
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
              o == null
                  ? notOrganizerText(context)
                  : CreateStep1Layout(
                      organizer: o,
                      jumpToPage: jumpToPage,
                    ),
              o == null
                  ? notOrganizerText(context)
                  : CreateStep2Layout(
                      organizer: o,
                      jumpToPage: jumpToPage,
                    ),
              o == null
                  ? notOrganizerText(context)
                  : CreateStep3Layout(
                      organizer: o,
                      jumpToPage: jumpToPage,
                    ),
            ],
          );
    }
    return [
      BeamPage(
        key: ValueKey(uri),
        child: GestureDetector(
          onTap: () => _navBarKey.currentState?.toggleOverlay(),
          child: Scaffold(
            body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                debugPrint("監測到更改");
                if (snapshot.hasData) {
                  User? user = snapshot.data;
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('organizers')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularLoading();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (user != null) {
                          debugPrint("用戶驗證過");
                          // 用戶驗證過
                          if (user.emailVerified) {
                            OrganizerModel? organizer =
                                OrganizerModel.fromMap(snapshot.data?.data());
                            debugPrint('拿了身份：${organizer?.toJson()}');
                            return Scaffold(
                              backgroundColor: bgColor,
                              appBar: PreferredSize(
                                preferredSize: Size(screenSize.width, 80),
                                child: CustomNavigationBar(
                                  key: _navBarKey,
                                  onIconTapped: onIconTapped,
                                  inform: {
                                    "pic": organizer?.pic,
                                    "username": organizer?.username ?? "",
                                    "email": organizer?.email ??
                                        FirebaseAuth
                                            .instance.currentUser?.email,
                                  },
                                  isForm: false,
                                ),
                              ),
                              body: page(organizer),
                            );
                          } else {
                            debugPrint("用戶尚未驗證");
                            // 尚未驗證
                            return VerifyEmailPage(
                              email: user.email ?? "",
                              role: "organizer",
                            );
                          }
                        } else {
                          return Center(child: LoginLayout(role: "organizer"));
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
        ),
      )
    ];
  }

  Widget centerSignFormLayout(OrganizerModel o, String id) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').doc(id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularLoading();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            PostModel post = PostModel.fromMap(snapshot.data!.data()!);
            return CenterSignFormLayout(
              organizer: o,
              post: post,
            );
          }
        });
  }

  Widget notOrganizerText(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MediumText(
            color: grey500,
            size: 18,
            text: "非常抱歉，此帳號似乎並非官方核准的主辦方帳號",
          ),
          const SizedBox(height: 10),
          MediumText(
            color: grey500,
            size: 18,
            text: "如想加入UPoint活動主辦方，請點擊下方“成為主辦方”或請洽詢service.upoint@gmail.com",
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: TapHoverContainer(
                  text: "成為主辦方",
                  padding: 15,
                  hoverColor: secondColor,
                  borderColor: Colors.transparent,
                  textColor: Colors.white,
                  color: primaryColor,
                  onTap: () =>
                      Beamer.of(context).beamToNamed('/organizer/inform'),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 150,
                child: TapHoverContainer(
                  text: "登出",
                  padding: 15,
                  hoverColor: grey100,
                  borderColor: secondColor,
                  textColor: secondColor,
                  color: Colors.white,
                  onTap: () => AuthMethods().signOut(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  List<Pattern> get pathPatterns => pathBluedebugPrints;
}

// ignore_for_file: invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/firebase/auth_methods.dart';
import 'package:upoint_web/layouts/login_layout.dart';
import 'package:upoint_web/layouts/sign_form_layout.dart';
import 'package:upoint_web/models/user_model.dart';
import 'package:upoint_web/widgets/custom_navigation_bar.dart';

class SignFormLocation extends BeamLocation {
  List<String> get pathBlueprints => [
        '/signForm',
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    var screenSize = MediaQuery.of(context).size;

    Widget Function(UserModel) page =
        (u) => const Center(child: Text("page not found"));
    Uri uri = state.toRouteInformation().uri;
    final id = uri.queryParameters['id'];
    // 根据id决定显示哪个页面
    if (id != null) {
      // 假设你有一个根据id来显示表单内容的Widget
      page = (u) => SignFormLayout(postId: id, user: u);
    } else {
      // 如果没有id参数，显示“Page not found”
      page = (u) => const Center(child: Text("Page not found"));
    }

    return [
      BeamPage(
        key: ValueKey('Sign_form_$id'),
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: PreferredSize(
            preferredSize: Size(screenSize.width, 80),
            child: CustomNavigationBar(
              organizer: null,
              onIconTapped: () {},
              isForm: true,
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
                return FutureBuilder<DocumentSnapshot?>(
                  future: AuthMethods().getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || snapshot.data == null) {
                      FirebaseAuth.instance.signOut();
                      print('發生錯誤，系統先登出');
                      return Text('Error: ${snapshot.error}');
                    } else {
                      UserModel? user =
                          UserModel.fromMap(snapshot.data?.data()as Map);
                      print('拿了身份：${user?.toJson()}');
                      return SingleChildScrollView(child: page(user!));
                    }
                  },
                );
              } else if (snapshot.hasError) {
                print('firebase authState error');
                return Center(child: Text('${snapshot.error}'));
              } else {
                return  Center(child:LoginLayout(role: "user"));
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

// ignore_for_file: invalid_use_of_protected_member
import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/layouts/sign_form_layout.dart';
import 'package:upoint_web/models/user_model.dart';
import 'package:upoint_web/pages/email_verified_page.dart';
import 'package:upoint_web/widgets/custom_navigation_bar.dart';

import '../widgets/circular_loading.dart';

class SignFormLocation extends BeamLocation {
  List<String> get pathBluedebugPrints => [
        '/signForm',
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    var screenSize = MediaQuery.of(context).size;

    Widget Function(UserModel?) page =
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
    Future fetchUser() async {
      print("找");
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (!userDoc.exists) {
        await Future.delayed(const Duration(seconds: 1));
        userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
      }

      return userDoc;
    }

    return [
      BeamPage(
        key: ValueKey('Sign_form_$id'),
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            debugPrint("監測到更改");
            if (snapshot.hasData) {
              User? user = snapshot.data;
              if (user != null && user.emailVerified == false) {
                debugPrint("用戶尚未驗證");
                return Scaffold(
                  backgroundColor: bgColor,
                  body: VerifyEmailPage(
                    email: user.email!,
                    role: "user",
                  ),
                );
              }
              return FutureBuilder(
                future: fetchUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularLoading(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    UserModel? userModel =
                        UserModel.fromMap(snapshot.data?.data());
                    return Scaffold(
                      backgroundColor: bgColor,
                      appBar: PreferredSize(
                        preferredSize: Size(screenSize.width, 80),
                        child: CustomNavigationBar(
                          activeIndex: 0,
                          inform: {
                            "pic": userModel?.pic,
                            "username": userModel?.username ?? "",
                            "email": userModel?.email ??
                                FirebaseAuth.instance.currentUser?.email,
                          },
                          onIconTapped: () {},
                          isForm: true,
                        ),
                      ),
                      body: SingleChildScrollView(child: page(userModel)),
                    );
                  }
                },
              );
            } else {
              return Scaffold(
                backgroundColor: bgColor,
                appBar: PreferredSize(
                  preferredSize: Size(screenSize.width, 80),
                  child: CustomNavigationBar(
                    activeIndex: 0,
                    inform: const {
                      "pic": null,
                      "username": "",
                      "email": "",
                    },
                    onIconTapped: () {},
                    isForm: true,
                  ),
                ),
                body: SingleChildScrollView(
                  child: page(null),
                ),
              );
            }
          },
        ),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBluedebugPrints;
}

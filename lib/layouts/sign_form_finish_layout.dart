import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/pages/sign_form_page.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import '../models/user_model.dart';

class SignFormFinishLayout extends StatelessWidget {
  final UserModel user;
  final String res;
  const SignFormFinishLayout({
    super.key,
    required this.user,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    String image = res == "success" ? "create_success" : "create_failed";
    String text =
        res == "success" ? "報名成功！" : "$res 上傳失敗！請聯絡service.upoint@gmail.com";
    return Scaffold(
      body: ResponsiveLayout(
        tabletLayout: tabletLayout(image, text),
        webLayout: webLayout(image, text),
      ),
    );
  }

  Widget tabletLayout(String image, String text) {
    print('切換到 tabletLayout');
    return SignFormPage(
      isWeb: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 77),
          Container(
            width: 152,
            height: 152,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("assets/$image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 17),
          MediumText(
            color: grey500,
            size: 20,
            text: text,
          ),
        ],
      ),
    );
  }

  Widget webLayout(String image, String text) {
    print('切換到 desktopLayout');
    return SignFormPage(
      isWeb: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 77),
          Container(
            width: 152,
            height: 152,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("assets/$image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 17),
          MediumText(
            color: grey500,
            size: 20,
            text: text,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:upoint_web/pages/signup_form_page.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

import '../widgets/signup_form/signup_form_right_layout.dart';

class SignUpFormLayout extends StatelessWidget {
  const SignUpFormLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(),
      webLayout: webLayout(),
    );
  }

  Widget tabletLayout() {
    print('切換到 tabletLayout');
    return SignUpFormPage(
      isWeb: false,
      child: Container(),
    );
  }

  Widget webLayout() {
    print('切換到 desktopLayout');
    return SignUpFormPage(
      isWeb: true,
      child: Row(
        children: [
          SignUpFormRightLayout(),
        ],
      ),
    );
  }
}

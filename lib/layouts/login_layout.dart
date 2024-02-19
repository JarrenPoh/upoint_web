import 'package:flutter/material.dart';
import 'package:upoint_web/pages/login_page.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

class LoginLayout extends StatelessWidget {
  final String role;
  LoginLayout({
    super.key,
    required this.role,
  });
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(),
      webLayout: webLayout(),
    );
  }

  Widget tabletLayout() {
    return LoginPage(
      role: role,
      isWeb: false,
    );
  }

  Widget webLayout() {
    return LoginPage(
      role: role,
      isWeb: true,
    );
  }
}

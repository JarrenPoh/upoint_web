import 'package:flutter/material.dart';
import 'package:upoint_web/pages/login_page.dart';
import 'package:upoint_web/pages/register_page.dart';
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

  final _pageController = PageController(initialPage: 0);
  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Widget tabletLayout() {
    return PageView(
      children: [
        LoginPage(
          role: role,
          isWeb: false,
          navigateToPage: _navigateToPage,
        ),
        RegisterPage(
          navigateToPage: _navigateToPage,
          isWeb: false,
          role: role,
        ),
      ],
    );
  }

  Widget webLayout() {
    return PageView(
      controller: _pageController,
      children: [
        LoginPage(
          role: role,
          isWeb: true,
          navigateToPage: _navigateToPage,
        ),
        RegisterPage(
          navigateToPage: _navigateToPage,
          isWeb: true,
          role: role,
        ),
      ],
    );
  }
}

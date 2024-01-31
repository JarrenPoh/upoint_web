import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  // final Widget mobileLayout;
  final Widget tabletLayout;
  final Widget webLayout;

  const ResponsiveLayout({
    // required this.mobileLayout,
    required this.tabletLayout,
    required this.webLayout,
  });

  // static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 1080; //1076

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= tabletBreakpoint) {
      return tabletLayout; // 平板布局
    } else {
      return webLayout; // 桌面布局
    }

    // if (screenWidth <= mobileBreakpoint) {
    //   return mobileLayout; // 手机布局
    // } else if (screenWidth <= tabletBreakpoint) {
    //   return tabletLayout; // 平板布局
    // } else {
    //   return desktopLayout; // 桌面布局
    // }
  }
}

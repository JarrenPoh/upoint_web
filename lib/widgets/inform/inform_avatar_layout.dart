import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';

import '../tap_hover_container.dart';

class InformAvatarLayout extends StatefulWidget {
  const InformAvatarLayout({super.key});

  @override
  State<InformAvatarLayout> createState() => _InformAvatarLayoutState();
}

class _InformAvatarLayoutState extends State<InformAvatarLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 90,
          backgroundColor: Color(0xFFFFF5E7),
          child: CircleAvatar(
            radius: 80,
          ),
        ),
        const SizedBox(height: 10),
        TapHoverContainer(
          text: "上傳照片",
          padding: 58,
          hoverColor: grey100,
          borderColor: primaryColor,
          textColor: primaryColor,
          color: Colors.white,
          onTap: () {},
        ),
      ],
    );
  }
}

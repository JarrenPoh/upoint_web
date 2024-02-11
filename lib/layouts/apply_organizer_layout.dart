import 'package:flutter/material.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/pages/apply_organizer_page.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import 'package:upoint_web/widgets/underscore_textfield.dart';

import '../color.dart';
import '../widgets/tap_hover_container.dart';

class ApplyLayout extends StatelessWidget {
  ApplyLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(),
      webLayout: webLayout(),
    );
  }

  Widget tabletLayout() {
    return ApplyOrganizerPage(
      isWeb: false,
      child: Column(
        children: [
          //頭像
          Row(
            children: [
              _avaterLayout(),
            ],
          ),
          const SizedBox(height: 30),
          //基本資料
          _commonLayout(false),
          const SizedBox(height: 30),
          //第二列
          _contactLayout(false),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget webLayout() {
    return ApplyOrganizerPage(
      isWeb: true,
      child: Column(
        children: [
          Row(
            children: [
              //頭像
              _avaterLayout(),
              const SizedBox(width: 37),
              //基本資料
              Expanded(
                child: _commonLayout(true),
              )
            ],
          ),
          const SizedBox(height: 57),
          //第二列
          _contactLayout(true),
          const SizedBox(height: 96),
        ],
      ),
    );
  }

  Widget _avaterLayout() {
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

  Widget _commonLayout(bool isWeb) {
    List commonList = [
      "主辦單位所屬學校",
      "主辦單位名稱",
      "主辦單位簡介",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        MediumText(
          color: grey500,
          size: 18,
          text: "基本資料",
        ),
        for (var i in commonList)
          Column(
            children: [
              const SizedBox(height: 25),
              UnderscoreTextField(
                text: null,
                padLeft: isWeb ? 22 : 6,
                hintText: i,
                onChanged: (String e) {
                  print(e);
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _contactLayout(bool isWeb) {
    List contactList = [
      "聯絡人姓名",
      "聯絡電話",
      "Email",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumText(
          color: grey500,
          size: 18,
          text: "聯絡人資料",
        ),
        for (var i in contactList)
          Column(
            children: [
              const SizedBox(height: 24),
              UnderscoreTextField(
                text: null,
                padLeft: isWeb ? 22 : 6,
                hintText: i,
                onChanged: (String e) {
                  print(e);
                },
              ),
            ],
          ),
      ],
    );
  }
}

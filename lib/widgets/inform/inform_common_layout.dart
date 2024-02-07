import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/widgets/underscore_textfield.dart';

class InformCommonLayout extends StatelessWidget {
  final List list;
  final bool isWeb;
  const InformCommonLayout({
    super.key,
    required this.list,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        MediumText(
          color: grey500,
          size: 18,
          text: "基本資料",
        ),
        for (var i in list)
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
}

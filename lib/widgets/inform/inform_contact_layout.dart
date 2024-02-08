import 'package:flutter/material.dart';

import '../../color.dart';
import '../../globals/medium_text.dart';
import '../underscore_textfield.dart';

class InformContactLayout extends StatelessWidget {
  final List list;
  final bool isWeb;
  const InformContactLayout({
    super.key,
    required this.list,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumText(
          color: grey500,
          size: 18,
          text: "聯絡人資料",
        ),
        for (var i in list)
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
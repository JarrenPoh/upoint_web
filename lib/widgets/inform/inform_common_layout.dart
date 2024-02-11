import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';

import '../../models/organizer_model.dart';

class InformCommonLayout extends StatelessWidget {
  final List list;
  final bool isWeb;
  final OrganizerModel organizer;
  const InformCommonLayout({
    super.key,
    required this.list,
    required this.isWeb,
    required this.organizer,
  });

  @override
  Widget build(BuildContext context) {
    String _text(String index) {
      switch (index) {
        case "unit":
          return organizer.unit!;
        case "username":
          return organizer.username!;
        case "bio":
          return organizer.bio!;
      }
      return '';
    }

    return SizedBox(
      height: 349,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          MediumText(
            color: grey500,
            size: 18,
            text: "基本資料",
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                list.length,
                (index) {
                  double height = index == 2 ? 184 : 34;
                  final TextEditingController _controller =
                      TextEditingController(
                    text: _text(list[index]["index"]),
                  );
                  return Container(
                    height: height,
                    decoration: BoxDecoration(
                      border: Border.all(color: grey300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 138,
                          height: height,
                          padding: const EdgeInsets.only(left: 13),
                          decoration: BoxDecoration(
                            color: subColor,
                            border: Border(
                              right: BorderSide(color: grey300),
                            ),
                          ),
                          child: Row(
                            children: [
                              RegularText(
                                color: grey500,
                                size: 14,
                                text: list[index]["title"],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: TextField(
                                    controller: _controller,
                                    maxLines: index == 2 ? 30 : 1,
                                    readOnly: true,
                                    style: TextStyle(
                                      color: grey500,
                                      fontSize: 14,
                                      fontFamily: "NotoSansRegular",
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        bottom: 17,
                                        top: index == 2 ? 17 : 0,
                                      ),
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:upoint_web/models/organizer_model.dart';
import '../../color.dart';
import '../../globals/medium_text.dart';
import '../../globals/regular_text.dart';

class InformContactLayout extends StatelessWidget {
  final List list;
  final bool isWeb;
  final OrganizerModel organizer;
  const InformContactLayout({
    super.key,
    required this.list,
    required this.isWeb,
    required this.organizer,
  });

  @override
  Widget build(BuildContext context) {
    String _text(String index) {
      switch (index) {
        case "contact":
          return organizer.contact!;
        case "phoneNumber":
          return organizer.phoneNumber!;
        case "email":
          return organizer.email;
      }
      return '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumText(
          color: grey500,
          size: 18,
          text: "聯絡人資料",
        ),
        Column(
          children: List.generate(
            list.length,
            (index) {
              final TextEditingController _controller = TextEditingController(
                text: _text(list[index]["index"]),
              );
              return Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    height: 34,
                    decoration: BoxDecoration(
                      border: Border.all(color: grey300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 138,
                          height: 34,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 18),
                                  child: TextField(
                                    controller: _controller,
                                    maxLines: 30,
                                    readOnly: true,
                                    style: TextStyle(
                                      color: grey500,
                                      fontSize: 14,
                                      fontFamily: "NotoSansRegular",
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(bottom: 8),
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
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

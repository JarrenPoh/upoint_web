import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/inform_bloc.dart';
import '../../color.dart';
import '../../globals/medium_text.dart';
import '../../globals/regular_text.dart';

class InformContactLayout extends StatelessWidget {
  final bool isWeb;
  final InformBloc bloc;
  const InformContactLayout({
    super.key,
    required this.isWeb,
    required this.bloc,
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
        ValueListenableBuilder(
          valueListenable: bloc.contactValue,
          builder: (context, value, child) {
            return Column(
              children: List.generate(
                value.length,
                (index) {
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
                                    text: value[index]["title"],
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
                                      padding: const EdgeInsets.only(left: 18),
                                      child: TextField(
                                        controller: value[index]["controller"],
                                        maxLines: 30,
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
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/inform_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';

class InformCommonLayout extends StatelessWidget {
  final bool isWeb;
  final InformBloc bloc;
  const InformCommonLayout({
    super.key,
    required this.isWeb,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
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
            child: ValueListenableBuilder(
                valueListenable: bloc.commonValue,
                builder: (context, value, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      value.length,
                      (index) {
                        double height =
                            value[index]["index"] == "bio" ? 184 : 34;
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
                                      text: value[index]["title"],
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
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        child: TextField(
                                          controller: value[index]
                                              ["controller"],
                                          maxLines: value[index]["index"] == "bio" ? 30 : 1,
                                          style: TextStyle(
                                            color: grey500,
                                            fontSize: 14,
                                            fontFamily: "NotoSansRegular",
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              bottom: 17,
                                              top: value[index]["index"] == "bio" ? 17 : 0,
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
                  );
                }),
          ),
        ],
      ),
    );
  }
}

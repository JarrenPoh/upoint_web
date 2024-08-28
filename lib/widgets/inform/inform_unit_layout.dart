import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';
import 'package:upoint_web/widgets/tap_hover_icon.dart';

import '../../bloc/inform_bloc.dart';
import '../../color.dart';
import '../../globals/medium_text.dart';
import '../../globals/regular_text.dart';

class InformUnitLayout extends StatelessWidget {
  final bool isWeb;
  final InformBloc bloc;
  const InformUnitLayout({
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
          text: "單位資料",
        ),
        ValueListenableBuilder(
          valueListenable: bloc.unitValue,
          builder: (context, value, child) {
            return Column(
              children: List.generate(
                value.length,
                (index) {
                  String vi = value[index]["index"];
                  double? height =
                      vi == "actBio" || (vi == "links" && isWeb == false)
                          ? 184
                          : 34;
                  return Column(
                    children: [
                      const SizedBox(height: 24),
                      Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 相關連結
                                  if (value[index]["index"] == "links")
                                    LinksArea(
                                      links: value[index]["value"],
                                      context: context,
                                      bloc: bloc,
                                    ),
                                  if (value[index]["index"] != "links")
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        child: TextField(
                                          controller: value[index]
                                              ["controller"],
                                          maxLines:
                                              value[index]["index"] == "actBio"
                                                  ? 30
                                                  : 1,
                                          style: TextStyle(
                                            color: grey500,
                                            fontSize: 14,
                                            fontFamily: "NotoSansRegular",
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              bottom: 17,
                                              top: value[index]["index"] ==
                                                      "actBio"
                                                  ? 17
                                                  : 0,
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

  Widget LinksArea({
    required List? links,
    required BuildContext context,
    required InformBloc bloc,
  }) {
    links = links ?? [];
    return Expanded(
      child: Padding(
        padding:
            isWeb ? const EdgeInsets.only(left: 13) : const EdgeInsets.all(10),
        child: Wrap(
          spacing: 10,
          runSpacing: 5,
          children: List.generate(
            links.length + 1,
            (index) {
              if (index == links?.length) {
                // 最後一個
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TapHoverIcon(
                    hoverColor: secondColor,
                    color: primaryColor,
                    onTap: () async {
                      Map res = await Messenger.addLinksDialog(
                        context: context,
                        text: "",
                        url: "",
                      );
                      if (res["status"] == "success") {
                        bloc.addLink(text: res["text"], url: res["url"]);
                      }
                    },
                    iconSize: 24,
                  ),
                );
              }
              return IntrinsicWidth(
                child: SizedBox(
                  height: 32,
                  child: TapHoverContainer(
                    text: links?[index]["textController"].text,
                    padding: 16,
                    hoverColor: grey200,
                    borderColor: Colors.transparent,
                    textColor: grey500,
                    color: grey100,
                    onTap: () async {
                      Map res = await Messenger.addLinksDialog(
                        context: context,
                        text: links?[index]["textController"].text,
                        url: links?[index]["urlController"].text,
                      );
                      if (res["status"] == "success") {
                        bloc.updateLink(
                            url: res["url"], text: res["text"], index: index);
                      } else if (res["status"] == "delete") {
                        bloc.removeLink(index);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

class TagPickRow extends StatefulWidget {
  final Map tagMap;
  final Function(String) tagPick;
  const TagPickRow({
    super.key,
    required this.tagMap,
    required this.tagPick,
  });

  @override
  State<TagPickRow> createState() => _TagPickRowState();
}

class _TagPickRowState extends State<TagPickRow> {
  Color color = grey100;
  late Map tagMap;
  @override
  void initState() {
    super.initState();
    tagMap = widget.tagMap;
  }

  onTap(String text) {
    String _type = tagMap["type"];
    switch (_type) {
      case "rewardTag":
        (tagMap["tag"] as List).forEach((e) {
          if (e["index"] == text) {
            e["isChecked"] = true;
          } else {
            e["isChecked"] = false;
          }
        });
        break;
      case "tag":
        int i = (tagMap["tag"] as List).indexWhere((e) => e["index"] == text);
        tagMap["tag"][i]["isChecked"] = !tagMap["tag"][i]["isChecked"];
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: grey400),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 42,
                  padding: const EdgeInsets.only(left: 24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: grey400,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      RegularText(
                        color: grey400,
                        size: 16,
                        text: widget.tagMap["title"],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Wrap(
                    runSpacing: 12,
                    children: List.generate(
                      tagMap["tag"].length,
                      (index) {
                        bool _isChecked = tagMap["tag"][index]["isChecked"];
                        return IntrinsicWidth(
                          child: Container(
                            height: 31,
                            // padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.only(right: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: TapHoverContainer(
                                text: tagMap["tag"][index]["index"],
                                padding: 16,
                                hoverColor: _isChecked
                                    ? Color.fromRGBO(241, 231, 216, 1)
                                    : grey200,
                                borderColor: _isChecked ? fillColor : grey100,
                                textColor: grey500,
                                color: _isChecked ? fillColor : grey100,
                                onTap: () {
                                  widget.tagPick(tagMap["tag"][index]["index"]);
                                  onTap(tagMap["tag"][index]["index"]);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

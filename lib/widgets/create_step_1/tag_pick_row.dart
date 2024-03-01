import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';
import 'package:upoint_web/widgets/tap_hover_text.dart';

import '../../models/tag_model.dart';

class TagPickRow extends StatefulWidget {
  final TagModel tagModel;
  final Function(String) tagPick;
  final Function(String) addCustomTag;
  final Function(String) deleteCustomTag;
  const TagPickRow({
    super.key,
    required this.tagModel,
    required this.tagPick,
    required this.addCustomTag,
    required this.deleteCustomTag,
  });

  @override
  State<TagPickRow> createState() => _TagPickRowState();
}

class _TagPickRowState extends State<TagPickRow> {
  Color color = grey100;
  late TagModel tagModel;
  @override
  void initState() {
    super.initState();
    tagModel = widget.tagModel;
  }

  onTap(String text) {
    String _type = tagModel.type;
    switch (_type) {
      case "postType":
        tagModel.tagValue.forEach((e) {
          if (e["index"] == text) {
            e["isChecked"] = true;
          } else {
            e["isChecked"] = false;
          }
        });
        break;
      case "rewardTag":
        tagModel.tagValue.forEach((e) {
          if (e["index"] == text) {
            e["isChecked"] = true;
          } else {
            e["isChecked"] = false;
          }
        });
        break;
      case "tags":
        int i = tagModel.tagValue.indexWhere((e) => e["index"] == text);
        tagModel.tagValue[i]["isChecked"] = !tagModel.tagValue[i]["isChecked"];
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
                        text: widget.tagModel.title,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, bottom: 18, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(tagModel.type!="tags")
                      const SizedBox(height: 13),
                      if (tagModel.type == "tags")
                        Column(
                          children: [
                            TapHoverText(
                              textSize: 14,
                              text: "+ 新增「」標籤",
                              hoverColor: secondColor,
                              color: primaryColor,
                              onTap: () async {
                                Map _map = await Messenger.addTagsDialog(
                                    "新增標籤", context);
                                if (_map["status"] == "success") {
                                  widget.addCustomTag(_map["value"] ?? "null");
                                }
                              },
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      Wrap(
                        runSpacing: 12,
                        children: List.generate(
                          tagModel.tagValue.length,
                          (index) {
                            bool _isChecked =
                                tagModel.tagValue[index]["isChecked"];
                            return IntrinsicWidth(
                              child: Stack(
                                alignment: Alignment(0.6, -1),
                                children: [
                                  Container(
                                    height: 31,
                                    // padding: const EdgeInsets.symmetric(horizontal: 16),
                                    margin: const EdgeInsets.only(right: 18),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: TapHoverContainer(
                                        text: tagModel.tagValue[index]["index"],
                                        padding: 16,
                                        hoverColor: _isChecked
                                            ? Color.fromRGBO(241, 231, 216, 1)
                                            : grey200,
                                        borderColor:
                                            _isChecked ? subColor : grey100,
                                        textColor: grey500,
                                        color: _isChecked ? subColor : grey100,
                                        onTap: () {
                                          widget.tagPick(tagModel
                                              .tagValue[index]["index"]);
                                          onTap(tagModel.tagValue[index]
                                              ["index"]);
                                        },
                                      ),
                                    ),
                                  ),
                                  if (tagModel.tagValue[index]["isCustom"] !=
                                      null)
                                    GestureDetector(
                                      onTap: () async {
                                        String status = await Messenger.dialog(
                                            "提醒", "確定要刪除此標籤", context);
                                        if (status == "success") {
                                          widget.deleteCustomTag(tagModel
                                              .tagValue[index]["index"]);
                                        }
                                      },
                                      child: const MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

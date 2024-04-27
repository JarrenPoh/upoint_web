import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_1_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/models/tag_model.dart';
import 'package:upoint_web/widgets/create_step_1/check_null_row.dart';
import 'package:upoint_web/widgets/create_step_1/date_pick_row.dart';
import 'package:upoint_web/widgets/create_step_1/quill_field.dart';
import 'package:upoint_web/widgets/create_step_1/tag_pick_row.dart';
import 'package:upoint_web/widgets/underscore_textfield.dart';

class CreateStep1BodyLayout extends StatefulWidget {
  final bool isWeb;
  final CreateStep1Bloc bloc;
  const CreateStep1BodyLayout({
    super.key,
    required this.isWeb,
    required this.bloc,
  });

  @override
  State<CreateStep1BodyLayout> createState() => _CreateStep1BodyLayoutState();
}

class _CreateStep1BodyLayoutState extends State<CreateStep1BodyLayout> {
  ImageProvider? photoProvider;
  String? photo;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PostModel>(
      valueListenable: widget.bloc.valueNotifier,
      builder: (context, value, child) {
        value;
        photo = value.photo;
        if (photo != null && photo?.substring(0, 4) == "http") {
          photoProvider = NetworkImage(photo!);
        } else if (photo != null && photo?.substring(0, 4) != "http") {
          photoProvider = MemoryImage(base64Decode(photo!));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 上傳封面照
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      color: primaryColor,
                      width: 8,
                      height: 29,
                    ),
                    const SizedBox(width: 16),
                    MediumText(
                      color: grey500,
                      size: 20,
                      text: '上傳封面照',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.bloc.pickImage,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            height: 374,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFF4F4F4),
                              image: photo != null
                                  ? DecorationImage(
                                      image: photoProvider!,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: widget.bloc.valueNotifier.value.photo == null
                                ? Center(
                                    child: IconButton(
                                      onPressed: widget.bloc.pickImage,
                                      icon: const Icon(
                                        Icons.upload_rounded,
                                        color: Color(0xFF343434),
                                      ),
                                      iconSize: 27,
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 48),
            // 活動資訊
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      color: primaryColor,
                      width: 8,
                      height: 29,
                    ),
                    const SizedBox(width: 16),
                    MediumText(
                      color: grey500,
                      size: 20,
                      text: '活動資訊',
                    ),
                  ],
                ),
                Column(
                  children: List.generate(
                    widget.bloc.createInformList.length,
                    (index) {
                      String? text = _initText(
                          widget.bloc.createInformList[index]["index"]);
                      String type = widget.bloc.createInformList[index]['type'];
                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          // 時間的
                          if (type == "date")
                            DatePickRow(
                              post: widget.bloc.valueNotifier.value,
                              index: widget.bloc.createInformList[index]
                                  ["index"],
                              isWeb: widget.isWeb,
                              dateTimeFunc: (e, ee) =>
                                  widget.bloc.dateTimeFunc(e, ee, index),
                            ),
                          //填名額的
                          if (type == "checkNull")
                            CheckNullRow(
                              index: widget.bloc.createInformList[index]
                                  ["index"],
                              number: text,
                              padLeft: widget.isWeb ? 22 : 6,
                              hintText: widget.bloc.createInformList[index]
                                  ['title'],
                              onChanged: (String? e) {
                                widget.bloc.onTextChanged(e, index);
                              },
                            ),
                          //其他的
                          if (type == "normal")
                            UnderscoreTextField(
                              text: text,
                              padLeft: widget.isWeb ? 22 : 6,
                              hintText: widget.bloc.createInformList[index]
                                  ['title'],
                              onChanged: (String e) {
                                widget.bloc.onTextChanged(e, index);
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // 活動標籤
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      color: primaryColor,
                      width: 8,
                      height: 29,
                    ),
                    const SizedBox(width: 16),
                    MediumText(
                      color: grey500,
                      size: 20,
                      text: '標籤設定',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  children: List.generate(
                    widget.bloc.tagList.length,
                    (index) {
                      TagModel tagModel = widget.bloc.tagList[index];
                      initTagMap(tagModel, index);
                      return Column(
                        children: [
                          TagPickRow(
                            tagModel: tagModel,
                            tagPick: (e) => widget.bloc.tagPick(index, e),
                            addCustomTag: (e) => widget.bloc.addCustomTag(e),
                            deleteCustomTag: (e) =>
                                widget.bloc.deleteCustomTag(e),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // 活動詳情
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      color: primaryColor,
                      width: 8,
                      height: 29,
                    ),
                    const SizedBox(width: 16),
                    MediumText(
                      color: grey500,
                      size: 20,
                      text: '活動詳情',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: grey300),
                  ),
                  child: QuillField(
                    text: widget.bloc.valueNotifier.value.content,
                    onQuillChanged: (delta) =>
                        widget.bloc.onQuillChanged(delta),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 0),
          ],
        );
      },
    );
  }

  initTagMap(TagModel tagModel, int index) {
    tagModel.tagValue.forEach((e) {
      if (index == 0) {
        if (e["index"] == widget.bloc.valueNotifier.value.postType) {
          e["isChecked"] = true;
        } else {
          e["isChecked"] = false;
        }
      } else if (index == 1) {
        if (e["id"] == widget.bloc.valueNotifier.value.rewardTagId) {
          e["isChecked"] = true;
        } else {
          e["isChecked"] = false;
        }
      } else {
        if (widget.bloc.valueNotifier.value.tags!.contains(e["index"])) {
          e["isChecked"] = true;
        } else {
          e["isChecked"] = false;
        }
      }
    });
  }

  String? _initText(String index) {
    String? text;
    switch (index) {
      case "title":
        text = widget.bloc.valueNotifier.value.title;
        break;
      case "location":
        text = widget.bloc.valueNotifier.value.location;
        break;
      case "contact":
        text = widget.bloc.valueNotifier.value.contact;
        break;
      case "phoneNumber":
        text = widget.bloc.valueNotifier.value.phoneNumber;
        break;
      case "capacity":
        text = widget.bloc.valueNotifier.value.capacity.toString();
        break;
      case "introduction":
        text = widget.bloc.valueNotifier.value.introduction;
        break;
      case "reward":
        text = widget.bloc.valueNotifier.value.reward;
        break;
    }
    return text;
  }
}

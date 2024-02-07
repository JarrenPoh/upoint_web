import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:upoint_web/bloc/create_step_1_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/widgets/create_step_1/capacity_row.dart';
import 'package:upoint_web/widgets/create_step_1/date_pick_row.dart';
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
  @override
  void dispose() {
    widget.bloc.debounce?.cancel();
    super.dispose();
  }

  QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PostModel>(
      valueListenable: widget.bloc.valueNotifier,
      builder: (context, value, child) {
        value;
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
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          height: 374,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFF4F4F4),
                            image: widget.bloc.valueNotifier.value.photo != null
                                ? DecorationImage(
                                    image: MemoryImage(
                                      base64Decode(
                                        widget.bloc.valueNotifier.value.photo!,
                                      ),
                                    ),
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
                    SizedBox(width: 16),
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
                      String type = _pickType(
                          widget.bloc.createInformList[index]['index']);
                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          // 填startTime
                          if (type == "date0")
                            DatePickRow(
                              time: widget.bloc.valueNotifier.value.startTime,
                              date: widget.bloc.valueNotifier.value.startDate,
                              isWeb: widget.isWeb,
                              title: widget.bloc.createInformList[index]
                                  ['title'],
                              dateFunc: (e) => widget.bloc.dateFunc(e, index),
                              timeFunc: (e) => widget.bloc.timeFunc(e, index),
                            ),
                          //填endTime
                          if (type == "date1")
                            DatePickRow(
                              time: widget.bloc.valueNotifier.value.endTime,
                              date: widget.bloc.valueNotifier.value.endDate,
                              isWeb: widget.isWeb,
                              title: widget.bloc.createInformList[index]
                                  ['title'],
                              dateFunc: (e) => widget.bloc.dateFunc(e, index),
                              timeFunc: (e) => widget.bloc.timeFunc(e, index),
                            ),
                          //填名額的
                          if (type == "capacity")
                            CapacityRow(
                              number: text == null ? null : int.parse(text),
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
                  decoration: BoxDecoration(border: Border.all(color: grey400)),
                  child: Column(
                    children: [
                      QuillToolbar.simple(
                        configurations: QuillSimpleToolbarConfigurations(
                          controller: _controller,
                          sharedConfigurations: const QuillSharedConfigurations(
                            locale: Locale('en'),
                          ),
                        ),
                      ),
                      QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                          controller: _controller,
                          readOnly: false,
                          sharedConfigurations: const QuillSharedConfigurations(
                            locale: Locale('en'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        );
      },
    );
  }

  String? _initText(String type) {
    String? text;
    switch (type) {
      case "title":
        text = widget.bloc.valueNotifier.value.title;
        break;
      case "location":
        text = widget.bloc.valueNotifier.value.location;
        break;
      case "capacity":
        int? capcity = widget.bloc.valueNotifier.value.capacity;
        text = capcity == null
            ? null
            : widget.bloc.valueNotifier.value.capacity.toString();
        break;
      case "introduction":
        text = widget.bloc.valueNotifier.value.introduction;
        break;
    }
    return text;
  }

  String _pickType(String index) {
    List date = ["startDate", "endDate"];
    List normal = ["title", "location", "introduction"];
    List capacity = ["capacity"];
    if (date.contains(index)) {
      int i = date.indexWhere((e) => e == index);
      return "date$i";
    } else if (normal.contains(index)) {
      return "normal";
    } else if (capacity.contains(index)) {
      return "capacity";
    }
    return "";
  }
}

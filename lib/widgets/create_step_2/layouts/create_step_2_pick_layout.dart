import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_2_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/widgets/create_step_1/date_pick_row.dart';

class CreateStep2PickLayout extends StatefulWidget {
  final CreateStep2Bloc bloc;
  final Widget child;
  final bool isWeb;
  const CreateStep2PickLayout({
    super.key,
    required this.child,
    required this.bloc,
    required this.isWeb,
  });

  @override
  State<CreateStep2PickLayout> createState() => _CreateStep2PickLayoutState();
}

class _CreateStep2PickLayoutState extends State<CreateStep2PickLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 948,
          height: 144,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: grey300),
          ),
          child: Column(
            children: [
              Container(
                height: 59,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  color: grey100,
                ),
                child: Center(
                  child: MediumText(
                    color: grey500,
                    size: 18,
                    text: '報名表單選項',
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: List.generate(
                    widget.bloc.formOptions.length,
                    (index) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => widget.bloc.tapOption(
                            widget.bloc.formOptions[index]["type"],
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: widget.bloc.formOptionValue,
                            builder: (context, value, build) {
                              bool active = value ==
                                  widget.bloc.formOptions[index]["type"];
                              return Container(
                                height: 44,
                                margin:
                                    const EdgeInsets.only(right: 16, left: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: active ? primaryColor : grey300,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:
                                              active ? primaryColor : grey300,
                                        ),
                                      ),
                                    ),
                                    RegularText(
                                      color: grey500,
                                      size: 16,
                                      text: widget.bloc.formOptions[index]
                                          ["text"],
                                    ),
                                    const SizedBox(width: 7),
                                  ],
                                ),
                              );
                            },
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
        const SizedBox(height: 48),
        ValueListenableBuilder(
          valueListenable: widget.bloc.formOptionValue,
          builder: (context, value, build) {
            Widget _w = Container();
            switch (value) {
              case "form":
                _w = Column(
                  children: [
                    formDateField(),
                    const SizedBox(height: 48),
                    widget.child,
                  ],
                );
                break;
              case "link":
                _w = Column(children: [
                  formDateField(),
                  const SizedBox(height: 48),
                  linkField((e) => widget.bloc.linkTextChanged(e))
                ]);
                break;
              case "null":
                _w = nullField();
                break;
            }
            return _w;
          },
        ),
      ],
    );
  }

  Widget linkField(Function(String) onTextChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 948,
          height: 144,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: grey300),
          ),
          child: Column(
            children: [
              Container(
                height: 59,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  color: grey100,
                ),
                child: Center(
                  child: MediumText(
                    color: grey500,
                    size: 18,
                    text: '報名表單選項',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: grey300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          style: TextStyle(
                            color: grey500,
                            fontSize: 16,
                            fontFamily: "NotoSansRegular",
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(bottom: 5, left: 15),
                            hintText: "輸入報名連結",
                            hintStyle: TextStyle(
                              color: grey300,
                              fontSize: 16,
                              fontFamily: "NotoSansRegular",
                            ),
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (e) => onTextChanged(e),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget formDateField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 948,
          height: 144,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: grey300),
          ),
          child: Column(
            children: [
              Container(
                height: 59,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  color: grey100,
                ),
                child: Center(
                  child: MediumText(
                    color: grey500,
                    size: 18,
                    text: '報名時程',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 48,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ValueListenableBuilder(
                    valueListenable: widget.bloc.postValue,
                    builder: (context, value, child) {
                      return DatePickRow(
                        post: value,
                        index: "formDate",
                        isWeb: widget.isWeb,
                        title: "報名截止日期",
                        dateTimeFunc: (e, ee) =>
                            widget.bloc.formDateFunc(e, ee),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget nullField() {
    return SizedBox(
      height: 350,
      child: Center(
        child: MediumText(
          color: grey500,
          size: 18,
          text: "無需輸入資料，可進入下一步",
        ),
      ),
    );
  }
}

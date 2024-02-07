import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/widgets/create_step_2/components/check_comb.dart';
import 'package:upoint_web/widgets/create_step_2/components/chose_components.dart';

class ContainerWithCheckbox extends StatefulWidget {
  final ValueNotifier<List<FormModel>> valueNotifier;
  final Map option;
  final bool fix;
  final Function(int, int)? tapDelete;
  const ContainerWithCheckbox({
    super.key,
    required this.valueNotifier,
    required this.fix,
    required this.tapDelete,
    required this.option,
  });

  @override
  State<ContainerWithCheckbox> createState() => _ContainerWithCheckboxState();
}

class _ContainerWithCheckboxState extends State<ContainerWithCheckbox> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() {
    _valueNotifier = widget.valueNotifier;
    if (widget.fix == true) {
      option = OptionModel(
        type: widget.option["type"],
        subtitle: widget.option["subtitle"],
        necessary: true,
        explain: null,
        other: null,
        body: [],
      );
    } else {
      lindex = widget.option["lindex"];
      index = widget.option["index"];
      option = OptionModel(
        type: widget.valueNotifier.value[lindex].options[index].type,
        subtitle: widget.valueNotifier.value[lindex].options[index].subtitle,
        necessary: widget.valueNotifier.value[lindex].options[index].necessary,
        explain: widget.valueNotifier.value[lindex].options[index].explain,
        other: widget.valueNotifier.value[lindex].options[index].other,
        body: widget.valueNotifier.value[lindex].options[index].body,
      );
    }
    titleController = TextEditingController(text: option.subtitle);
  }

  late ValueNotifier<List<FormModel>> _valueNotifier;
  late int lindex;
  late int index;
  late OptionModel option;
  List valueType = ["single", "multi", "drop_down", "meal"];
  List enableTitle = [
    "姓名",
    "聯絡電話",
    "email",
  ];
  late TextEditingController titleController;
  @override
  Widget build(BuildContext context) {
    refresh();
    titleController = TextEditingController(text: option.subtitle);
    return Column(
      children: [
        Row(
          children: [
            if (widget.fix)
              Text(
                '*',
                style: TextStyle(
                  color: grey500,
                ),
              ),
            IntrinsicWidth(
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: titleController,
                enabled: !enableTitle.contains(option.subtitle),
                style: TextStyle(
                  color: grey500,
                  fontSize: 16,
                  fontFamily: "NotoSansRegular",
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 0, top: 0),
                  hintStyle: TextStyle(
                    color: grey300,
                    fontSize: 16,
                    fontFamily: "NotoSansRegular",
                  ),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 11),
            // 垃圾桶
            if (widget.fix == false)
              _mouseIcon(
                Icons.delete_rounded,
                () => widget.tapDelete!(lindex, index),
              ),
            // 新增 刪除
            if (valueType.contains(option.type))
              Row(
                children: [
                  _mouseIcon(
                    Icons.remove_circle_outline,
                    () {
                      _valueNotifier.value[lindex].options[index].body
                          .removeLast();
                      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                      _valueNotifier.notifyListeners();
                    },
                  ),
                  _mouseIcon(
                    Icons.add_circle_outline,
                    () {
                      _valueNotifier.value[lindex].options[index].body
                          .add("");
                      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                      _valueNotifier.notifyListeners();
                    },
                  ),
                ],
              ),
            // 說明文字
            if (widget.fix == false)
              CheckComb(
                title: "說明文字",
                func: () {
                  if (_valueNotifier.value[lindex].options[index].explain ==
                      null) {
                    _valueNotifier.value[lindex].options[index].explain = "";
                  } else {
                    _valueNotifier.value[lindex].options[index].explain =
                        null;
                  }
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  _valueNotifier.notifyListeners();
                },
              ),
            // 其他開放選項
            if (option.type == "single" ||
                option.type == "multi" ||
                option.type == "meal")
              CheckComb(
                title: "其他開放選項",
                func: () {
                  if (_valueNotifier.value[lindex].options[index].other ==
                      null) {
                    _valueNotifier.value[lindex].options[index].other =
                        "其他..";
                  } else {
                    _valueNotifier.value[lindex].options[index].other = null;
                  }
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  _valueNotifier.notifyListeners();
                },
              ),
            const Expanded(child: Column(children: [])),
            // 必選
            widget.fix
                ? Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: grey300,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Icon(
                      Icons.check,
                      color: grey400,
                      size: 9,
                    ),
                  )
                : CheckComb(
                    title: "必填",
                    func: () {
                      if (_valueNotifier
                              .value[lindex].options[index].necessary ==
                          false) {
                        _valueNotifier
                            .value[lindex].options[index].necessary = true;
                      } else {
                        _valueNotifier
                            .value[lindex].options[index].necessary = false;
                      }
                      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                      _valueNotifier.notifyListeners();
                    },
                  ),
          ],
        ),
        // 內容
        ChoseComponents(
          valueNotifier: _valueNotifier,
          option: option,
        ),
      ],
    );
  }

  Widget _mouseIcon(
    IconData iconData,
    Function() onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: onTap,
          child: Icon(
            iconData,
            color: grey400,
            size: 20,
          ),
        ),
      ),
    );
  }
}

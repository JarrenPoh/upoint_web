import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/models/option_model.dart';

class NoneDecorTextField extends StatelessWidget {
  final int? index;
  final double fontSize;
  final String attribute;
  final OptionModel option;
  const NoneDecorTextField({
    super.key,
    required this.attribute,
    required this.fontSize,
    required this.index,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    bool autofocus = false;
    bool enabled = false;
    String hintText = "";
    switch (attribute) {
      case "normal":
        if (option.type == "gender" || option.type == "meal") {
          autofocus = false;
        } else {
          autofocus = true;
        }
        enabled = true;
        hintText = "請填寫內容";
        if (index != null) {
          _controller.text = option.body[index!];
        }
        break;
      case "other":
        autofocus = false;
        enabled = false;
        hintText = "其他..";
        _controller.text = option.other ?? "";
        break;
      case "explain":
        autofocus = true;
        enabled = true;
        hintText = "請描述內容";
        _controller.text = option.explain ?? "";
        break;
    }
    if (attribute == "explain" && option.explain == null) {
      return Container();
    } else {
      return SizedBox(
        height: 20,
        child: TextField(
          controller: _controller,
          autofocus: autofocus,
          enabled: enabled,
          style: TextStyle(
            color: grey500,
            fontSize: fontSize,
            fontFamily: "NotoSansRegular",
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 17),
            hintText: hintText,
            hintStyle: TextStyle(
              color: grey300,
              fontSize: fontSize,
              fontFamily: "NotoSansRegular",
            ),
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      );
    }
  }
}

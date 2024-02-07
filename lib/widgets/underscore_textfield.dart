import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';

class UnderscoreTextField extends StatelessWidget {
  final String? text;
  final String hintText;
  final Function(String) onChanged;
  final double padLeft;
  const UnderscoreTextField({
    super.key,
    required this.hintText,
    required this.text,
    required this.onChanged,
    required this.padLeft,
  });
  @override
  Widget build(BuildContext context) {
    final TextEditingController _textEditingController =
        TextEditingController(text: text);
    return Container(
      padding: EdgeInsets.only(left: padLeft, bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: grey400,
          ),
        ),
      ),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: grey400,
            fontFamily: 'NotoSansMedium',
            fontSize: 16,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        onChanged: (e) => onChanged(e),
      ),
    );
  }
}

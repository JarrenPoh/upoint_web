import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';

class UnderscoreTextField extends StatelessWidget {
  final String hintText;
  const UnderscoreTextField({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 22,bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: grey400,
          ),
        ),
      ),
      child: TextField(
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
      ),
    );
  }
}

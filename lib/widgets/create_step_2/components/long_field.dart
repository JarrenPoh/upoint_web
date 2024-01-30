import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';

class LongField extends StatelessWidget {
  final String content;
  final String type;
  const LongField({
    super.key,
    required this.type,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: EdgeInsets.only(left: 17, right: 11),
            decoration: BoxDecoration(
              border: Border.all(color: grey300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RegularText(
                  color: grey400,
                  size: 16,
                  text: content,
                ),
                if (type == "date")
                  Icon(
                    Icons.calendar_month,
                    color: grey300,
                    size: 24,
                  ),
                if (type == "drop_down")
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: grey300,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

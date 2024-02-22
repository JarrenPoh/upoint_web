import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';

class LongField extends StatelessWidget {
  final String hintText;
  final String type;
  const LongField({
    super.key,
    required this.type,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    double height = type == "detail" ? 120 : 48;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: height,
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
                  text: hintText,
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
                if (type == "time")
                  Container(
                    height: 24,
                    width: 24,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/edit_clock.png"),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

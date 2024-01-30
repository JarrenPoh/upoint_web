import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';

class TimeField extends StatelessWidget {
  const TimeField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        3,
        (index) {
          return Container(
            height: 48,
            width: 155,
            padding: const EdgeInsets.only(left: 17, right: 11),
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
                  text: index == 0 ? "時" : "",
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: grey300,
                  size: 24,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

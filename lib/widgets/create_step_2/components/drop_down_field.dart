import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';

class DropDownField extends StatelessWidget {
  final index;
  const DropDownField({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 15),
            Text(
              "$index.",
              style: TextStyle(
                color: grey400,
                fontSize: 16,
                fontFamily: "NotoSansRegular",
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TextField(
                style: TextStyle(
                  color: grey500,
                  fontSize: 16,
                  fontFamily: "NotoSansRegular",
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 0),
                  hintText: "請填寫內容",
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
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: grey300,
              ),
            )
          ],
        ),
      ],
    );
  }
}

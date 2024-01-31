import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';

class DatePickRow extends StatefulWidget {
  final bool isWeb;
  const DatePickRow({
    super.key,
    required this.isWeb,
  });

  @override
  State<DatePickRow> createState() => _DatePickRowState();
}

class _DatePickRowState extends State<DatePickRow> {
  late double width;
  late double padLeft;
  late double padRight;
  late double height;
  @override
  void initState() {
    super.initState();
    width = widget.isWeb ? 111 : 70;
    padLeft = widget.isWeb ? 22 : 6;
    padRight = widget.isWeb ? 16 : 0;
    height = 38;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 24),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: grey400,
              ),
            ),
          ),
          padding: EdgeInsets.only(left: padLeft, right: padRight),
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
                color: grey400,
                size: 16,
                text: '時',
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: grey400,
                ),
                iconSize: 24,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: grey400,
              ),
            ),
          ),
          padding: EdgeInsets.only(left: padLeft, right: padRight),
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
                color: grey400,
                size: 16,
                text: '分',
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: grey400,
                ),
                iconSize: 24,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: grey400,
              ),
            ),
          ),
          padding: EdgeInsets.only(left: padLeft, right: padRight),
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
                color: grey400,
                size: 16,
                text: 'PM',
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: grey400,
                ),
                iconSize: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

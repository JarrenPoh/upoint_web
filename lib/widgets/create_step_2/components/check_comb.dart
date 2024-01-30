import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';

class CheckComb extends StatefulWidget {
  final String title;
  final Function() func;
  const CheckComb({
    super.key,
    required this.title,
    required this.func,
  });

  @override
  State<CheckComb> createState() => _CheckCombState();
}

class _CheckCombState extends State<CheckComb> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        SizedBox(
          height: 16,
          width: 16,
          child: Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            side: BorderSide(color: grey300),
            checkColor: Colors.white,
            activeColor: primaryColor,
            value: _isChecked,
            onChanged: (e) {
              widget.func();
              setState(() {
                _isChecked = !_isChecked;
              });
            },
          ),
        ),
        const SizedBox(width: 4),
        RegularText(
          color: grey400,
          size: 16,
          text: widget.title,
        ),
      ],
    );
  }
}

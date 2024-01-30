import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';

class TapHoverContainer extends StatefulWidget {
  final String text;
  final Color color;
  final Color hoverColor;
  final Color borderColor;
  final Color textColor;
  const TapHoverContainer({
    super.key,
    required this.text,
    required this.hoverColor,
    required this.borderColor,
    required this.textColor,
    required this.color,
  });

  @override
  State<TapHoverContainer> createState() => _TapHoverContainerState();
}

class _TapHoverContainerState extends State<TapHoverContainer> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {
        print('hover');
        setState(() {
          isHover = value;
        });
      },
      onTap: () {
        print('tap');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 84),
        height: 39,
        decoration: BoxDecoration(
          color: isHover ? widget.hoverColor : widget.color,
          border: Border.all(
              color: widget.borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: MediumText(
            color: widget.textColor,
            size: 16,
            text: widget.text,
          ),
        ),
      ),
    );
  }
}

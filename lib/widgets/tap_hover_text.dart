import 'package:flutter/material.dart';
import 'package:upoint_web/globals/medium_text.dart';

class TapHoverText extends StatefulWidget {
  final String text;
  final double? textSize;
  final Color color;
  final Color hoverColor;
  final Function onTap;
  const TapHoverText({
    super.key,
    required this.text,
    required this.hoverColor,
    required this.color,
    required this.onTap,
    this.textSize = 16,
  });

  @override
  State<TapHoverText> createState() => _TapHoverTextState();
}

class _TapHoverTextState extends State<TapHoverText> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {
        setState(() {
          isHover = value;
        });
      },
      onTap: () {
        widget.onTap();
      },
      child: MediumText(
        color: isHover ? widget.hoverColor : widget.color,
        size: widget.textSize!,
        text: widget.text,
      ),
    );
  }
}

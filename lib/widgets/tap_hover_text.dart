import 'package:flutter/material.dart';
import 'package:upoint_web/globals/medium_text.dart';

class TopHoverText extends StatefulWidget {
  final String text;
  final double? textSize;
  final Color color;
  final Color hoverColor;
  final Function onTap;
  const TopHoverText({
    super.key,
    required this.text,
    required this.hoverColor,
    required this.color,
    required this.onTap,
    this.textSize = 16,
  });

  @override
  State<TopHoverText> createState() => _TopHoverTextState();
}

class _TopHoverTextState extends State<TopHoverText> {
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

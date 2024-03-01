import 'package:flutter/material.dart';
import 'package:upoint_web/globals/medium_text.dart';

class TapHoverContainer extends StatefulWidget {
  final String text;
  final double? textSize ;
  final Color color;
  final Color hoverColor;
  final Color borderColor;
  final Color textColor;
  final Function onTap;
  final double padding;
  final double? height;
  const TapHoverContainer({
    super.key,
    required this.text,
    required this.padding,
    required this.hoverColor,
    required this.borderColor,
    required this.textColor,
    required this.color,
    required this.onTap,
    this.textSize = 16,
        this.height = 39,

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
        setState(() {
          isHover = value;
        });
      },
      onTap: () {
        widget.onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.padding),
        height: widget.height,
        decoration: BoxDecoration(
          color: isHover ? widget.hoverColor : widget.color,
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: MediumText(
            color: widget.textColor,
            size: widget.textSize!,
            text: widget.text,
          ),
        ),
      ),
    );
  }
}

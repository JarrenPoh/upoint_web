import 'package:flutter/material.dart';

class TapHoverIcon extends StatefulWidget {
  final Color color;
  final Color hoverColor;
  final double iconSize;
  final Function onTap;
  const TapHoverIcon({
    super.key,
    required this.hoverColor,
    required this.color,
    required this.onTap,
    required this.iconSize,
  });

  @override
  State<TapHoverIcon> createState() => _TapHoverIconState();
}

class _TapHoverIconState extends State<TapHoverIcon> {
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
      child: Icon(
        Icons.add_circle_outline_rounded,
        color: isHover ? widget.hoverColor : widget.color,
        size: widget.iconSize,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/models/post_model.dart';

class CenterPicLayout extends StatefulWidget {
  final PostModel post;
  final double width;
  const CenterPicLayout({
    super.key,
    required this.post,
    required this.width,
  });

  @override
  State<CenterPicLayout> createState() => _CenterPicLayoutState();
}

class _CenterPicLayoutState extends State<CenterPicLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: grey100,
        image: DecorationImage(
          image: NetworkImage(
            widget.post.photo!,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(),
      ),
    );
  }
}

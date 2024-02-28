import 'dart:ui';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/bold_text.dart';
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
        Beamer.of(context)
            .beamToNamed('/organizer/center/post?id=${widget.post.postId!}');
      },
      child: Container(
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
          child: isHover
              ? ClipRect(
                  child: Container(
                    decoration: BoxDecoration(
                      color: grey500.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        width: 128,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const BoldText(
                          color: Colors.white,
                          size: 16,
                          text: "查看詳細內容",
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}

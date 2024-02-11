import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';

import '../../../models/post_model.dart';

class CenterBarLayout extends StatefulWidget {
  final PostModel post;

  const CenterBarLayout({
    super.key,
    required this.post,
  });

  @override
  State<CenterBarLayout> createState() => _CenterBarLayoutState();
}

class _CenterBarLayoutState extends State<CenterBarLayout> {
  late bool noLimit;
  late bool outSideForm;
  @override
  void initState() {
    super.initState();
    noLimit = widget.post.capacity == null;
    outSideForm = widget.post.form?.substring(0, 4) == "http";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: CircularPercentIndicator(
        radius: 60.0,
        animation: true,
        animationDuration: 1200,
        lineWidth: 8,
        percent: 0.5,
        center: outSideForm
            ? Column(
                children: [
                  RegularText(
                    color: grey500,
                    size: 12,
                    text: "使用外部連結",
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RegularText(
                    color: grey500,
                    size: 12,
                    text: "報名人數",
                  ),
                  noLimit
                      ? MediumText(
                          color: grey500,
                          size: 14,
                          text: "${widget.post.signList?.length ?? 0}人",
                        )
                      : MediumText(
                          color: grey500,
                          size: 14,
                          text:
                              "${widget.post.signList?.length ?? 0}/${widget.post.capacity}",
                        ),
                ],
              ),
        circularStrokeCap: CircularStrokeCap.butt,
        backgroundColor: grey200,
        progressColor: secondColor,
      ),
    );
  }
}

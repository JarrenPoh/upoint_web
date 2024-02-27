import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';

import '../../../models/post_model.dart';

// ignore: must_be_immutable
class CenterBarLayout extends StatelessWidget {
  final PostModel post;
   CenterBarLayout({
    super.key,
    required this.post,
  });

  late bool noLimit;

  late bool outSideForm;

  @override
  Widget build(BuildContext context) {
    noLimit = post.capacity == null;
    outSideForm = post.form?.substring(0, 4) == "http";
    return SizedBox(
      width: 120,
      height: 120,
      child: CircularPercentIndicator(
        radius: 60.0,
        animation: true,
        animationDuration: 1200,
        lineWidth: 8,
        percent: outSideForm || noLimit
            ? 0
            : post.signFormsLength! / post.capacity!,
        center: outSideForm
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          text: "${post.signFormsLength}人",
                        )
                      : MediumText(
                          color: grey500,
                          size: 14,
                          text:
                              "${post.signFormsLength}/${post.capacity}",
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

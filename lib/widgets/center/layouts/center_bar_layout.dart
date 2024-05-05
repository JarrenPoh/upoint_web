import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/firebase/firestore_methods.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';

import '../../../models/post_model.dart';

// ignore: must_be_immutable
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

  onChanged(v) async {
    setState(() {
      widget.post.isVisible = v;
    });
    FirestoreMethods().updateIsVisible(widget.post);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    noLimit = widget.post.capacity == null;
    outSideForm = widget.post.form?.substring(0, 4) == "http";
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularPercentIndicator(
            radius: 60.0,
            animation: true,
            animationDuration: 1200,
            lineWidth: 8,
            percent: outSideForm || noLimit
                ? 0
                : widget.post.signFormsLength! / widget.post.capacity!,
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
                              text: "${widget.post.signFormsLength}人",
                            )
                          : MediumText(
                              color: grey500,
                              size: 14,
                              text:
                                  "${widget.post.signFormsLength}/${widget.post.capacity}",
                            ),
                    ],
                  ),
            circularStrokeCap: CircularStrokeCap.butt,
            backgroundColor: grey200,
            progressColor: secondColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegularText(color: grey400, size: 12, text: "典藏"),
            Transform.scale(
              scale: 0.8,
              child: Theme(
                data: ThemeData(
                  useMaterial3: true,
                ).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                        outline: (widget.post.isVisible == true)
                            ? primaryColor
                            : grey400)),
                child: Switch(
                  value: (widget.post.isVisible == true),
                  activeColor: Colors.white,
                  activeTrackColor: primaryColor,
                  inactiveThumbColor: grey400,
                  inactiveTrackColor: Colors.white,
                  onChanged: (e) => onChanged(e),
                ),
              ),
            ),
            MediumText(color: grey500, size: 12, text: "公開"),
          ],
        ),
      ],
    );
  }
}

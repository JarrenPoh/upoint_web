import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/globals/time_transfer.dart';
import 'package:upoint_web/widgets/center/components/link_field.dart';

import '../../../models/post_model.dart';

class CenterInformLayout extends StatefulWidget {
  final PostModel post;
  final double? width;
  const CenterInformLayout({
    super.key,
    required this.post,
    required this.width,
  });

  @override
  State<CenterInformLayout> createState() => _CenterInformLayoutState();
}

class _CenterInformLayoutState extends State<CenterInformLayout> {
  late String? formUrl;
  late String dateDuration;
  @override
  void initState() {
    super.initState();
    if (widget.post.form?.substring(0, 4) == "http") {
      formUrl = widget.post.form!;
    } else if (widget.post.form != null) {
      formUrl = "https://upoint/signForm?id=${widget.post.postId}";
    }
    String _start = TimeTransfer.formatTimestampToROC(widget.post.startDate);
    String _end = TimeTransfer.formatTimestampToROC(widget.post.endDate);
    if (_start == _end) {
      dateDuration =
          "$_start${TimeTransfer.timeTrans03(widget.post.startTime!)} ~ ${TimeTransfer.timeTrans03(widget.post.endTime!)}";
    } else {
      dateDuration =
          "$_start${TimeTransfer.timeTrans03(widget.post.startTime!)} ~ $_end${TimeTransfer.timeTrans03(widget.post.endTime!)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17),
      height: 300 / 16 * 9,
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: subColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: MediumText(
              color: grey500,
              size: 16,
              text: widget.post.title!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RegularText(
                    color: grey500, size: 14, text: "活動時間：$dateDuration"),
                const SizedBox(height: 8),
                RegularText(
                    color: grey500,
                    size: 14,
                    text: "活動地點：${widget.post.location}"),
              ],
            ),
          ),
          formUrl == null
              ? RegularText(
                  color: grey500,
                  size: 14,
                  text: "此活動無表單",
                )
              : LinkField(formUrl: formUrl),
        ],
      ),
    );
  }
}

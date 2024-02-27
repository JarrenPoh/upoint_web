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
  String? formUrl;
  String dateDuration = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.form?.substring(0, 4) == "http") {
      formUrl = widget.post.form!;
    } else if (widget.post.form != null) {
      formUrl = "https://upoint.tw/signForm?id=${widget.post.postId}";
    }
    dateDuration = TimeTransfer.timeTrans05(
        widget.post.startDateTime, widget.post.endDateTime);
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
                  text: "此活動無需報名",
                )
              : LinkField(formUrl: formUrl),
        ],
      ),
    );
  }
}

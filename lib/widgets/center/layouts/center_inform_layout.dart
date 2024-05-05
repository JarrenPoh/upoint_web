import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/globals/time_transfer.dart';
import 'package:upoint_web/widgets/center/components/link_field.dart';
import '../../../firebase/dynamic_link_service.dart';
import '../../../models/post_model.dart';

class CenterInformLayout extends StatelessWidget {
  final PostModel post;
  final double? width;
  const CenterInformLayout({
    super.key,
    required this.post,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    String? formUrl;
    String dateDuration = "";
    if (post.form?.substring(0, 4) == "http") {
      formUrl = post.form!;
    } else if (post.form != null) {
      formUrl = "https://upoint.tw/signForm?id=${post.postId}";
    }
    dateDuration =
        TimeTransfer.timeTrans05(post.startDateTime, post.endDateTime);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      height: 300 / 16 * 9,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 活動名稱
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: subColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: MediumText(
              color: grey500,
              size: 16,
              text: post.title!,
            ),
          ),
          RegularText(color: grey500, size: 14, text: "活動時間：$dateDuration"),
          RegularText(color: grey500, size: 14, text: "活動地點：${post.location}"),
          formUrl == null
              ? RegularText(
                  color: grey500,
                  size: 14,
                  text: "此活動無需報名",
                )
              : LinkField(url: formUrl, title: "報名連結"),
          FutureBuilder(
              future: DynamicLinkService().createDynamicLink(post),
              builder: (context, shapshot) {
                String? url = shapshot.data;
                if (shapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 30,
                    width: 350,
                    color: grey100,
                  );
                } else if (shapshot.hasError) {
                  return Text('Error: ${shapshot.error}');
                } else {
                  return LinkField(url: url, title: "APP連結");
                }
              }),
        ],
      ),
    );
  }
}

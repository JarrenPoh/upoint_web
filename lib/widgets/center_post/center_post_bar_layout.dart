import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/globals/time_transfer.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

import '../center/components/link_field.dart';
import '../center/layouts/center_bar_layout.dart';

class CenterPostBarLayout extends StatelessWidget {
  final PostModel post;
  final OrganizerModel organizer;
  const CenterPostBarLayout({
    super.key,
    required this.post,
    required this.organizer,
  });

  @override
  build(BuildContext context) {
    String? formUrl;
    bool useUpointForm = true;
    if (post.form == null || post.form?.substring(0, 4) == 'http') {
      useUpointForm = false;
    }
    if (post.form?.substring(0, 4) == "http") {
      formUrl = post.form!;
    } else if (post.form != null) {
      formUrl = "https://upoint.tw/signForm?id=${post.postId}";
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // 陰影顏色
            spreadRadius: 1, // 陰影範圍
            blurRadius: 10, // 模糊半徑
            offset: const Offset(0, 1), // 陰影位置的偏移量
          ),
        ],
      ),
      child: Column(
        children: [
          // circle bar
          SizedBox(
            width: 137,
            height: 137,
            child: CenterBarLayout(post: post,organizer: organizer),
          ),
          const SizedBox(height: 16),
          // 截止時間
          RegularText(
              color: grey500,
              size: 14,
              text:
                  "截止日期：${TimeTransfer.timeTrans03(post.endDateTime)}${TimeTransfer.timeTrans04(post.endDateTime)}"),
          const SizedBox(height: 16),
          // 連結複製區
          formUrl == null
              ? RegularText(
                  color: grey500,
                  size: 14,
                  text: "此活動無需報名",
                )
              : LinkField(url: formUrl, title: "報名連結"),
          const SizedBox(height: 16),
          // 報名資訊按鈕
          TapHoverContainer(
            text: useUpointForm == false ? "無採用UPoint表單" : "報名資訊",
            padding: 16,
            hoverColor: grey100,
            borderColor: useUpointForm == false ? grey500 : primaryColor,
            textColor: useUpointForm == false ? grey500 : primaryColor,
            color: Colors.white,
            onTap: () {
              if (useUpointForm) {
                Beamer.of(context).beamToNamed(
                    '/organizer/center/signForm?id=${post.postId!}');
              } else {
                Messenger.snackBar(context, "此活動無採用UPoint表單");
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/layouts/center_post_edit_layout.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';
import 'package:upoint_web/widgets/tap_hover_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../globals/regular_text.dart';
import '../../globals/time_transfer.dart';

class CenterPostInformLayout extends StatelessWidget {
  final PostModel post;
  final OrganizerModel organizer;
  const CenterPostInformLayout({
    super.key,
    required this.post,
    required this.organizer,
  });

  @override
  Widget build(BuildContext context) {
    final QuillController _controller = QuillController.basic();
    _controller.document = Document.fromJson(jsonDecode(post.content!));
    List informList = [
      {
        "type": "front",
        "icon": Icons.calendar_month,
        "text": TimeTransfer.timeTrans05(
          post.startDateTime,
          post.endDateTime,
        ),
      },
      {
        "type": "front",
        "icon": Icons.location_on,
        "text": post.location,
      },
      {
        "type": "front",
        "icon": Icons.local_play,
        "text": post.reward ?? "無",
      },
      {
        "title": "主辦單位：",
        "type": "back",
        "icon": Icons.home,
        "text": post.organizerName,
      },
      {
        "title": "聯絡人：",
        "type": "back",
        "icon": Icons.person,
        "text": post.contact ?? "無",
      },
      {
        "title": "聯絡方式：",
        "type": "back",
        "icon": Icons.phone,
        "text": post.phoneNumber ?? "無",
      },
      {
        "title": "相關連結：",
        "type": "back",
        "icon": Icons.link,
        "text": post.link ?? "無",
        "index": "link"
      },
    ];
    return Container(
      width: 612,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 大標題
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MediumText(color: grey500, size: 32, text: post.title!),
              TapHoverContainer(
                text: "編輯",
                height: 32,
                textSize: 14,
                padding: 13,
                hoverColor: secondColor,
                borderColor: Colors.transparent,
                textColor: Colors.white,
                color: primaryColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CenterPostEditLayout(
                        organizer: organizer,
                        post: post,
                      );
                    },
                  ),
                ),
                // onTap: () => Messenger.snackBar(
                //   context,
                //   "尚未開放此功能，敬請期待",
                // ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 活動標籤
          if (post.tags != null)
            Wrap(
              runSpacing: 8,
              spacing: 12,
              children: [
                for (var i in post.tags!) _tagWidget(i),
              ],
            ),
          const SizedBox(height: 15),
          Divider(color: grey200),
          const SizedBox(height: 18),
          // 時間 地點 獎勵
          SizedBox(
            height: 88,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var inform
                    in informList.where((e) => e["type"] == "front").toList())
                  Row(
                    children: [
                      Icon(
                        inform["icon"],
                        size: 24,
                        color: grey400,
                      ),
                      const SizedBox(width: 6),
                      RegularText(
                        color: grey500,
                        size: 14,
                        text: inform["text"],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // 介紹內容
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: grey200),
            ),
            child: RegularText(
              color: grey500,
              size: 14,
              text: post.introduction!,
              maxLines: 20,
            ),
          ),
          const SizedBox(height: 18),
          // 主辦資訊
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: MediumText(
              color: grey500,
              size: 16,
              text: "主辦資訊",
            ),
          ),
          Divider(color: grey200),
          const SizedBox(height: 12),
          // 主辦資訊內容
          SizedBox(
            height: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var inform
                    in informList.where((e) => e["type"] == "back").toList())
                  inform["index"] == "link" && post.link == null
                      ? Container()
                      : Row(
                          children: [
                            Icon(
                              inform["icon"],
                              size: 24,
                              color: grey400,
                            ),
                            const SizedBox(width: 6),
                            RegularText(
                              color: grey500,
                              size: 14,
                              text: inform["title"],
                            ),
                            inform["index"] == "link"
                                ? TapHoverText(
                                    textSize: 14,
                                    text: inform["text"],
                                    hoverColor: secondColor,
                                    color: primaryColor,
                                    onTap: () => launchUrl(
                                      Uri.parse(inform["text"]),
                                    ),
                                  )
                                : RegularText(
                                    color: grey500,
                                    size: 14,
                                    text: inform["text"],
                                  ),
                          ],
                        ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // 活動詳情標題
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: MediumText(
              color: grey500,
              size: 16,
              text: "活動詳情",
            ),
          ),
          Divider(color: grey200),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: grey200),
            ),
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagWidget(String tag) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: grey200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Text(
              "#",
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 3),
            MediumText(
              color: grey500,
              size: 14,
              text: tag,
            ),
          ],
        ),
      ),
    );
  }
}

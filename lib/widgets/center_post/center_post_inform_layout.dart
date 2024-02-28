import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/post_model.dart';

import '../../globals/regular_text.dart';
import '../../globals/time_transfer.dart';

class CenterPostInformLayout extends StatelessWidget {
  final PostModel post;
  const CenterPostInformLayout({
    super.key,
    required this.post,
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
          MediumText(color: grey500, size: 32, text: post.title!),
          const SizedBox(height: 12),
          // 活動標籤
          Wrap(
            runSpacing: 8,
            spacing: 12,
            children: [
              for (var i in post.tags!) _tagWidget(i),
            ],
          ),
          const SizedBox(height: 15),
          Divider(color: divColor),
          const SizedBox(height: 16),
          // 時間 地點 獎勵
          SizedBox(
            height: 88,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var inform in informList)
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
          const SizedBox(height: 16),
          // 介紹內容
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: divColor),
            ),
            child: RegularText(
              color: grey500,
              size: 14,
              text: post.introduction!,
              maxLines: 20,
            ),
          ),
          const SizedBox(height: 16),
          // 活動詳情標題
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: MediumText(
              color: grey500,
              size: 20,
              text: "活動詳情",
            ),
          ),
          Divider(color: divColor),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: divColor),
            ),
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                readOnly: true,
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
        color: grey100,
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

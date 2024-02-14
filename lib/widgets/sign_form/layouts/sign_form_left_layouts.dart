import 'package:flutter/material.dart';
import 'package:upoint_web/models/post_model.dart';
import '../../../color.dart';
import '../../../globals/regular_text.dart';
import '../../../globals/time_transfer.dart';

class SignFormLeftLayout extends StatelessWidget {
  final PostModel post;
  const SignFormLeftLayout({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    String title = post.title!;
    String location = post.location!;
    String dateDuration = "";
   String _start = TimeTransfer.timeTrans03(post.startDateTime);
    String _end = TimeTransfer.timeTrans03(post.endDateTime);
    if (_start == _end) {
      dateDuration =
          "$_start${TimeTransfer.timeTrans04(post.startDateTime!)} ~ ${TimeTransfer.timeTrans04(post.endDateTime!)}";
    } else {
      dateDuration =
          "$_start${TimeTransfer.timeTrans04(post.startDateTime!)} ~ $_end${TimeTransfer.timeTrans04(post.endDateTime!)}";
    }
    String organizerName = post.organizerName!;
    return SizedBox(
      width: 373,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 照片
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              width: 295,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: grey300),
                color: grey100,
                image: DecorationImage(
                  image: NetworkImage(post.photo!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          IntrinsicWidth(
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: subColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: RegularText(
                  color: grey500,
                  size: 16,
                  text: title,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                RegularText(
                    color: grey500, size: 14, text: "活動時間：$dateDuration"),
                const SizedBox(height: 8),
                RegularText(color: grey500, size: 14, text: "活動地點：$location"),
                const SizedBox(height: 8),
                RegularText(
                    color: grey500, size: 14, text: "主辦單位：$organizerName"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

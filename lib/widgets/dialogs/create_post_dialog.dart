import 'package:flutter/material.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

import '../../color.dart';
import '../../globals/bold_text.dart';
import '../../globals/medium_text.dart';
import '../../globals/regular_text.dart';

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({super.key});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  bool isVisible = false;
  onChanged(v) async {
    setState(() {
      isVisible = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 450,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error, color: primaryColor, size: 44),
          const SizedBox(height: 20),
          BoldText(
            color: grey500,
            size: 16,
            text: "創建活動須知事項",
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediumText(
                color: grey500,
                size: 14,
                maxLines: 4,
                text: '典藏：使用者無法看到活動',
              ),
              const SizedBox(height: 10),
              MediumText(
                color: grey500,
                size: 14,
                maxLines: 4,
                text: '公開：創建貼文後立即公開，系統將自動發送創建通知給追蹤者',
              ),
              const SizedBox(height: 20),
              MediumText(
                color: grey400,
                size: 14,
                maxLines: 4,
                text: '管理方可事後於“活動中心頁面"中切換至公開',
              ),
            ],
          ),
          const SizedBox(height: 20),
          switchVisible(),
          const SizedBox(height: 20),
          TapHoverContainer(
            text: "確定",
            padding: 0,
            hoverColor: secondColor,
            borderColor: Colors.transparent,
            textColor: Colors.white,
            color: primaryColor,
            onTap: () => Navigator.of(context).pop(
              {"status": 'success', "isVisible": isVisible},
            ),
          ),
          const SizedBox(height: 5),
          TapHoverContainer(
            text: "取消",
            padding: 0,
            hoverColor: grey200,
            borderColor: Colors.transparent,
            textColor: grey500,
            color: Colors.transparent,
            onTap: () => Navigator.of(context).pop(
              {"status": 'cancel'},
            ),
          ),
        ],
      ),
    );
  }

  switchVisible() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RegularText(color: grey400, size: 12, text: "典藏"),
        SizedBox(width: 10),
        Transform.scale(
          scale: 0.8,
          child: Theme(
            data: ThemeData(
              useMaterial3: true,
            ).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    outline: (isVisible == true) ? primaryColor : grey400,
                  ),
            ),
            child: Switch(
              value: (isVisible == true),
              activeColor: Colors.white,
              activeTrackColor: primaryColor,
              inactiveThumbColor: grey400,
              inactiveTrackColor: Colors.white,
              onChanged: (e) => onChanged(e),
            ),
          ),
        ),
        SizedBox(width: 10),
        MediumText(color: grey500, size: 12, text: "公開"),
      ],
    );
  }
}

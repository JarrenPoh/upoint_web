import 'package:flutter/material.dart';

import '../../color.dart';
import '../../globals/bold_text.dart';
import '../../globals/medium_text.dart';
import '../tap_hover_container.dart';

class AddLinkDialog extends StatefulWidget {
  final String text;
  final String url;
  const AddLinkDialog({
    super.key,
    required this.text,
    required this.url,
  });

  @override
  State<AddLinkDialog> createState() => _AddLinkDialogState();
}

class _AddLinkDialogState extends State<AddLinkDialog> {
  late final TextEditingController textController =
      TextEditingController(text: widget.text);
  late final TextEditingController urlController =
      TextEditingController(text: widget.url);
  bool errorText = false;
  bool errorUrl = false;
  late bool hasInit = widget.text.isNotEmpty && widget.url.isNotEmpty;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 420,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BoldText(
            color: grey500,
            size: 16,
            text: "新增連結",
          ),
          SizedBox(height: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediumText(color: grey500, size: 14, text: "*標籤顯示的文字"),
                const SizedBox(height: 5),
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: TextStyle(color: grey500),
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    hintText: "例如：UPoint",
                    hintStyle: TextStyle(color: grey400),
                    contentPadding: const EdgeInsets.only(
                      left: 8,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: errorText ? Colors.red : grey200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MediumText(color: grey500, size: 14, text: "連結網址"),
                const SizedBox(height: 5),
                TextField(
                  controller: urlController,
                  autofocus: true,
                  style: TextStyle(color: grey500),
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    hintText: "例如：https://upoint.tw",
                    hintStyle: TextStyle(color: grey400),
                    contentPadding: const EdgeInsets.only(
                      left: 8,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: errorUrl ? Colors.red : grey200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TapHoverContainer(
            text: "確定",
            padding: 0,
            hoverColor: secondColor,
            borderColor: Colors.transparent,
            textColor: Colors.white,
            color: primaryColor,
            onTap: () {
              if (textController.text.trim().isEmpty) {
                setState(() {
                  errorText = true;
                });
              } else if (urlController.text.trim().isEmpty) {
                setState(() {
                  errorUrl = true;
                });
              } else {
                Navigator.of(context).pop(
                  {
                    "status": 'success',
                    "text": textController.text.trim(),
                    "url": urlController.text.trim(),
                  },
                );
              }
            },
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
          const SizedBox(height: 5),
          if (hasInit)
            TapHoverContainer(
              text: "刪除",
              padding: 0,
              hoverColor: grey400,
              borderColor: Colors.transparent,
              textColor: Colors.white,
              color: grey500,
              onTap: () => Navigator.of(context).pop(
                {"status": 'delete'},
              ),
            ),
        ],
      ),
    );
  }
}

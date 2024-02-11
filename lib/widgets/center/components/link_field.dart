import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';

import '../../tap_hover_container.dart';

class LinkField extends StatefulWidget {
  final String? formUrl;
  const LinkField({
    super.key,
    required this.formUrl,
  });

  @override
  State<LinkField> createState() => _LinkFieldState();
}

class _LinkFieldState extends State<LinkField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.formUrl);
  }

  bool isTap = false;
  void copyToClipboard(String text, BuildContext context) {
    setState(() {
      isTap = true;
    });
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      // 显示复制成功的提示
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content:const Text(
            '复制成功',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 75,
            decoration: BoxDecoration(
              color: grey100,
              border: Border(
                right: BorderSide(color: grey200),
              ),
            ),
            child: Center(
              child: RegularText(
                color: grey500,
                size: 14,
                text: "報名連結",
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: controller,
                readOnly: true,
                style: TextStyle(
                  color: grey500,
                  fontSize: 12,
                  fontFamily: "NotoSansRegular",
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 17),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          TapHoverContainer(
              text: isTap ? "已複製" : "複製",
              textSize: 14,
              padding: 10,
              hoverColor: grey100,
              borderColor: Colors.white,
              textColor: isTap ? grey400 : secondColor,
              color: Colors.white,
              onTap: () => copyToClipboard("", context)),
        ],
      ),
    );
  }
}
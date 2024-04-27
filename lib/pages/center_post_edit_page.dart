import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

class CenterPostEditPage extends StatefulWidget {
  final Widget child;
  final bool isWeb;
  final Function send;
  const CenterPostEditPage({
    super.key,
    required this.child,
    required this.isWeb,
    required this.send,
  });

  @override
  State<CenterPostEditPage> createState() => _CenterPostEditPageState();
}

class _CenterPostEditPageState extends State<CenterPostEditPage> {
  @override
  void initState() {
    super.initState();
  }

  late Function(BuildContext context) onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: MediumText(color: grey500, size: 20, text: "編輯貼文"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Container(
                width: widget.isWeb ? 1076 : 543,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 48, horizontal: 64),
                child: Column(
                  children: [
                    widget.child,
                    // 送出報名
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TapHoverContainer(
                          padding: widget.isWeb ? 84 : 40,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: "返回",
                          hoverColor: grey100,
                          color: Colors.white,
                          borderColor: primaryColor,
                          textColor: primaryColor,
                        ),
                        TapHoverContainer(
                          padding: widget.isWeb ? 84 : 40,
                          onTap: () => widget.send(),
                          text: "確認修改",
                          color: primaryColor,
                          hoverColor: secondColor,
                          borderColor: primaryColor,
                          textColor: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

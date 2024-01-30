import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

class CreatePage extends StatefulWidget {
  final Widget child;
  const CreatePage({
    super.key,
    required this.child,
  });

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Container(
          width: 1076,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 64),
          child: Column(
            children: [
              widget.child,
              // 送出報名
              const SizedBox(height: 108),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TapHoverContainer(
                    text: "回活動資訊",
                    hoverColor: grey100,
                    color: Colors.white,
                    borderColor: primaryColor,
                    textColor: primaryColor,
                  ),
                  TapHoverContainer(
                    text: "下一步",
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
    );
  }
}

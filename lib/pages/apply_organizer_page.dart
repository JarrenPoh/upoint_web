import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

class ApplyOrganizerPage extends StatefulWidget {
  final bool isWeb;
  final Widget child;
  const ApplyOrganizerPage({
    super.key,
    required this.isWeb,
    required this.child,
  });

  @override
  State<ApplyOrganizerPage> createState() => _ApplyOrganizerPageState();
}

class _ApplyOrganizerPageState extends State<ApplyOrganizerPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 38),
                  Container(
                    width: 170,
                    height: 45,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: MediumText(
                        color: Colors.white,
                        size: 18,
                        text: "主辦單位資訊",
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 145),
                        child: widget.child,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TapHoverContainer(
                        text: "提交申請",
                        padding: widget.isWeb ? 84 : 22,
                        hoverColor: secondColor,
                        borderColor: Colors.transparent,
                        textColor: Colors.white,
                        color: primaryColor,
                        onTap: () => Messenger.snackBar(context, "尚未開放此功能"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

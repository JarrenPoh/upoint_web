import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';

class SignUpFormPage extends StatefulWidget {
  final bool isWeb;
  final Widget child;
  const SignUpFormPage({
    super.key,
    required this.isWeb,
    required this.child,
  });

  @override
  State<SignUpFormPage> createState() => _SignUpFormPageState();
}

class _SignUpFormPageState extends State<SignUpFormPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Container(
                  width: widget.isWeb ? 1076 : 543,
                  padding:
                      const EdgeInsets.symmetric(vertical: 48, horizontal: 64),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: widget.child,
                ),
              ),
              Row(
                children: [
                  RegularText(
                    color: grey500,
                    size: 18,
                    text: "掃描下載 Upoint App 獲取更多活動資訊！",
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

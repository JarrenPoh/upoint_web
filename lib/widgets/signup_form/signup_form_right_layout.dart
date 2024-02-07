import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';

class SignUpFormRightLayout extends StatefulWidget {
  const SignUpFormRightLayout({super.key});

  @override
  State<SignUpFormRightLayout> createState() => _SignUpFormRightLayoutState();
}

class _SignUpFormRightLayoutState extends State<SignUpFormRightLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 543,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: grey300),
      ),
      child: Column(
        children: [
          Container(
            height: 73,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                color: grey100),
            child: Center(
              child: MediumText(
                color: grey500,
                size: 16,
                text: '報名表單',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: List.generate(
                0,
                (index) {
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

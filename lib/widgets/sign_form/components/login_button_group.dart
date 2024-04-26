import 'package:flutter/material.dart';
import 'package:upoint_web/models/user_model.dart';
import '../../../color.dart';
import '../../../globals/medium_text.dart';

class ChoseLoginButton extends StatefulWidget {
  final String text;
  final bool isActive;
  final Function onTap;
  final UserModel? user;
  const ChoseLoginButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
    required this.user,
  });

  @override
  State<ChoseLoginButton> createState() => _ChoseLoginButtonState();
}

class _ChoseLoginButtonState extends State<ChoseLoginButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: Container(
        height: 44,
        margin: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          border: Border.all(color: grey300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                border: Border.all(
                  color: widget.isActive ? primaryColor : grey300,
                ),
              ),
              child: Icon(
                Icons.circle,
                size: 10,
                color: widget.isActive ? primaryColor : Colors.transparent,
              ),
            ),
            MediumText(
              color: grey500,
              size: 16,
              text: widget.text,
            ),
            const SizedBox(width: 7),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/models/organizer_model.dart';

import '../tap_hover_container.dart';

class InformAvatarLayout extends StatefulWidget {
  final OrganizerModel organizer;
  const InformAvatarLayout({
    super.key,
    required this.organizer,
  });

  @override
  State<InformAvatarLayout> createState() => _InformAvatarLayoutState();
}

class _InformAvatarLayoutState extends State<InformAvatarLayout> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 349,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 90,
            backgroundColor: subColor,
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: grey100,
                borderRadius: BorderRadius.circular(80),
                image: DecorationImage(
                  image: NetworkImage(widget.organizer.pic!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TapHoverContainer(
            text: "編輯照片",
            padding: 58,
            hoverColor: grey100,
            borderColor: primaryColor,
            textColor: primaryColor,
            color: Colors.white,
            onTap: () => Messenger.snackBar(context, "尚未開放此功能"),
          ),
        ],
      ),
    );
  }
}

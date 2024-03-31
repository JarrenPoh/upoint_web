import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/apply_organizer_bloc.dart';
import 'package:upoint_web/color.dart';
import '../tap_hover_container.dart';

class ApplyOrganizerAvatarLayout extends StatefulWidget {
  final ApplyOrganizerBloc bloc;
  const ApplyOrganizerAvatarLayout({
    super.key,
    required this.bloc,
  });

  @override
  State<ApplyOrganizerAvatarLayout> createState() =>
      _ApplyOrganizerAvatarLayoutState();
}

class _ApplyOrganizerAvatarLayoutState
    extends State<ApplyOrganizerAvatarLayout> {
  String? _base64Image;
  @override
  void initState() {
    super.initState();
    widget.bloc.refreshImage = (String base64Image) {
      setState(() {
        _base64Image = base64Image;
      });
    };
  }

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
                image: _base64Image != null
                    ? DecorationImage(
                        image: MemoryImage(
                          base64Decode(
                            _base64Image!,
                          ),
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
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
            onTap: () async {
              await widget.bloc.pickImage(context);
            },
          ),
        ],
      ),
    );
  }
}

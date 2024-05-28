import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/inform_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/widgets/center/components/link_field.dart';

import '../tap_hover_container.dart';

class InformAvatarLayout extends StatefulWidget {
  final OrganizerModel organizer;
  final InformBloc bloc;
  const InformAvatarLayout({
    super.key,
    required this.organizer,
    required this.bloc,
  });

  @override
  State<InformAvatarLayout> createState() => _InformAvatarLayoutState();
}

class _InformAvatarLayoutState extends State<InformAvatarLayout> {
  late String pic = widget.organizer.pic!;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 349,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  image: NetworkImage(pic),
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
            onTap: () async {
              Map res = await widget.bloc.pickImage(widget.organizer, context);
              setState(() {
                pic = res["pic"];
              });
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: LinkField(
              url: "https://upoint.tw/organizer/inform?rc=${widget.organizer.uid}",
              title: "推薦連結",
            ),
          ),
        ],
      ),
    );
  }
}

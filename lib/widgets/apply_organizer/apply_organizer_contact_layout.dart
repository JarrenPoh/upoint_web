import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/apply_organizer_bloc.dart';
import '../../color.dart';
import '../../globals/medium_text.dart';
import '../underscore_textfield.dart';

class ApplyOrganizerContactLayout extends StatefulWidget {
  final bool isWeb;
  final ApplyOrganizerBloc bloc;
  const ApplyOrganizerContactLayout({
    super.key,
    required this.isWeb,
    required this.bloc,
  });

  @override
  State<ApplyOrganizerContactLayout> createState() =>
      _ApplyOrganizerContactLayoutState();
}

class _ApplyOrganizerContactLayoutState
    extends State<ApplyOrganizerContactLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumText(
          color: grey500,
          size: 18,
          text: "聯絡人資料",
        ),
        for (var i in widget.bloc.contactList)
          Column(
            children: [
              const SizedBox(height: 24),
              UnderscoreTextField(
                text: i["index"] == "email"
                    ? FirebaseAuth.instance.currentUser?.email
                    : null,
                padLeft: widget.isWeb ? 22 : 6,
                hintText: i["title"],
                onChanged: (String e) {
                  widget.bloc.onTextChanged(i["index"], e);
                },
              ),
            ],
          ),
      ],
    );
  }
}

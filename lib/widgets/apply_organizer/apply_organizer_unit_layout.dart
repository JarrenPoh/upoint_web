import 'package:flutter/material.dart';

import '../../bloc/apply_organizer_bloc.dart';
import '../../color.dart';
import '../../globals/medium_text.dart';
import '../underscore_textfield.dart';

class ApplyOrganizerUnitLayout extends StatefulWidget {
  final ApplyOrganizerBloc bloc;
  final bool isWeb;
  const ApplyOrganizerUnitLayout({
    super.key,
    required this.bloc,
    required this.isWeb,
  });

  @override
  State<ApplyOrganizerUnitLayout> createState() =>
      _ApplyOrganizerUnitLayoutState();
}

class _ApplyOrganizerUnitLayoutState extends State<ApplyOrganizerUnitLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        MediumText(
          color: grey500,
          size: 18,
          text: "單位資料",
        ),
        for (var i in widget.bloc.unitList)
          Column(
            children: [
              const SizedBox(height: 25),
              UnderscoreTextField(
                text: null,
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

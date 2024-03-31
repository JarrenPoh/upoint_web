import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/apply_organizer_bloc.dart';

import '../../color.dart';
import '../../globals/medium_text.dart';
import '../underscore_textfield.dart';

class ApplyOrganizerCommonLayout extends StatefulWidget {
  final bool isWeb;
  final ApplyOrganizerBloc bloc;
  const ApplyOrganizerCommonLayout({
    super.key,
    required this.isWeb,
    required this.bloc,
  });

  @override
  State<ApplyOrganizerCommonLayout> createState() =>
      _ApplyOrganizerCommonLayoutState();
}

class _ApplyOrganizerCommonLayoutState
    extends State<ApplyOrganizerCommonLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        MediumText(
          color: grey500,
          size: 18,
          text: "基本資料",
        ),
        for (var i in widget.bloc.commonList)
          Column(
            children: [
              const SizedBox(height: 25),
              UnderscoreTextField(
                text: i["index"] == "unit" ? "中原大學" : null,
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

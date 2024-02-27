import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../bloc/center_bloc.dart';
import '../../../color.dart';
import '../../../globals/medium_text.dart';

// ignore: must_be_immutable
class SearchTimeDropdown extends StatefulWidget {
  final CenterBloc bloc;
  SearchTimeDropdown({
    super.key,
    required this.bloc,
  });

  @override
  State<SearchTimeDropdown> createState() => _SearchTimeDropdownState();
}

class _SearchTimeDropdownState extends State<SearchTimeDropdown> {
  String searchText = "最新到舊";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          customButton: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: grey300),
            ),
            child: Row(
              children: [
                MediumText(
                  color: grey500,
                  size: 16,
                  text: searchText,
                ),
                const Expanded(child: Column(children: [])),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: grey400,
                  size: 26,
                ),
              ],
            ),
          ),
          hint: MediumText(
            color: grey500,
            size: 16,
            text: "全部",
          ),
          value: searchText,
          isExpanded: true,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                searchText = value;
              });
            }
          },
          dropdownStyleData: DropdownStyleData(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: grey300),
            ),
            offset: const Offset(0, 8),
          ),
          items: [
            DropdownMenuItem<String>(
              value: "最新到舊",
              child: MediumText(
                color: grey500,
                size: 14,
                text: "最新到舊",
              ),
            ),
            DropdownMenuItem<String>(
              value: "最舊到新",
              child: MediumText(
                color: grey500,
                size: 14,
                text: "最舊到新",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

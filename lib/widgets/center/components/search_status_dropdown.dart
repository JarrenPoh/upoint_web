import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../bloc/center_bloc.dart';
import '../../../color.dart';
import '../../../globals/medium_text.dart';

// ignore: must_be_immutable
class SearchStatusDropdown extends StatefulWidget {
  final CenterBloc bloc;
  const SearchStatusDropdown({
    super.key,
    required this.bloc,
  });

  @override
  State<SearchStatusDropdown> createState() => _SearchStatusDropdownState();
}

class _SearchStatusDropdownState extends State<SearchStatusDropdown> {
  String searchText = "即將開始的活動";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
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
            text: "即將開始的活動",
          ),
          value: searchText,
          isExpanded: true,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                searchText = value;
              });
              widget.bloc.searchStatus = searchText;
              widget.bloc.fetchInitialPosts();
            }
          },
          dropdownStyleData: DropdownStyleData(
            padding: const EdgeInsets.symmetric(
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
              value: "即將開始的活動",
              child: MediumText(
                color: grey500,
                size: 14,
                text: "即將開始的活動",
              ),
            ),
            DropdownMenuItem<String>(
              value: "進行中的活動",
              child: MediumText(
                color: grey500,
                size: 14,
                text: "進行中的活動",
              ),
            ),
            DropdownMenuItem<String>(
              value: "已結束的活動",
              child: MediumText(
                color: grey500,
                size: 14,
                text: "已結束的活動",
              ),
            ),
            DropdownMenuItem<String>(
              value: "全選",
              child: MediumText(
                color: grey500,
                size: 14,
                text: "全選",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

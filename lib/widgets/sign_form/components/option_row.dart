import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/sign_form_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/widgets/sign_form/components/long_field.dart';
import 'package:upoint_web/widgets/sign_form/components/short_field.dart';

class OptionRow extends StatefulWidget {
  final OptionModel option;
  final SignFormBloc bloc;
  final int index;
  const OptionRow({
    super.key,
    required this.option,
    required this.bloc,
    required this.index,
  });

  @override
  State<OptionRow> createState() => _OptionRowState();
}

class _OptionRowState extends State<OptionRow> {
  Widget _widget = Container();
  late List _signForm;
  var init;
  @override
  void initState() {
    super.initState();
    if (UserSimplePreference.getSignForm() != "") {
      _signForm = jsonDecode(UserSimplePreference.getSignForm());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> shortList = ["single", "multi", "gender", "meal"];
    if (shortList.contains(widget.option.type)) {
      _widget = ShortField(
        option: widget.option,
        onChanged: (e) => widget.bloc.onShortFieldChanged(e, widget.index),
        initList: _signForm[widget.index]["value"] == ""
            ? []
            : _signForm[widget.index]["value"],
      );
    } else {
      _widget = LongField(
        option: widget.option,
        initText: _signForm[widget.index]["value"],
        onChanged: (e) => widget.bloc.onLongFieldChanged(e, widget.index),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 17),
        Row(
          children: [
            if (widget.option.necessary)
              Text(
                '*',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            MediumText(color: grey500, size: 16, text: widget.option.subtitle),
          ],
        ),
        // 說明文字
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 10),
          child: widget.option.explain != null
              ? MediumText(
                  color: grey400, size: 14, text: widget.option.explain!)
              : const SizedBox(),
        ),
        _widget,
      ],
    );
  }
}

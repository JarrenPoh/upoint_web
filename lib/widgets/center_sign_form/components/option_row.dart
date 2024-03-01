import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/widgets/center_sign_form/components/long_field.dart';
import 'package:upoint_web/widgets/center_sign_form/components/short_field.dart';

class OptionRow extends StatefulWidget {
  final OptionModel option;
  final int index;
  const OptionRow({
    super.key,
    required this.option,
    required this.index,
  });

  @override
  State<OptionRow> createState() => _OptionRowState();
}

class _OptionRowState extends State<OptionRow> {
  Widget _widget = Container();
  var init;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    List<String> shortList = ["single", "multi", "gender", "meal"];
    if (shortList.contains(widget.option.type)) {
      _widget = ShortField(
        option: widget.option,
        initList: [],
      );
    } else {
      _widget = LongField(
        option: widget.option,
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

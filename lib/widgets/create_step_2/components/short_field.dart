import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/widgets/create_step_2/components/none_decor_text_field.dart';

class ShortField extends StatelessWidget {
  final int? index;
  final String attribute;
  final OptionModel option;
  const ShortField({
    super.key,
    required this.attribute,
    required this.index,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    List radioList = ["gender", "meal", "single"];
    return Container(
      height: 44,
      margin: const EdgeInsets.only(right: 22, bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: grey300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(radioList.contains(option.type) ? 10 : 5),
              border: Border.all(color: grey300),
            ),
          ),
          IntrinsicWidth(
            child: NoneDecorTextField(
              attribute: attribute,
              fontSize: 16,
              index: index,
              option: option,
            ),
          ),
          const SizedBox(width: 7),
        ],
      ),
    );
  }
}

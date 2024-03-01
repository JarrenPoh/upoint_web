import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/widgets/center_sign_form/components/option_row.dart';
import '../../../models/form_model.dart';

class CenterSignInformSignForm extends StatefulWidget {
  final List<FormModel> formList;
  final String postId;
  const CenterSignInformSignForm({
    super.key,
    required this.formList,
    required this.postId,
  });

  @override
  State<CenterSignInformSignForm> createState() => _CenterSignInformSignFormState();
}

class _CenterSignInformSignFormState extends State<CenterSignInformSignForm> {
  var _count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 543,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: grey300),
      ),
      child: Column(
        children: [
          Container(
            height: 73,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                color: grey100),
            child: Center(
              child: MediumText(
                color: grey500,
                size: 16,
                text: '報名表單',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: List.generate(
                widget.formList.length,
                (index) {
                  return Column(
                    children: [
                      const SizedBox(height: 36),
                      _title(widget.formList[index].title),
                      const SizedBox(height: 8),
                      Column(
                        children: List.generate(
                          widget.formList[index].options.length,
                          (i) {
                            _count++;
                            return OptionRow(
                              option: widget.formList[index].options[i],
                              index: _count - 1,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 29),
        ],
      ),
    );
  }

  Widget _title(String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 22,
          color: primaryColor,
        ),
        const SizedBox(width: 12),
        MediumText(
          color: grey500,
          size: 18,
          text: text,
        ),
      ],
    );
  }
}

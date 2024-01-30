import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/models/option_model.dart';

class DisignBlock extends StatefulWidget {
  final String title;
  final bool isCustom;
  final ValueNotifier<List> leftValue;
  final Function(OptionModel, bool, int) onTap;
  const DisignBlock({
    super.key,
    required this.title,
    required this.isCustom,
    required this.onTap,
    required this.leftValue,
  });

  @override
  State<DisignBlock> createState() => _DisignBlockState();
}

class _DisignBlockState extends State<DisignBlock> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.leftValue,
        builder: (context, value, child) {
          return Column(
            children: [
              Row(
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
                    text: widget.title,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GridView.custom(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 163,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 8,
                  childAspectRatio: (163 / 40),
                ),
                physics: const NeverScrollableScrollPhysics(),
                childrenDelegate: SliverChildBuilderDelegate(
                  childCount: value.length,
                  (context, index) {
                    return InkWell(
                      onTap: () {
                        widget.onTap(
                          OptionModel(
                            type: value[index]["type"],
                            subtitle: value[index]["subtitle"],
                            necessary: false,
                            explain: null,
                            other: null,
                            body: [],
                          ),
                          !value[index]['selected'],
                          index,
                        );
                      },
                      onHover: (v) {
                        widget.leftValue.value[index]['hover'] = v;
                        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                        widget.leftValue.notifyListeners();
                      },
                      child: Container(
                        width: 163,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: value[index]['selected']
                                ? primaryColor
                                : grey300,
                            width: value[index]['selected'] ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: value[index]['hover'] ? grey100 : null,
                        ),
                        child: Center(
                          child: RegularText(
                            color: grey500,
                            size: 14,
                            text: value[index]['subtitle'],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}

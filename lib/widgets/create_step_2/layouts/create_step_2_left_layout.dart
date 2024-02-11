import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_form_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/widgets/create_step_2/components/design_block.dart';
import 'package:upoint_web/widgets/custom_indicator.dart';

class CreateStep2LeftLayout extends StatefulWidget {
  final CreateFormBloc bloc;
  const CreateStep2LeftLayout({
    super.key,
    required this.bloc,
  });

  @override
  State<CreateStep2LeftLayout> createState() => _CreateStep2LeftLayoutState();
}

class _CreateStep2LeftLayoutState extends State<CreateStep2LeftLayout> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    widget.bloc.initLeftOrangeOuter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 381,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: grey300),
      ),
      child: Column(
        children: [
          Container(
            height: 78,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              color: grey100,
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.only(bottom: 10),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: CustomTabIndicator(),
              indicatorPadding: const EdgeInsets.only(bottom: 10),
              tabs: [
                MediumText(
                  color: grey500,
                  size: 16,
                  text: '常用欄位',
                ),
                MediumText(
                  color: grey500,
                  size: 16,
                  text: '自定欄位',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 420,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      // 基本資訊
                      DisignBlock(
                        title: "基本資訊",
                        leftValue: widget.bloc.commonLeftValue,
                        isCustom: false,
                        onTap: (OptionModel option, bool b, int i) {
                          String feildType = "common";
                          if (b) {
                            widget.bloc.addLeftOrangeOuter(feildType, i);
                            widget.bloc.addToForm(feildType, option);
                          } else {
                            widget.bloc.removeLeftOrangeOuter(option.type);
                            widget.bloc.removeFromForm(option.toJson(), true);
                          }
                        },
                      ),
                      // 學校相關
                      DisignBlock(
                        title: "學校相關",
                        isCustom: false,
                        leftValue: widget.bloc.schoolLeftValue,
                        onTap: (OptionModel option, bool b, int i) {
                          String feildType = "school";
                          if (b) {
                            widget.bloc.addLeftOrangeOuter(feildType, i);
                            widget.bloc.addToForm(feildType, option);
                          } else {
                            widget.bloc.removeLeftOrangeOuter(option.type);
                            widget.bloc.removeFromForm(option.toJson(), true);
                          }
                        },
                      ),
                    ],
                  ),
                  // 自定欄位
                  DisignBlock(
                    title: "自定欄位",
                    isCustom: true,
                    leftValue: widget.bloc.customLeftValue,
                    onTap: (OptionModel option, bool b, int i) {
                      if (option.type == "add_title") {
                        widget.bloc.valueNotifier.value.insert(
                          widget.bloc.valueNotifier.value.length,
                          FormModel(
                            title: "請輸入標題",
                            options: [],
                          ),
                        );
                        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                        widget.bloc.valueNotifier.notifyListeners();
                      } else {
                        String feildType = "custom";
                        widget.bloc.addToForm(feildType, option);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 3),
        ],
      ),
    );
  }
}

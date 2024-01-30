// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/global.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/widgets/custom_indicator.dart';
import 'package:upoint_web/widgets/create_step_2/design_block.dart';
import 'package:upoint_web/widgets/progress_step_widget.dart';
import 'package:upoint_web/widgets/create_step_2/container_with_checkbox.dart';

class CreateStep2 extends StatefulWidget {
  final int iniStep;
  const CreateStep2({
    super.key,
    required this.iniStep,
  });

  @override
  State<CreateStep2> createState() => _CreateStep2State();
}

class _CreateStep2State extends State<CreateStep2>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
  }

  addToForm(String feildType, OptionModel option) {
    int _index;
    if (feildType == "common") {
      _index = 0;
      if (option.type == "gender") {
        option.body.addAll(["葷", "素"]);
      } else if (option.type == "meal") {
        option.body.addAll(["男", "女"]);
      }
    } else if (feildType == "school") {
      _index = 1;
    } else {
      //加到最下面
      _index = _valueNotifier.value.length - 1;
    }
    //如果沒學校，先加學校
    if (feildType == "school" && _valueNotifier.value.length == 1) {
      _valueNotifier.value.add(FormModel(title: "學校相關", options: [option]));
    } else {
      _valueNotifier.value[_index].options.add(option);
    }
    // ignore: invalid_use_of_visible_for_testing_member
    _valueNotifier.notifyListeners();
  }

  removeFromForm(Map optionMap, bool isTapDesignBlock) {
    List<FormModel> _value = _valueNotifier.value;
    if (isTapDesignBlock) {
      OptionModel _op = OptionModel.fromMap(optionMap);
      for (var i = 0; i < _value.length; i++) {
        _value[i].options.removeWhere((e) => e.type == _op.type);
      }
    } else {
      _value[optionMap["lindex"]].options.removeAt(optionMap["index"]);
    }
    //檢查如果區塊下沒東西，刪掉標題
    _value.removeWhere((e) => e.title != "基本資料" && e.options.isEmpty);
    _valueNotifier.value = _value;
    // ignore: invalid_use_of_visible_for_testing_member,
    _valueNotifier.notifyListeners();
  }

  addLeftOrangeOuter(String feildType, int index) {
    ValueNotifier<List<dynamic>> _leftValue;
    if (feildType == "common") {
      _leftValue = commonLeftValue;
    } else if (feildType == "school") {
      _leftValue = schoolLeftValue;
    } else {
      _leftValue = customLeftValue;
    }
    _leftValue.value[index]['selected'] = true;
    // ignore: invalid_use_of_visible_for_testing_member
    _leftValue.notifyListeners();
  }

  removeLeftOrangeOuter(String type) {
    int index;
    if (commonFields.any((e) => e["type"] == type)) {
      index = commonFields.indexWhere((e) => e["type"] == type);
      commonLeftValue.value[index]['selected'] = false;
      // ignore: invalid_use_of_visible_for_testing_member
      commonLeftValue.notifyListeners();
    } else if (schoolFields.any((e) => e["type"] == type)) {
      index = schoolFields.indexWhere((e) => e["type"] == type);
      schoolLeftValue.value[index]['selected'] = false;
      // ignore: invalid_use_of_visible_for_testing_member
      schoolLeftValue.notifyListeners();
    }
  }

  ValueNotifier<List> commonLeftValue = ValueNotifier(commonFields);
  ValueNotifier<List> schoolLeftValue = ValueNotifier(schoolFields);
  ValueNotifier<List> customLeftValue = ValueNotifier(customFields);

  final ValueNotifier<List<FormModel>> _valueNotifier =
      ValueNotifier([FormModel(title: "基本資料", options: [])]);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 64),
        child: Container(
          width: 1076,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 48, horizontal: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 進度條
                  ProgressStepWidget(iniStep: widget.iniStep),
                ],
              ),
              const SizedBox(height: 55),
              // 左邊區塊
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                                      leftValue: commonLeftValue,
                                      isCustom: false,
                                      onTap:
                                          (OptionModel option, bool b, int i) {
                                        String feildType = "common";
                                        if (b) {
                                          addLeftOrangeOuter(feildType, i);
                                          addToForm(feildType, option);
                                        } else {
                                          removeLeftOrangeOuter(option.type);
                                          removeFromForm(option.toJson(), true);
                                        }
                                      },
                                    ),
                                    // 學校相關
                                    DisignBlock(
                                      title: "學校相關",
                                      isCustom: false,
                                      leftValue: schoolLeftValue,
                                      onTap:
                                          (OptionModel option, bool b, int i) {
                                        String feildType = "school";
                                        if (b) {
                                          addLeftOrangeOuter(feildType, i);
                                          addToForm(feildType, option);
                                        } else {
                                          removeLeftOrangeOuter(option.type);
                                          removeFromForm(option.toJson(), true);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                // 自定欄位
                                DisignBlock(
                                  title: "自定欄位",
                                  isCustom: true,
                                  leftValue: customLeftValue,
                                  onTap: (OptionModel option, bool b, int i) {
                                    String feildType = "custom";
                                    addToForm(feildType, option);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 右邊區塊
                  Container(
                    width: 543,
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
                            children: [
                              // 基本資訊標題
                              title("基本資訊", ValueKey("")),
                              //固定基本資訊
                              Column(
                                children: List.generate(
                                  fixCommon.length,
                                  (index) {
                                    return ContainerWithCheckbox(
                                      valueNotifier: _valueNotifier,
                                      option: {
                                        "subtitle": fixCommon[index]
                                            ["subtitle"],
                                        "type": fixCommon[index]["type"],
                                      },
                                      fix: true,
                                      tapDelete: null,
                                    );
                                  },
                                ),
                              ),
                              // 變動資訊
                              ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (context, value, child) {
                                  for (var v in value) {
                                    print("title: ${v.title}");
                                    for (var i in v.options) {
                                      print("options: ${i.toJson()}");
                                    }
                                  }
                                  List<Map> _options = [];
                                  List _lengths = [];
                                  int _varI = 0;
                                  for (var i = 0; i < value.length; i++) {
                                    int varInt =
                                        value[i].title == "基本資料" ? 0 : 1;
                                    _options.add({
                                      "subtitle": value[i].title,
                                      "lindex": null,
                                      "index": null,
                                      "i": _varI,
                                    });
                                    _varI++;
                                    for (var l = 0;
                                        l < value[i].options.length;
                                        l++) {
                                      _options.add({
                                        "subtitle":
                                            value[i].options[l].subtitle,
                                        "lindex": i,
                                        "index": l,
                                        "i": _varI,
                                      });
                                      _varI++;
                                    }
                                    _lengths.add(
                                      value[i].options.length +
                                          (_lengths.isEmpty
                                              ? 0
                                              : _lengths.last) +
                                          varInt,
                                    );
                                  }
                                  // print("lengths: $_lengths");
                                  // print("options: $_options");
                                  return ReorderableListView(
                                    shrinkWrap: true,
                                    onReorder: (oldIndex, newIndex) {
                                      if (_lengths.contains(oldIndex)) {
                                        print('是標題不能移動');
                                      } else {
                                        if (newIndex > oldIndex) {
                                          newIndex -=
                                              1; // 这是因为在移动过程中，拖动的项已被从列表中移除
                                        }
                                        print('oldIndex:$oldIndex');
                                        print('newIndex:$newIndex');
                                        var oldMap = _options.firstWhere(
                                            (e) => e["i"] == oldIndex);
                                        var newMap = _options.firstWhere(
                                            (e) => e["i"] == newIndex);
                                        OptionModel theOption = _valueNotifier
                                            .value[oldMap["lindex"]]
                                            .options[oldMap["index"]];
                                        print('oldMap: $oldMap');
                                        print('newMap: $newMap');
                                        print(
                                            'theOption: ${theOption.toJson()}');
                                        _valueNotifier
                                            .value[oldMap["lindex"]].options
                                            .removeAt(oldMap["index"]);
                                        _valueNotifier
                                            .value[newMap["lindex"]].options
                                            .insert(newMap["index"], theOption);
                                        // ignore: invalid_use_of_visible_for_testing_member,
                                        _valueNotifier.notifyListeners();
                                      }
                                    },
                                    children: List.generate(
                                      _options.length,
                                      (index) {
                                        if (index == 0) {
                                          return Container(
                                            key: ValueKey(index.toString()),
                                          );
                                        }
                                        if (_lengths.contains(index - 1)) {
                                          return title(
                                            _options[index]["subtitle"],
                                            ValueKey(index.toString()),
                                          );
                                        } else {
                                          return ContainerWithCheckbox(
                                            key: ValueKey(index.toString()),
                                            valueNotifier: _valueNotifier,
                                            option: _options[index],
                                            fix: false,
                                            tapDelete: (lindex, i) {
                                              String type = _valueNotifier
                                                  .value[lindex]
                                                  .options[i]
                                                  .type;
                                              removeLeftOrangeOuter(type);
                                              removeFromForm(
                                                _options[index],
                                                false,
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget title(String text, ValueKey key) {
    return Column(
      key: key,
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
              text: text,
            ),
          ],
        ),
        SizedBox(height: 6),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upoint_web/bloc/create_form_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/widgets/create_step_2/components/container_with_checkbox.dart';
import 'package:upoint_web/widgets/mouse_grab_widget.dart';

class CreateStep2RightLayout extends StatelessWidget {
  final CreateFormBloc bloc;
  const CreateStep2RightLayout({
    super.key,
    required this.bloc,
  });

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
                title("基本資訊", ValueKey(""), null),
                //固定基本資訊
                Column(
                  children: List.generate(
                    bloc.fixCommon.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: ContainerWithCheckbox(
                          bloc: bloc,
                          option: {
                            "subtitle": bloc.fixCommon[index]["subtitle"],
                            "type": bloc.fixCommon[index]["type"],
                          },
                          fix: true,
                          tapDelete: null,
                        ),
                      );
                    },
                  ),
                ),
                // 變動資訊
                ValueListenableBuilder(
                  valueListenable: bloc.valueNotifier,
                  builder: (context, value, child) {
                    for (var v in value) {
                      debugPrint("title: ${v.title}");
                      for (var i in v.options) {
                        debugPrint("options: ${i.toJson()}");
                      }
                    }
                    List<Map> _options = [];
                    List _lengths = [];
                    int _varI = 0;
                    for (var i = 0; i < value.length; i++) {
                      int varInt = value[i].title == "基本資料" ? 0 : 1;
                      _options.add({
                        "subtitle": value[i].title,
                        "lindex": i == 0 ? 0 : i - 1,
                        "index": i == 0 ? 0 : value[i - 1].options.length,
                        "i": _varI,
                      });
                      _varI++;
                      for (var l = 0; l < value[i].options.length; l++) {
                        _options.add({
                          "subtitle": value[i].options[l].subtitle,
                          "lindex": i,
                          "index": l,
                          "i": _varI,
                        });
                        _varI++;
                      }
                      _lengths.add(
                        value[i].options.length +
                            (_lengths.isEmpty ? 0 : _lengths.last) +
                            varInt,
                      );
                    }
                    // print("lengths: $_lengths");
                    debugPrint("_options: $_options");
                    return ReorderableListView(
                      shrinkWrap: true,
                      // needsLongPressDraggable: true,
                      // ignorePrimaryScrollController:true,
                      // draggedItemBuilder: (context, index) {
                      //   return Container(
                      //     height: 30,
                      //     width: 100,
                      //     color: Colors.amber,
                      //   );
                      // },
                      buildDefaultDragHandles: false,
                      onReorder: (oldIndex, newIndex) {
                        if (_lengths.contains(oldIndex - 1)) {
                          debugPrint('是標題不能移動');
                        } else {
                          // 这是因为在移动过程中，拖动的项已被从列表中移除
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                            // 如果新位置原本是標題，那要找標題的下一個 （標題是0,last的話要找1.0）
                            var _n = _options[newIndex];
                            if (_lengths.contains(_n['i'] - 1)) {
                              newIndex += 1;
                            }
                          }
                          var oldMap = _options[oldIndex];
                          var newMap = _options[newIndex];
                          OptionModel theOption = bloc.valueNotifier
                              .value[oldMap["lindex"]].options[oldMap["index"]];

                          bloc.valueNotifier.value[oldMap["lindex"]].options
                              .removeAt(oldMap["index"]);
                          bloc.valueNotifier.value[newMap["lindex"]].options
                              .insert(newMap["index"], theOption);
                          bloc.checkTitleIsEmpty(bloc.valueNotifier.value);
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
                              (e) => bloc.onTitleChanged(
                                e,
                                bloc.valueNotifier
                                    .value[_options[index]["lindex"] + 1],
                              ),
                            );
                          } else {
                            return ListTile(
                              dense: true,
                              minVerticalPadding: 0,
                              contentPadding: EdgeInsets.only(top: 18),
                              horizontalTitleGap: 0,
                              key: ValueKey(index.toString()),
                              titleAlignment: ListTileTitleAlignment.top,
                              leading: MouseGrabWidget(
                                child: ReorderableDragStartListener(
                                  index: index,
                                  child: SvgPicture.asset(
                                    "assets/drag-vertical.svg",
                                  ),
                                ),
                              ),
                              title: ContainerWithCheckbox(
                                bloc: bloc,
                                option: _options[index],
                                fix: false,
                                tapDelete: (lindex, i) {
                                  String type = bloc.valueNotifier.value[lindex]
                                      .options[i].type;
                                  bloc.removeLeftOrangeOuter(type);
                                  bloc.removeFromForm(
                                    _options[index],
                                    false,
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 37),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget title(
    String text,
    ValueKey key,
    Function(String)? onTitleChanged,
  ) {
    TextEditingController titleController = TextEditingController(text: text);
    bool enabled = text == "基本資訊" || text == "學校相關";
    return Column(
      key: key,
      children: [
        const SizedBox(height: 36),
        Row(
          children: [
            Container(
              width: 8,
              height: 22,
              color: primaryColor,
            ),
            const SizedBox(width: 12),
            IntrinsicWidth(
              child: TextFormField(
                onChanged:
                    onTitleChanged == null ? (e) {} : (e) => onTitleChanged(e),
                keyboardType: TextInputType.text,
                controller: titleController,
                enabled: !enabled,
                autofocus: !enabled,
                style: TextStyle(
                  color: grey500,
                  fontSize: 18,
                  fontFamily: "NotoSansMedium",
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
      ],
    );
  }
}

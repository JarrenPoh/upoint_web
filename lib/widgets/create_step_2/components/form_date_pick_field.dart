import 'package:flutter/material.dart';
import 'package:upoint_web/globals/regular_text.dart';

import '../../../bloc/create_step_2_bloc.dart';
import '../../../color.dart';
import '../../../globals/medium_text.dart';
import '../../create_step_1/date_pick_row.dart';

class FormDatePickField extends StatefulWidget {
  final List<Map> signOptions;
  final CreateStep2Bloc bloc;
  final bool isWeb;
  const FormDatePickField({
    super.key,
    required this.signOptions,
    required this.bloc,
    required this.isWeb,
  });

  @override
  State<FormDatePickField> createState() => _FormDatePickFieldState();
}

class _FormDatePickFieldState extends State<FormDatePickField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 948,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: grey300),
          ),
          child: Column(
            children: [
              Container(
                height: 59,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  color: grey100,
                ),
                child: Center(
                  child: MediumText(
                    color: grey500,
                    size: 18,
                    text: '時程設定',
                  ),
                ),
              ),
              // 報名截止日期
              Container(
                height: 48,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ValueListenableBuilder(
                  valueListenable: widget.bloc.postValue,
                  builder: (context, value, child) {
                    return DatePickRow(
                      post: value,
                      index: widget.signOptions[0]["index"],
                      isWeb: widget.isWeb,
                      dateTimeFunc: (e, ee) => widget.bloc
                          .dateFunc(widget.signOptions[0]["index"], e, ee),
                    );
                  },
                ),
              ),
              // 發送活動提醒
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ValueListenableBuilder(
                    valueListenable: widget.bloc.needReminder,
                    builder: (context, value, child) {
                      bool _isChecked = value;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                side: BorderSide(color: grey400),
                                onChanged: (ee) {
                                  widget.bloc.changeNeedReminder(
                                    ee ?? false,
                                    widget.signOptions[1]["index"],
                                  );
                                },
                              ),
                              MediumText(
                                color: grey500,
                                size: 16,
                                text: "發送行前通知",
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            margin:
                                const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: grey200),
                            ),
                            child: RegularText(
                              color: grey500,
                              size: 15,
                              maxLines: 4,
                              text:
                                  '預設模板：「提醒您報名的活動 {活動標題} 將在 {活動開始時間} 開始，活動地點於 {活動地點} 進行。」',
                            ),
                          ),
                          if (_isChecked)
                            ValueListenableBuilder(
                              valueListenable: widget.bloc.postValue,
                              builder: (context, value, child) {
                                return DatePickRow(
                                  post: value,
                                  index: widget.signOptions[1]["index"],
                                  isWeb: widget.isWeb,
                                  dateTimeFunc: (e, ee) => widget.bloc.dateFunc(
                                      widget.signOptions[1]["index"], e, ee),
                                );
                              },
                            ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/globals/time_transfer.dart';
import 'package:upoint_web/models/post_model.dart';

class DatePickRow extends StatefulWidget {
  final PostModel post;
  final String index;
  final bool isWeb;
  final Function(String?, String?) dateTimeFunc;
  const DatePickRow({
    super.key,
    required this.post,
    required this.index,
    required this.isWeb,
    required this.dateTimeFunc,
  });

  @override
  State<DatePickRow> createState() => _DatePickRowState();
}

class _DatePickRowState extends State<DatePickRow> {
  late double width;
  late double padLeft;
  late double padRight;
  late double height;
  late String hintText;
  late String title;
  @override
  void initState() {
    super.initState();
    refresh();
    // 有編輯過
    initSet();
  }

  initSet() {
    String? _date;
    String? _time;
    List _list = [];
    switch (widget.index) {
      case "startDate":
        if (widget.post.startDateTime != null) {
          _list = (widget.post.startDateTime as String).split('/');
        }
        title = "活動開始日期";
        hintText = "活動開始時間";
        break;
      case "endDate":
        if (widget.post.endDateTime != null) {
          _list = (widget.post.endDateTime as String).split('/');
        }
        title = "活動結束日期";
        hintText = "活動結束時間";

        break;
      case "formDateTime":
        if (widget.post.formDateTime != null) {
          _list = (widget.post.formDateTime as String).split('/');
        }
        title = "報名截止日期";
        hintText = "報名截止時間";
        break;
      case "remindDateTime":
        if (widget.post.remindDateTime != null) {
          _list = (widget.post.remindDateTime as String).split('/');
        }
        title = "發送活動提醒日期";
        hintText = "發送活動提醒時間";
        break;
    }
    if (_list.isNotEmpty) {
      _date = _list[0] == "null" ? null : _list[0];
      _time = _list[1] == "null" ? null : _list[1];
    }
    if (_date != null) {
      dateText = _date;
      selectedDate = DateFormat('yyyy-MM-dd').parse(_date);
    }
    if (_time != null) {
      timeText = _time;
      selectedTime = TimeTransfer.timeTrans02(_time);
    }
  }

  refresh() {
    width = widget.isWeb ? 381 : 180;
    padLeft = widget.isWeb ? 22 : 6;
    padRight = widget.isWeb ? 16 : 0;
    height = 38;
  }

  // 選日期
  DateTime? selectedDate;
  String? dateText;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await Messenger.selectDate(context, selectedDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateText = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
      widget.dateTimeFunc(dateText, timeText);
    }
  }

  //選時間
  TimeOfDay? selectedTime;
  String? timeText;
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await Messenger.selectTime(context, selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        timeText = TimeTransfer.timeTrans01(context, selectedTime!);
      });
      widget.dateTimeFunc(dateText, timeText);
    }
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return Row(
      children: [
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.only(left: padLeft, top: 7),
                height: height,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: grey400,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MediumText(
                        color: dateText == null ? grey400 : grey500,
                        size: 16,
                        text: dateText ?? title,
                      ),
                    ),
                    Icon(
                      Icons.calendar_month,
                      color: grey400,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _selectTime(context),
            child: Row(
              children: [
                const SizedBox(width: 24),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: grey400,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(left: padLeft, right: padRight),
                  width: width,
                  height: height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RegularText(
                          color: timeText == null ? grey400 : grey500,
                          size: 16,
                          text: timeText ?? hintText,
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/edit_clock.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dropDownWidget(
    String hintText,
    Function onPressed,
  ) {
    return Row(
      children: [
        const SizedBox(width: 24),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: grey400,
              ),
            ),
          ),
          padding: EdgeInsets.only(left: padLeft, right: padRight),
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
                color: grey400,
                size: 16,
                text: hintText,
              ),
              IconButton(
                onPressed: onPressed(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: grey400,
                ),
                iconSize: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

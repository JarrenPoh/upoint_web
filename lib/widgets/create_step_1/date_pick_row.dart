import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/globals/time_transfer.dart';

class DatePickRow extends StatefulWidget {
  final String? date;
  final String? time;
  final bool isWeb;
  final String title;
  final Function(String) dateFunc;
  final Function(String) timeFunc;
  const DatePickRow({
    super.key,
    required this.date,
    required this.time,
    required this.isWeb,
    required this.title,
    required this.dateFunc,
    required this.timeFunc,
  });

  @override
  State<DatePickRow> createState() => _DatePickRowState();
}

class _DatePickRowState extends State<DatePickRow> {
  late double width;
  late double padLeft;
  late double padRight;
  late double height;
  @override
  void initState() {
    super.initState();
    refresh();
    // 有編輯過
    if (widget.date != null) {
      dateText = widget.date;
      selectedDate = DateFormat('yyyy-MM-dd').parse(widget.date!);
    }
    if (widget.time != null) {
      timeText = widget.time;
      selectedTime = TimeTransfer.timeTrans02(widget.time!);
    }
  }

  refresh() {
    width = widget.isWeb ? 381 : 180;
    padLeft = widget.isWeb ? 22 : 6;
    padRight = widget.isWeb ? 16 : 0;
    height = 38;
  }

  List hintList = ["時", "分", "PM"];
  DateTime? selectedDate;
  String? dateText;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateText = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
      widget.dateFunc(dateText!);
    }
  }

  TimeOfDay? selectedTime;
  String? timeText;
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        timeText = TimeTransfer.timeTrans01(context, selectedTime!);
      });
      widget.timeFunc(timeText!);
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
                        text: dateText ?? widget.title,
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
                          text: timeText ?? "時間",
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

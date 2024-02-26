import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTransfer {
  //時間模型-> 13:20 PM
  static String timeTrans01(BuildContext context, TimeOfDay selectedTime) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String formattedTime = localizations.formatTimeOfDay(selectedTime,
        alwaysUse24HourFormat: false);
    return formattedTime;
  }

  //1:20 PM-> 時間模型
  static TimeOfDay? timeTrans02(String formattedTime) {
    final RegExp timePattern = RegExp(r'(\d+):(\d+) (\w\w)');
    final match = timePattern.matchAsPrefix(formattedTime);

    if (match != null) {
      final int hour = int.parse(match.group(1)!);
      final int minute = int.parse(match.group(2)!);
      final String period = match.group(3)!;

      int hourIn24 =
          period.toUpperCase() == 'PM' ? (hour % 12) + 12 : hour % 12;

      return TimeOfDay(hour: hourIn24, minute: minute);
    }
    return null;
  }

  //firebase TimeStamp to 113/2/19（周一）
  static String timeTrans03(Timestamp timestamp) {
    // 將Timestamp轉換為DateTime
    DateTime dateTime = timestamp.toDate();
    int rocYear = dateTime.year - 1911;
    String formattedDate = DateFormat('M/d').format(dateTime);
    String weekday = DateFormat('E', 'zh').format(dateTime).replaceAll('週', '');
    return '$rocYear/$formattedDate（$weekday）';
  }

  //firebase TimeStamp to 13:20
  static String timeTrans04(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateFormat outputFormat = DateFormat("HH:mm");
    String convertedTime = outputFormat.format(dateTime);
    return convertedTime;
  }

  //start&end TimeStamp to 113/02/09 13:00~17:00
  static String timeTrans05(Timestamp startTime, Timestamp endTime) {
    String _start = TimeTransfer.timeTrans03(startTime);
    String _end = TimeTransfer.timeTrans03(endTime);
    if (_start == _end) {
      return "$_start${TimeTransfer.timeTrans04(startTime)} ~ ${TimeTransfer.timeTrans04(endTime)}";
    } else {
      return "$_start${TimeTransfer.timeTrans04(startTime)} ~ $_end${TimeTransfer.timeTrans04(endTime)}";
    }
  }

  //firebase timestamp to 113/02/09（周一) 13:20
  static String timeTrans06(Timestamp time){
    return "${TimeTransfer.timeTrans03(time)}${TimeTransfer.timeTrans04(time)}";
  }

  //DateTime -> 91-09-15
  static String convertToROC(DateTime date) {
    // 计算民国年份
    int rocYear = date.year - 1911;
    // 格式化为 "民國年-MM-dd"
    return '民國${rocYear}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

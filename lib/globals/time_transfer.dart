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

      // 转换小时数到24小时制
      int hourIn24 =
          period.toUpperCase() == 'PM' ? (hour % 12) + 12 : hour % 12;

      return TimeOfDay(hour: hourIn24, minute: minute);
    }
    return null; // 如果无法解析，返回 null
  }

  //firebase TimeStamp to 113/2/19（周一）
  static String formatTimestampToROC(Timestamp timestamp) {
    // 將Timestamp轉換為DateTime
    DateTime dateTime = timestamp.toDate();

    // 民國年份是西元年份減去1911
    int rocYear = dateTime.year - 1911;

    // 使用intl包格式化月份和日期
    String formattedDate = DateFormat('M/d').format(dateTime);

    // 獲取星期，並將"星期"轉換為單一字（如星期一轉為"一"）
    String weekday = DateFormat('E', 'zh').format(dateTime).replaceAll('週', '');

    // 組合成最終格式
    return '$rocYear/$formattedDate（$weekday）';
  }

  //1:20PM -> 13:20
  static String timeTrans03(String timeString) {
    DateFormat inputFormat = DateFormat("h:mm a");
    DateFormat outputFormat = DateFormat("HH:mm");

    DateTime time = inputFormat.parse(timeString);
    String convertedTime = outputFormat.format(time);
    return convertedTime;
  }
}

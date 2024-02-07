import 'package:flutter/material.dart';

class TimeTransfer {
  //時間模型-> 13:20 PM
  static String timeTrans01(BuildContext context, TimeOfDay selectedTime) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String formattedTime = localizations.formatTimeOfDay(selectedTime,
        alwaysUse24HourFormat: false);
    return formattedTime;
  }

  //13:20 PM-> 時間模型
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
}

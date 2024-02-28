import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';

class Messenger {
  // 下方彈出的toast
  static snackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MediumText(
          color: Colors.white,
          size: 16,
          text: text,
        ),
        backgroundColor: grey400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 200, vertical: 30),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  //彈窗Dialog
  static Future<String> dialog(
      String title, String content, BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: MediumText(
            color: grey400,
            size: 16,
            text: title,
          ),
          content: MediumText(
            color: grey500,
            size: 20,
            text: content,
          ),
          actions: <Widget>[
            TextButton(
              child: MediumText(
                color: grey300,
                size: 16,
                text: "取消",
              ),
              onPressed: () => Navigator.of(context)
                  .pop('cancel'), // Return 'cancel' when cancelled
            ),
            TextButton(
              child: MediumText(
                color: grey500,
                size: 16,
                text: "確定",
              ),
              onPressed: () => Navigator.of(context)
                  .pop('success'), // Return 'success' when confirmed
            ),
          ],
        );
      },
    );

    // Return 'result' which will be 'success' or 'cancel'
    return result ??
        'dismissed'; // Return 'dismissed' if the dialog is dismissed without selection
  }

  //彈窗Dialog
  static Future<Map> addTagsDialog(String title, BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final Map? result = await showDialog<Map>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: MediumText(
            color: grey500,
            size: 16,
            text: title,
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: grey500),
            cursorColor: primaryColor,
            decoration: InputDecoration(
              hintText: "輸入您的標籤",
              hintStyle: TextStyle(color: grey400),
              contentPadding: const EdgeInsets.only(
                left: 0,
              ),
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: MediumText(
                color: grey300,
                size: 16,
                text: "取消",
              ),
              onPressed: () => Navigator.of(context)
                  .pop({"status": 'cancel'}), // Return 'cancel' when cancelled
            ),
            TextButton(
              child: MediumText(
                color: grey500,
                size: 16,
                text: "確定",
              ),
              onPressed: () => Navigator.of(context).pop({
                "status": 'success',
                "value": controller.text.trim()
              }), // Return 'success' when confirmed
            ),
          ],
        );
      },
    );
    return result ??
        {
          "status": 'cancel'
        }; 
  }

  //選日期
  static Future<DateTime?> selectDate(
    BuildContext context,
    DateTime? selectedDate,
  ) async {
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
    return picked;
  }

  //選時間
  static Future<TimeOfDay?> selectTime(
    BuildContext context,
    TimeOfDay? selectedTime,
  ) async {
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
    return picked;
  }
}

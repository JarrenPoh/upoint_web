import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/pages/login_page.dart';
import 'package:upoint_web/widgets/dialogs/add_links_dialog.dart';
import 'package:upoint_web/widgets/dialogs/create_post_dialog.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

import '../pages/register_page.dart';

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
        duration: const Duration(seconds: 3),
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
          surfaceTintColor: Colors.white,
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

  // 創建貼文確認Dialog
  static Future<Map> showCreatePostDialog(
    BuildContext context,
  ) async {
    Map res = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: CreatePostDialog(),
        );
      },
    );
    return res;
  }

  //彈窗Dialog
  static Future<Map> addLinksDialog({
    required BuildContext context,
    required String text,
    required String url,
  }) async {
    Map res = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: AddLinkDialog(text: text, url: url),
        );
      },
    );
    return res;
  }

  //彈窗Dialog
  static Future<Map> addTagsDialog(String title, BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final Map? result = await showDialog<Map>(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
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
              onPressed: () => Navigator.of(context).pop({"status": 'cancel'}),
            ),
            TextButton(
              child: MediumText(
                color: grey500,
                size: 16,
                text: "確定",
              ),
              onPressed: () => Navigator.of(context)
                  .pop({"status": 'success', "value": controller.text.trim()}),
            ),
          ],
        );
      },
    );
    return result ?? {"status": 'cancel'};
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

  // 登入Dialog
  static Future<String> loginDialog(BuildContext context) async {
    final _pageController = PageController(initialPage: 0);
    void _navigateToPage(int page) {
      _pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          surfaceTintColor: Colors.white,
          content: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // User? user = snapshot.data;
                return SizedBox(
                  width: 240,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 170,
                          height: 88,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/logo_group.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        MediumText(
                          color: grey500,
                          size: 18,
                          text: "登入成功!",
                        ),
                        const SizedBox(height: 20),
                        TapHoverContainer(
                          text: "確認",
                          padding: 10,
                          hoverColor: secondColor,
                          borderColor: Colors.transparent,
                          textColor: Colors.white,
                          color: primaryColor,
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox(
                  height: 781,
                  width: 543,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      LoginPage(
                        isWeb: false,
                        navigateToPage: _navigateToPage,
                      ),
                      RegisterPage(
                        navigateToPage: _navigateToPage,
                        isWeb: false,
                        role: "user",
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );

    // Return 'result' which will be 'success' or 'cancel'
    return result ??
        'dismissed'; // Return 'dismissed' if the dialog is dismissed without selection
  }
}

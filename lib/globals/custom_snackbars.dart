import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';

class Messenger {
  static snackBar(BuildContext context,String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:  MediumText(
          color: Colors.white,
          size: 16,
          text: text,
        ),
        backgroundColor: grey400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 200,vertical: 30),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

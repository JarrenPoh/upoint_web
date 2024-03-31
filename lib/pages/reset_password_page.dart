import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';
import '../firebase/auth_methods.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  String errorEmail = "";
  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      if (errorEmail.isNotEmpty) {
        setState(() {
          _emailController.text.trim() == '' ? null : errorEmail = "";
        });
      }
    });
  }

  bool isEmail(String input) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(input);
  }

  Future resetPassword() async {
    FocusScope.of(context).unfocus();
    if (_emailController.text.trim() == '') {
      setState(() {
        errorEmail = "電子郵件不可為空";
      });
    } else if (!isEmail(_emailController.text.trim())) {
      setState(() {
        errorEmail = "請輸入有效的電子郵件格式";
      });
    } else {
      setState(() {
        isLoading = true;
      });
      await AuthMethods().resetPassword(
        _emailController.text.trim(),
        context,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textWidget(
                      false,
                      "輸入你的電子信箱，我們將寄信給您",
                      errorEmail,
                      _emailController,
                    ),
                    const SizedBox(height: 24),
                    //bottom
                    SizedBox(
                      width: 160,
                      child: TapHoverContainer(
                        text: "重置密碼發送",
                        padding: 20,
                        hoverColor: secondColor,
                        borderColor: primaryColor,
                        textColor: Colors.white,
                        color: primaryColor,
                        onTap: resetPassword,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget textWidget(
    obscureText,
    hintText,
    String errorText,
    controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: grey500),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // 圓角設定
        ),
        errorText: errorText.isNotEmpty ? errorText : null,
        hintText: hintText,
        hintStyle: TextStyle(color: grey300),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        errorBorder:  OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

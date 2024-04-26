// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import '../../globals/custom_messengers.dart';
import '../firebase/auth_methods.dart';
import '../globals/medium_text.dart';
import '../globals/regular_text.dart';
import '../widgets/tap_hover_container.dart';
import '../widgets/tap_hover_text.dart';

class RegisterPage extends StatefulWidget {
  final Function(int) navigateToPage;
  final bool isWeb;
  final String role;
  const RegisterPage({
    super.key,
    required this.navigateToPage,
    required this.isWeb,
    required this.role,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      if (list[0]["errorText"].isNotEmpty) {
        setState(() {
          list[0]["controller"].text.trim() == ''
              ? null
              : list[0]["errorText"] = "";
        });
      }
    });
    _passwordController.addListener(() {
      if (list[1]["errorText"].isNotEmpty) {
        setState(() {
          list[1]["controller"].text.trim() == ''
              ? null
              : list[1]["errorText"] = '';
        });
      }
    });
    _confirmController.addListener(() {
      if (list[2]["errorText"].isNotEmpty) {
        setState(() {
          list[2]["controller"].text.trim() == ''
              ? null
              : list[2]["errorText"] = '';
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

  void signUpUser() async {
    if (_emailController.text.trim() == '') {
      setState(() {
        list[0]["errorText"] = "電子郵件不可為空";
      });
    } else if (!isEmail(_emailController.text.trim())) {
      setState(() {
        list[0]["errorText"] = "請輸入有效的電子郵件格式";
      });
    } else if (_passwordController.text.trim() == '') {
      setState(() {
        list[1]["errorText"] = "密碼不可為空";
      });
    } else if (_confirmController.text.trim() == '') {
      setState(() {
        list[2]["errorText"] = "確認密碼不可為空";
      });
    } else if (_passwordController.text.trim() !=
        _confirmController.text.trim()) {
      setState(() {
        list[2]["errorText"] = "密碼填寫不同，請確認清楚你的密碼";
      });
    } else {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
        String res = await AuthMethods().signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          // // navigate to the home screen
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return VerifyEmailPage(
          //         email: _emailController.text,
          //         role: widget.role,
          //       );
          //     },
          //   ),
          // );
        } else {
          setState(() {
            isLoading = false;
          });
          // show the error
          Messenger.snackBar(context, "失敗：$res ，請洽詢官方發現問題");
          await Messenger.dialog(
            res,
            '如有問題，請洽詢官方:service.upoint@gmail.com',
            context,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: widget.isWeb ? 1076 : 543,
          height: 781,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 96),
                SizedBox(
                  width: 274,
                  child: Column(
                    children: [
                      //logo
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
                      for (Map i in list)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: i["errorText"].isNotEmpty
                                      ? Colors.red
                                      : grey400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: textWidget(
                                      i["obscureText"],
                                      i["icon"],
                                      i["title"],
                                      i["controller"],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (i["errorText"].isNotEmpty)
                              RegularText(
                                color: Colors.red,
                                size: 12,
                                text: i["errorText"],
                              )
                          ],
                        ),
                      const SizedBox(height: 15),
                      //  login
                      const SizedBox(height: 20),
                      TapHoverContainer(
                        text: "創建帳號",
                        padding: 20,
                        hoverColor: secondColor,
                        borderColor: Colors.transparent,
                        textColor: Colors.white,
                        color: primaryColor,
                        onTap: () => signUpUser(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MediumText(
                      color: grey400,
                      size: 12,
                      text: "  已經有帳號了？",
                    ),
                    TapHoverText(
                      text: "回登入頁面！",
                      textSize: 14,
                      hoverColor: secondColor,
                      color: primaryColor,
                      onTap: () => widget.navigateToPage(0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          CircularProgressIndicator(backgroundColor: grey300, color: grey400)
      ],
    );
  }

  late List<Map> list = [
    {
      "title": "電子郵件",
      "index": "email",
      "obscureText": false,
      "icon": Icons.email,
      "errorText": "",
      "controller": _emailController,
    },
    {
      "title": "密碼",
      "index": "password",
      "obscureText": true,
      "icon": Icons.lock,
      "errorText": "",
      "controller": _passwordController,
    },
    {
      "title": "確認密碼",
      "index": "confirm",
      "obscureText": true,
      "icon": Icons.lock,
      "errorText": "",
      "controller": _confirmController,
    },
  ];

  Widget textWidget(
    bool obscureText,
    IconData prefixIcon,
    String hintText,
    controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: grey500),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        // prefixIcon: Icon(prefixIcon, color: primary),
        hintText: hintText,
        hintStyle: TextStyle(color: grey400),
        contentPadding: const EdgeInsets.only(
          left: 0,
        ),
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}

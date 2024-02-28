import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/firebase/auth_methods.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';
import 'package:upoint_web/widgets/tap_hover_text.dart';
import '../globals/custom_messengers.dart';

class LoginPage extends StatefulWidget {
  final String role;
  final bool isWeb;
  const LoginPage({
    super.key,
    required this.role,
    required this.isWeb,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String errorEmail = "";
  String errorPassword = "";
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
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  late List<Map> list = [
    {
      "title": "電子郵件",
      "index": "email",
      "obscureText": false,
      "icon": Icons.people_alt_rounded,
      "errorText": errorEmail,
      "controller": _emailController,
    },
    {
      "title": "密碼",
      "index": "password",
      "obscureText": true,
      "icon": Icons.lock,
      "errorText": errorPassword,
      "controller": _passwordController,
    },
  ];

  bool isEmail(String input) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(input);
  }

  void loginUser() async {
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
    } else {
      if (!isLoading) {
        FocusScope.of(context).unfocus();
        // setState(() {
        //   isLoading = true;
        // });
        String res = await AuthMethods().loginUser(
          email: _emailController.text,
          password: _passwordController.text,
        );

        signIn(res);
      }
    }
  }

  void signIn(res) async {
    if (res == "success") {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        // await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
        // ignore: use_build_context_synchronously
        // Navigator.pop(context, true);
      } else {
        Messenger.dialog(
          '如有問題，請洽詢官方:service.upoint@gmail.com',
          '你尚未驗證你的Gmail',
          context,
        );
        await AuthMethods().signOut();
        // ignore: use_build_context_synchronously
      }
    } else {
      setState(() {
        isLoading = false;
      });
      await AuthMethods().signOut();
      // ignore: use_build_context_synchronously
      Messenger.snackBar(context, '$res ，請洽詢官方發現問題');
      // ignore: use_build_context_synchronously
      await Messenger.dialog(
        '發生錯誤',
        '$res，請洽詢官方:service.upoint@gmail.com',
        context,
      );
    }
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
              children: [
                const SizedBox(height: 96),
                SizedBox(
                  width: 274,
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
                      // accout & password
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
                                  SizedBox(width: 20),
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
                                  text: i["errorText"])
                          ],
                        ),
                      //  login
                      const SizedBox(height: 20),
                      TapHoverContainer(
                        text: "登入",
                        padding: 20,
                        hoverColor: secondColor,
                        borderColor: Colors.transparent,
                        textColor: Colors.white,
                        color: primaryColor,
                        onTap: () => loginUser(),
                      ),
                      //forget password
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // MediumText(
                          //   color: grey400,
                          //   size: 12,
                          //   text: "還沒有帳號嗎？",
                          // ),
                          // TopHoverText(
                          //   text: "點此註冊",
                          //   textSize: 14,
                          //   hoverColor: secondColor,
                          //   color: primaryColor,
                          //   onTap: () {},
                          // ),
                          Expanded(child: Column(children: [])),
                          TapHoverText(
                            text: "忘記密碼",
                            textSize: 12,
                            hoverColor: grey300,
                            color: grey400,
                            onTap: () {},
                          ),
                        ],
                      ),
                      // others
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Divider(color: grey400)),
                          const SizedBox(width: 8),
                          MediumText(
                            color: grey400,
                            size: 16,
                            text: "或 使用以下登入方式",
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Divider(color: grey400)),
                        ],
                      ),
                      // google login
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await AuthMethods().signInWithGoogle(widget.role);
                            },
                            child: Container(
                              height: 64,
                              width: 64,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey[100],
                              ),
                              child: Image.asset(
                                "assets/google.png",
                                height: 32,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
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

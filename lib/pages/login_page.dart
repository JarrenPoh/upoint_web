import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/firebase/auth_methods.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';
import 'package:upoint_web/widgets/tap_hover_text.dart';

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
  List list = ["電子郵件", "密碼"];
  @override
  Widget build(BuildContext context) {
    return Container(
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
                        image: NetworkImage("assets/logo_group.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // accout & password
                  for (var i in list)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: grey400,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              RegularText(
                                color: grey400,
                                size: 14,
                                text: i,
                              ),
                            ],
                          ),
                        ),
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
                    onTap: () {},
                  ),
                  //forget password
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      MediumText(
                        color: grey400,
                        size: 12,
                        text: "還沒有帳號嗎？",
                      ),
                      TopHoverText(
                        text: "點此註冊",
                        textSize: 14,
                        hoverColor: secondColor,
                        color: primaryColor,
                        onTap: () {},
                      ),
                      Expanded(child: Column(children: [])),
                      TopHoverText(
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
    );
  }
}

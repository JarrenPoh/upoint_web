import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/global.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:url_launcher/url_launcher.dart';

class SignFormPage extends StatefulWidget {
  final bool isWeb;
  final Widget child;
  const SignFormPage({
    super.key,
    required this.isWeb,
    required this.child,
  });

  @override
  State<SignFormPage> createState() => _SignFormPageState();
}

class _SignFormPageState extends State<SignFormPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Container(
                width: widget.isWeb ? 1076 : 543,
                padding:
                    const EdgeInsets.symmetric(vertical: 48, horizontal: 64),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.child,
              ),
            ),
            // 點擊連結下載
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: grey500,
                  fontSize: 18,
                  fontFamily: "NotoSansRegular",
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: "掃描或",
                  ),
                  const TextSpan(
                    text: "Upoint App 獲取更多活動資訊！",
                  ),
                  TextSpan(
                    text: "iOS點此下載  ",
                    style: TextStyle(
                      color: primaryColor,
                      fontFamily: "NotoSansMedium",
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // 在这里添加你的外部链接跳转逻辑
                        // 使用url_launcher包来打开外部链接
                        launchUrl(Uri.parse(appleStoreLink));
                      },
                  ),
                  const TextSpan(
                    text: "、",
                  ),
                  TextSpan(
                    text: "Android點此下載 ",
                    style: TextStyle(
                      color: primaryColor,
                      fontFamily: "NotoSansMedium",
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // 在这里添加你的外部链接跳转逻辑
                        // 使用url_launcher包来打开外部链接
                        launchUrl(Uri.parse(googlePlayLink));
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // qrcode
            Row(
              children: [
                _qrCode(appleStoreQrcode, "iOS版"),
                SizedBox(
                  height: 40,
                  child: VerticalDivider(
                    color: grey500,
                    width: 72,
                    thickness: 1,
                  ),
                ),
                _qrCode(googlePlayQrcode, "Android版"),
              ],
            ),
            const SizedBox(height: 43)
          ],
        ),
      ],
    );
  }

  Widget _qrCode(String url, String text) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(url),
            ),
          ),
        ),
        const SizedBox(height: 8),
        RegularText(color: grey500, size: 14, text: "UPoint APP"),
        const SizedBox(height: 8),
        RegularText(color: grey500, size: 14, text: text),
      ],
    );
  }
}

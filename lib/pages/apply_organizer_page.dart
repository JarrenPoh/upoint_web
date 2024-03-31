// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/firebase/auth_methods.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';
import '../bloc/apply_organizer_bloc.dart';

class ApplyOrganizerPage extends StatefulWidget {
  final bool isWeb;
  final Widget child;
  final ApplyOrganizerBloc bloc;
  const ApplyOrganizerPage({
    super.key,
    required this.isWeb,
    required this.child,
    required this.bloc,
  });

  @override
  State<ApplyOrganizerPage> createState() => _ApplyOrganizerPageState();
}

class _ApplyOrganizerPageState extends State<ApplyOrganizerPage> {
  bool _isSend = false;
  bool? _isSuccess;
  String? _res;
  onTap() async {
    // 上傳organizer firestore
    bool correctEdit = widget.bloc.isEditComplete(context);
    if (correctEdit) {
      setState(() {
        _isSend = true;
      });
      String res = await widget.bloc.sendAppply();
      if (res == "success") {
        setState(() {
          _isSuccess = true;
        });
        await Future.delayed(const Duration(seconds: 3));
        await AuthMethods().signOut();
      } else {
        setState(() {
          _isSuccess = false;
          _res = res;
        });
        Messenger.dialog("發生錯誤，請將錯誤截圖後訊息聯絡官方", "錯誤訊息：$res", context);
        Messenger.snackBar(context, "錯誤訊息：$res");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Container(
                width: widget.isWeb ? 1076 : 543,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      height: 152,
                      width: 152,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            _isSuccess == true
                                ? "assets/create_success.png"
                                : "assets/create_failed.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    MediumText(
                      color: grey500,
                      size: 20,
                      text: _isSuccess == true
                          ? "申請帳號成功，請重新登入，系統將在三秒後將自動登出"
                          : "創建失敗，請聯絡service.upoint@gmail.com：$_res",
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Container(
              width: widget.isWeb ? 1076 : 543,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 38),
                      Container(
                        width: 170,
                        height: 45,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: MediumText(
                            color: Colors.white,
                            size: 18,
                            text: "主辦單位資訊",
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 145),
                            child: widget.child,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TapHoverContainer(
                            text: "提交申請",
                            padding: widget.isWeb ? 84 : 22,
                            hoverColor: secondColor,
                            borderColor: Colors.transparent,
                            textColor: Colors.white,
                            color: primaryColor,
                            onTap: onTap,
                          ),
                        ],
                      ),
                      const SizedBox(height: 45),
                    ],
                  ),
                  // 轉圈圈
                  if (_isSend == true)
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: grey300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../globals/custom_messengers.dart';
import '../color.dart';
import '../firebase/auth_methods.dart';
import '../firebase/firestore_methods.dart';
import '../globals/medium_text.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  final String role;
  const VerifyEmailPage({
    super.key,
    required this.email,
    required this.role,
  });

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  Timer? resentTimer;
  int resentTime = 60;
  bool isLoading = false;
  bool canResentEmail = false;

  @override
  void initState() {
    super.initState();
    getUserEmailVerify();
  }

  getUserEmailVerify() {
    isEmailVerified = auth.FirebaseAuth.instance.currentUser!.emailVerified;
    debugPrint('信箱驗證 $isEmailVerified');
    Send();
  }

  Future Send() async {
    resentTime = 60;
    setState(() {
      isLoading = true;
      canResentEmail = false;
    });

    if (!isEmailVerified) {
      String res = await AuthMethods().sendVerificationEmail();

      if (res == 'success') {
        Messenger.snackBar(
          context,
          "成功，$res驗證信箱已送出，請查閱'",
        );
        timer = Timer.periodic(
            const Duration(seconds: 3), (_) => checkEmailVerified());

        resentTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            resentTime--;
            debugPrint('resenttTime$resentTime');
            if (resentTime == 0) {
              canResentEmail = true;
              resentTimer!.cancel();
            }
          });
        });
      } else {
        Messenger.snackBar(context, "失敗，'$res ，請洽詢官方發現問題'");
        Messenger.dialog("發生錯誤", "失敗，'$res ，請洽詢官方發現問題'", context);
        print("失敗訊息：$res");
      }
    } else {
      bool exist = false;

      await FirebaseFirestore.instance
          .collection('${widget.role}s')
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((doc) => exist = doc.exists);
      if (!exist) {
        checkEmailVerified();
      } else {
        // 註冊過了
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  //
  checkEmailVerified() async {
    await auth.FirebaseAuth.instance.currentUser!.reload();
    isEmailVerified = auth.FirebaseAuth.instance.currentUser!.emailVerified;
    debugPrint('after reload emailVerified $isEmailVerified');
    if (isEmailVerified) {
      resentTimer?.cancel();
      timer?.cancel();
      //上傳用戶註冊資料
      String res = await FirestoreMethods().signUpToStore(
        widget.email,
        auth.FirebaseAuth.instance.currentUser!,
      );
      if (res == 'success') {
        Messenger.snackBar(context, "成功，歡迎加入，趕快發一則貼文吧!");
        await AuthMethods().signOut();
      } else {
        Messenger.snackBar(context, "失敗，$res ，請洽詢官方發現問題");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    resentTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('信箱驗證發送至你的信箱，請查閱'),
              const SizedBox(
                height: 24,
              ),
              CupertinoButton(
                onPressed: canResentEmail ? Send : () {},
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: canResentEmail ? primaryColor : Colors.grey,
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : MediumText(
                          color: Colors.white,
                          size: 16,
                          text: canResentEmail ? '重新發送' : resentTime.toString(),
                        ),
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          CircularProgressIndicator(backgroundColor: grey300, color: grey400)
      ],
    );
  }
}

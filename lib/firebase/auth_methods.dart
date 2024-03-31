// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:upoint_web/firebase/firestore_methods.dart';
import 'package:upoint_web/secret.dart';

import '../globals/custom_messengers.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //註冊用戶
  Future<String> signUpUser({
    required String email,
    required String password,
    Uint8List? file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //register user
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // await FirestoreMethods().signUpToStore(
        //   email,
        //   FirebaseAuth.instance.currentUser!,
        // );
        res = "success";
        debugPrint(res);
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'the email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      } else if (err.code == 'email-already-in-use') {
        res = 'the email you entered has been use';
      } else {
        res = err.toString();
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // 郵箱登入
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = "success";
    } on FirebaseAuthException catch (err) {
      debugPrint('errorr');
      if (err.code == 'unknown') {
        res = 'Please enter all the fields';
      } else if (err.code == 'wrong-password') {
        res = '密碼輸入錯誤';
      } else if (err.code == 'network-request-failed') {
        res = '網路出現問題';
      } else if (err.code == 'user-not-found') {
        res = '此郵箱尚未註冊';
      } else {
        res = err.code.toString();
      }
    } on PlatformException catch (err) {
      debugPrint('errorr');
      res = err.toString();
      debugPrint(res);
    } catch (e) {
      debugPrint('errorr');
      res = e.toString();
      debugPrint(res);
    }
    return res;
  }

  // Google登入
  Future<String> signInWithGoogle() async {
    String res = "some error occur";
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId: googleClientId,
      ).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      //上傳用戶註冊資料
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!userDoc.exists) {
        await FirestoreMethods().signUpToStore(
          userCredential.user!.email!,
          FirebaseAuth.instance.currentUser!,
        );
      }
      res = "success";
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      res = e.toString();
    }
    return res;
  }

  Future<DocumentSnapshot?> getUserData() async {
    int retries = 0;
    while (retries < 2) {
      try {
        debugPrint("索取使用者的firestore");
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (userDoc.exists) {
          return userDoc; // 如果找到資料，則將其發送給 StreamBuilder
        } else {
          // 如果未找到資料，等待兩秒後重試
          await Future.delayed(Duration(seconds: 2));
          retries++;
        }
      } catch (e) {
        debugPrint(e.toString());
        await Future.delayed(Duration(seconds: 2));
        retries++;
      }
    }
    return null;
    // 如果重試三次後仍未找到資料，發送一個包含錯誤的 DocumentSnapshot
  }

  //使用者登出
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //信箱驗證
  Future<String> sendVerificationEmail() async {
    String res = 'some error occur';
    try {
      final user = _auth.currentUser!;
      await user.sendEmailVerification();
      res = 'success';
    } on FirebaseAuthException catch (err) {
      debugPrint(err.toString());
      res = 'error occur in FirebaseAuth';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //重至密碼
  Future<String> resetPassword(String email,BuildContext context) async {
    String res = 'some error occur';
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Messenger.snackBar(
        context,
        '已成功發送電子郵件至$email，請查閱',
      );
      Navigator.pop(context);
      res = 'success';
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = '該信箱尚未註冊';
      } else {
        res = 'error occur in FirebaseAuth';
        debugPrint(err.toString());
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}

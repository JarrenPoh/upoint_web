import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:upoint_web/firebase/firestore_methods.dart';
import 'package:upoint_web/secret.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //使用者登入
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

  Future<String> signInWithGoogle(String role) async {
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
      if (role != "organizer") {
        //上傳用戶註冊資料
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('${role}s')
            .doc(userCredential.user!.uid)
            .get();
        if (!userDoc.exists) {
          await FirestoreMethods().signUpToStore(
            role,
            userCredential.user!.email!,
            FirebaseAuth.instance.currentUser!,
          );
        }
      }
      res = "success";
    } on PlatformException catch (e) {
      print(e);
      res = e.toString();
    }
    return res;
  }

  Future<DocumentSnapshot?> getUserData() async {
    int retries = 0;
    while (retries < 3) {
      try {
        print("索取使用者的firestore");
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
        print(e);
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:upoint_web/firebase/firestore_methods.dart';
import 'package:upoint_web/secret.dart';

class AuthMethods {
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
}

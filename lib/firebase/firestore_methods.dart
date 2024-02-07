import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/organizer_model.dart';
import '../models/user_model.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //註冊用戶
  Future<String> signUpToStore(
    String role,
    String email,
    User currentUser,
  ) async {
    String res = 'some error occur';
    try {
      switch (role) {
        case "organizer":
          OrganizerModel user = OrganizerModel(
            email: email,
            uid: currentUser.uid,
          );
          //上傳firestore
          await _firestore
              .collection('organizers')
              .doc(currentUser.uid)
              .set(user.toJson());
          break;
        case "user":
          UserModel user = UserModel(
            email: email,
            uuid: currentUser.uid,
          );
          //上傳firestore
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .set(user.toJson());
          break;
      }

      res = 'success';
    } catch (e) {
      res = e.toString();
      print(res);
    }
    return res;
  }

  //尋找
}

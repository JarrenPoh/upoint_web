import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizerModel {
  String? userName;
  String uid;
  String? pic;
  String? phoneNumber;
  String email;

  OrganizerModel({
    this.userName,
    required this.uid,
    this.pic,
    required this.email,
    this.phoneNumber,
  });

  static Map toMap(OrganizerModel cart) {
    return {
      "userName": cart.userName,
      "uid": cart.uid,
      "pic": cart.pic,
      "email": cart.email,
      "phoneNumber": cart.phoneNumber,
    };
  }

  static OrganizerModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return OrganizerModel(
      userName: snapshot['userName'],
      uid: snapshot['uid'],
      pic: snapshot['pic'],
      email: snapshot['email'],
      phoneNumber: snapshot['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "uid": uid,
        "pic": pic,
        "email": email,
        "phoneNumber": phoneNumber,
      };

  static OrganizerModel? fromMap(Map? map) {
    if (map == null) {
      return null;
    } else {
      return OrganizerModel(
        userName: map['userName'],
        uid: map['uid'],
        pic: map['pic'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
      );
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizerModel {
  String? organizerName;
  String uid;
  String? pic;
  String? phoneNumber;
  String email;

  OrganizerModel({
    this.organizerName,
    required this.uid,
    this.pic,
    required this.email,
    this.phoneNumber,
  });

  static Map toMap(OrganizerModel cart) {
    return {
      "organizerName": cart.organizerName,
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
      organizerName: snapshot['organizerName'],
      uid: snapshot['uid'],
      pic: snapshot['pic'],
      email: snapshot['email'],
      phoneNumber: snapshot['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        "organizerName": organizerName,
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
        organizerName: map['organizerName'],
        uid: map['uid'],
        pic: map['pic'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
      );
    }
  }
}

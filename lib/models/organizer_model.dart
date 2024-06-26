import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizerModel {
  String? username;
  String uid;
  String? pic;
  String? phoneNumber;
  String? bio;
  String? unit;
  String? contact;
  String email;
  int postLength;
  List<String>? myTags;
  String? referralCode;

  OrganizerModel({
    this.username,
    required this.uid,
    this.pic,
    required this.email,
    this.phoneNumber,
    this.bio,
    this.unit,
    this.contact,
    this.myTags,
    required this.postLength,
     this.referralCode,
  });

  static Map toMap(OrganizerModel cart) {
    return {
      "username": cart.username,
      "uid": cart.uid,
      "pic": cart.pic,
      "email": cart.email,
      "phoneNumber": cart.phoneNumber,
      "bio": cart.bio,
      "unit": cart.unit,
      "contact": cart.contact,
      "myTags": cart.myTags,
      "referralCode":cart.referralCode,
    };
  }

  static OrganizerModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return OrganizerModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      pic: snapshot['pic'],
      email: snapshot['email'],
      phoneNumber: snapshot['phoneNumber'],
      bio: snapshot['bio'],
      unit: snapshot['unit'],
      contact: snapshot['contact'],
      postLength: snapshot['postLength'],
      myTags: snapshot["myTags"],
      referralCode:snapshot["referralCode"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "pic": pic,
        "email": email,
        "phoneNumber": phoneNumber,
        "bio": bio,
        "unit": unit,
        "contact": contact,
        "postLength": postLength,
        "myTags": myTags,
        "referralCode":referralCode,
      };

  static OrganizerModel? fromMap(Map? map) {
    if (map == null) {
      return null;
    } else {
      return OrganizerModel(
        username: map['username'],
        uid: map['uid'],
        pic: map['pic'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
        bio: map['bio'],
        unit: map['unit'],
        contact: map['contact'],
        postLength: map['postLength'],
        myTags: map['myTags'] != null ? List<String>.from(map['myTags']) : null,
        referralCode:map["referralCode"],
      );
    }
  }
}

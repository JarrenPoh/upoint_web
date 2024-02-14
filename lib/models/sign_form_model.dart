import 'package:cloud_firestore/cloud_firestore.dart';

class SignFormModel {
  String uuid;
  String? fcmToken;
  var datePublished;
  String signFormId;
  String body;
  SignFormModel({
    required this.uuid,
    required this.fcmToken,
    required this.body,
    required this.datePublished,
    required this.signFormId,
  });

  static Map toMap(SignFormModel cart) {
    return {
      "uuid": cart.uuid,
      "fcmToken": cart.fcmToken,
      "body": cart.body,
      "datePublished":cart.datePublished,
      "signFormId":cart.signFormId,
    };
  }

  static SignFormModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return SignFormModel(
      uuid: snapshot['uuid'],
      fcmToken: snapshot['fcmToken'],
      body: snapshot['body'],
      datePublished:snapshot['datePublished'],
      signFormId:snapshot['signFormId'],
    );
  }

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "fcmToken": fcmToken,
        "body": body,
        "datePublished":datePublished,
        "signFormId":signFormId,
      };

  static SignFormModel fromMap(Map map) {
    return SignFormModel(
      uuid: map['uuid'],
      fcmToken: map['fcmToken'],
      body:  map['body'],
      datePublished:map['datePublished'],
      signFormId:map['signFormId'],
    );
  }
}

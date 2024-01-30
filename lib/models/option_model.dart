import 'package:cloud_firestore/cloud_firestore.dart';

class OptionModel {
  String type;
  String subtitle;
  bool necessary;
  String? explain;
  String? other;
  List<String> body;
  OptionModel({
    required this.type,
    required this.subtitle,
    required this.necessary,
    required this.explain,
    required this.other,
    required this.body,
  });

  static Map toMap(OptionModel cart) {
    return {
      "subtitle": cart.subtitle,
      "type": cart.type,
      "necessary": cart.necessary,
      "explain": cart.explain,
      "other": cart.other,
      "body": cart.body,
    };
  }

  static OptionModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return OptionModel(
      subtitle: snapshot['subtitle'],
      type: snapshot['type'],
      necessary: snapshot['necessary'],
      explain: snapshot['explain'],
      other: snapshot['other'],
      body: snapshot['body'],
    );
  }

  Map<String, dynamic> toJson() => {
        "subtitle": subtitle,
        "type": type,
        "necessary": necessary,
        "explain": explain,
        "other": other,
        "body": body,
      };

  static OptionModel fromMap(Map map) {
    return OptionModel(
      subtitle: map['subtitle'],
      type: map['type'],
      necessary: map['necessary'],
      explain: map['explain'],
      other: map['other'],
      body: map['body'],
    );
  }
}

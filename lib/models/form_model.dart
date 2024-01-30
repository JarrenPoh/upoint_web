import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:upoint_web/models/option_model.dart';

class FormModel {
  String title;
  List<OptionModel> options;

  FormModel({
    required this.title,
    required this.options,
  });

  static Map toMap(FormModel cart) {
    return {
      "title": cart.title,
      "options": cart.options,
    };
  }

  static FormModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return FormModel(
      title: snapshot['title'],
      options: snapshot['options'],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "options": options,
      };

  static FormModel fromMap(Map map) {
    return FormModel(
      title: map['title'],
      options: map['options'],
    );
  }
}

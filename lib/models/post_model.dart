import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? photo;
  String? title;
  String? location;
  String? contact;
  String? phoneNumber;
  var startDateTime;
  var endDateTime;
  var formDateTime;
  var remindDateTime;
  String? introduction;
  int? capacity;
  String? content;
  String? reward;
  String? rewardTagId;
  List<dynamic>? tags;
  String? postType;
  String? link;
  //以下尚未填
  String? form;
  String? postId;
  String? organizerUid;
  String? organizerName;
  int? signFormsLength;
  var datePublished;
  String? organizerPic;

  PostModel({
    this.photo,
    this.organizerName,
    this.location,
    this.title,
    this.startDateTime,
    this.endDateTime,
    this.remindDateTime,
    this.introduction,
    this.capacity,
    this.content,
    this.reward,
    this.rewardTagId,
    this.link,
    this.postId,
    this.datePublished,
    this.organizerUid,
    this.signFormsLength,
    this.organizerPic,
    this.form,
    this.tags,
    this.formDateTime,
    this.contact,
    this.phoneNumber,
    this.postType,
  });

  static Map toMap(PostModel cart) {
    return {
      "photo": cart.photo,
      "organizerName": cart.organizerName,
      "title": cart.title,
      "startDateTime": cart.startDateTime,
      "endDateTime": cart.endDateTime,
      "remindDateTime": cart.remindDateTime,
      "location": cart.location,
      "introduction": cart.introduction,
      "content": cart.content,
      "capacity": cart.capacity,
      "reward": cart.reward,
      "rewardTagId": cart.rewardTagId,
      "link": cart.link,
      "postId": cart.postId,
      "datePublished": cart.datePublished,
      "organizerUid": cart.organizerUid,
      "signFormsLength": cart.signFormsLength,
      "organizerPic": cart.organizerPic,
      "form": cart.form,
      "tags": cart.tags,
      "formDateTime": cart.formDateTime,
      "contact": cart.contact,
      "phoneNumber": cart.phoneNumber,
      "postType": cart.postType,
    };
  }

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return PostModel(
      photo: snapshot['photo'],
      organizerName: snapshot['organizerName'],
      title: snapshot['title'],
      startDateTime: snapshot['startDateTime'],
      endDateTime: snapshot['endDateTime'],
      remindDateTime: snapshot['remindDateTime'],
      introduction: snapshot['introduction'],
      content: snapshot['content'],
      capacity: snapshot['capacity'],
      reward: snapshot['reward'],
      location: snapshot['location'],
      rewardTagId: snapshot['rewardTagId'],
      link: snapshot['link'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      organizerUid: snapshot['organizerUid'],
      signFormsLength: snapshot['signFormsLength'],
      organizerPic: snapshot['organizerPic'],
      form: snapshot['form'],
      tags: snapshot['tags'],
      formDateTime: snapshot['formDateTime'],
      contact: snapshot["contact"],
      phoneNumber: snapshot["phoneNumber"],
      postType: snapshot["postType"],
    );
  }

  Map<String, dynamic> toJson() => {
        "photo": photo,
        "organizerName": organizerName,
        "title": title,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "remindDateTime": remindDateTime,
        "introduction": introduction,
        "content": content,
        "reward": reward,
        "capacity": capacity,
        "rewardTagId": rewardTagId,
        "location": location,
        "link": link,
        "postId": postId,
        "datePublished": datePublished,
        "organizerUid": organizerUid,
        "organizerPic": organizerPic,
        "form": form,
        "tags": tags,
        "formDateTime": formDateTime,
        "signFormsLength": signFormsLength,
        "contact": contact,
        "phoneNumber": phoneNumber,
        "postType": postType,
      };

  static PostModel fromMap(Map map) {
    return PostModel(
      photo: map['photo'],
      organizerName: map['organizerName'],
      title: map['title'],
      startDateTime: map['startDateTime'],
      endDateTime: map['endDateTime'],
      remindDateTime: map['remindDateTime'],
      introduction: map["introduction"],
      content: map['content'],
      capacity: map['capacity'],
      location: map['location'],
      reward: map['reward'],
      rewardTagId: map['rewardTagId'],
      link: map['link'],
      postId: map['postId'],
      datePublished: map['datePublished'],
      organizerUid: map['organizerUid'],
      organizerPic: map['organizerPic'],
      form: map['form'],
      tags: map['tags'],
      formDateTime: map['formDateTime'],
      signFormsLength: map['signFormsLength'],
      contact: map["contact"],
      phoneNumber: map["phoneNumber"],
      postType: map["postType"],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? photo;
  String? organizerName;
  String? title;
  String? location;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? introduction;
  String? capacity;
  String? content;
  String? reward;
  String? rewardTagId;
  String? link;
  String? postId;
  String? uid;
  List? signList;
  var datePublished;
  String? pic;

  PostModel({
    this.photo,
    this.organizerName,
    this.location,
    this.title,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.introduction,
    this.capacity,
    this.content,
    this.reward,
    this.rewardTagId,
    this.link,
    this.postId,
    this.datePublished,
    this.uid,
    this.signList,
    this.pic,
  });

  static Map toMap(PostModel cart) {
    return {
      "photo": cart.photo,
      "organizerName": cart.organizerName,
      "title": cart.title,
      "startDate": cart.startDate,
      "endDate":cart.endDate,
      "location": cart.location,
      "startTime": cart.startTime,
      "endTime": cart.endTime,
      "introduction":cart.introduction,
      "content": cart.content,
      "capacity":cart.capacity,
      "reward": cart.reward,
      "rewardTagId": cart.rewardTagId,
      "link": cart.link,
      "postId": cart.postId,
      "datePublished": cart.datePublished,
      "uid": cart.uid,
      "signList": cart.signList,
      "pic": cart.pic,
    };
  }

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return PostModel(
      photo: snapshot['photo'],
      organizerName: snapshot['organizerName'],
      title: snapshot['title'],
      startDate: snapshot['startDate'],
      endDate: snapshot['endDate'],
      startTime: snapshot['startTime'],
      endTime: snapshot['endTime'],
      introduction:snapshot['introduction'],
      content: snapshot['content'],
      capacity:snapshot['capacity'],
      reward: snapshot['reward'],
      location: snapshot['location'],
      rewardTagId: snapshot['rewardTagId'],
      link: snapshot['link'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      uid: snapshot['uid'],
      signList: snapshot['signList'],
      pic: snapshot['pic'],
    );
  }

  Map<String, dynamic> toJson() => {
        "photo": photo,
        "organizerName": organizerName,
        "title": title,
        "startDate": startDate,
        "endDate":endDate,
        "startTime": startTime,
        "endTime": endTime,
        "introduction":introduction,
        "content": content,
        "reward": reward,
        "capacity":capacity,
        "rewardTagId": rewardTagId,
        "location": location,
        "link": link,
        "postId": postId,
        "datePublished": datePublished,
        "uid": uid,
        "pic": pic,
      };

  static PostModel fromMap(Map map) {
    return PostModel(
      photo: map['photo'],
      organizerName: map['organizerName'],
      title: map['title'],
      startDate: map['startDate'],
      endDate:map['endDate'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      introduction: map["introduction"],
      content: map['content'],
      capacity:map['capacity'],
      location: map['location'],
      reward: map['reward'],
      rewardTagId: map['rewardTagId'],
      link: map['link'],
      postId: map['postId'],
      datePublished: map['datePublished'],
      uid: map['uid'],
      pic: map['pic'],
    );
  }
}

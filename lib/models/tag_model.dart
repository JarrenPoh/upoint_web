
class TagModel {
  String type;
  String title;
  List tagValue;
  TagModel({
    required this.type,
    required this.title,
    required this.tagValue,
  });


  Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "tagValue": tagValue,
      };

  static TagModel fromMap(Map map) {
    return TagModel(
      title: map['title'],
      type: map['type'],
      tagValue:  List.from(map['tagValue'].map((item) => item as String)),
    );
  }
}

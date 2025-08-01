class ReasonsListModel {
  int? id;
  String? title;

  ReasonsListModel({
    this.id,
    this.title,
  });

  factory ReasonsListModel.fromJson(Map<String, dynamic> json) => ReasonsListModel(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

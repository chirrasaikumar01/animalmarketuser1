
class FeatureListModel {
  int? id;
  int? catId;
  String? title;
  String? inputName;
  String? slug;
  int? status;


  FeatureListModel({
    this.id,
    this.catId,
    this.title,
    this.inputName,
    this.slug,
    this.status,
  });

  factory FeatureListModel.fromJson(Map<String, dynamic> json) => FeatureListModel(
    id: json["id"],
    catId: json["cat_id"],
    title: json["title"],
    inputName: json["input_name"],
    slug: json["slug"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cat_id": catId,
    "title": title,
    "input_name": inputName,
    "slug": slug,
    "status": status,
  };
}

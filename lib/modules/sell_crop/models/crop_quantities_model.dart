class CropQuantitiesModel {
  int? id;
  String? title;
  String? slug;

  CropQuantitiesModel({
    this.id,
    this.title,
    this.slug,
  });

  factory CropQuantitiesModel.fromJson(Map<String, dynamic> json) => CropQuantitiesModel(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
      };
}

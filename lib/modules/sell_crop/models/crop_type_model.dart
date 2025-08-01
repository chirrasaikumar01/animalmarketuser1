class CropTypeModel {
  int? id;
  String? cropCategory;
  String? title;
  String? slug;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  CropTypeModel({
    this.id,
    this.cropCategory,
    this.title,
    this.slug,
    this.status,
  });

  factory CropTypeModel.fromJson(Map<String, dynamic> json) => CropTypeModel(
        id: json["id"],
        cropCategory: json["crop_category"],
        title: json["title"],
        slug: json["slug"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "crop_category": cropCategory,
        "title": title,
        "slug": slug,
        "status": status,
      };
}

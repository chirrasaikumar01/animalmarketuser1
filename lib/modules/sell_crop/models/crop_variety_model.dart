class CropVarietyModel {
  int? id;
  String? cropCategory;
  String? cropName;
  String? title;
  String? slug;
  int? status;

  CropVarietyModel({
    this.id,
    this.cropCategory,
    this.cropName,
    this.title,
    this.slug,
    this.status,
  });

  factory CropVarietyModel.fromJson(Map<String, dynamic> json) => CropVarietyModel(
        id: json["id"],
        cropCategory: json["crop_category"],
        cropName: json["crop_name"],
        title: json["title"],
        slug: json["slug"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "crop_category": cropCategory,
        "crop_name": cropName,
        "title": title,
        "slug": slug,
        "status": status,
      };
}

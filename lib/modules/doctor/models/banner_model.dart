class BannerModel {
  int? id;
  String? type;
  String? altText;
  String? image;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  BannerModel({
    this.id,
    this.type,
    this.altText,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json["id"],
    type: json["type"],
    altText: json["alt_text"],
    image: json["image"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "alt_text": altText,
    "image": image,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
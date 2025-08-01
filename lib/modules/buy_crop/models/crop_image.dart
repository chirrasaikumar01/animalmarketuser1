class CropImage {
  int? id;
  int? cropId;
  String? image;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  CropImage({
    this.id,
    this.cropId,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CropImage.fromJson(Map<String, dynamic> json) => CropImage(
    id: json["id"],
    cropId: json["crop_id"],
    image: json["path"],
    type: json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "crop_id": cropId,
    "path": image,
    "type": type,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
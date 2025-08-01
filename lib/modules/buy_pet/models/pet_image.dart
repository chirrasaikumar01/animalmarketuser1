class PetImage {
  int? id;
  int? petId;
  String? type;
  String? path;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  PetImage({
    this.id,
    this.petId,
    this.type,
    this.path,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory PetImage.fromJson(Map<String, dynamic> json) => PetImage(
    id: json["id"],
    petId: json["pet_id"],
    type: json["type"],
    path: json["path"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pet_id": petId,
    "type": type,
    "path": path,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
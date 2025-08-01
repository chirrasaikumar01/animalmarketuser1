class CattleImage {
  int? id;
  int? cattleId;
  String? image;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  CattleImage({
    this.id,
    this.cattleId,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CattleImage.fromJson(Map<String, dynamic> json) => CattleImage(
        id: json["id"],
        cattleId: json["cattle_id"],
        image: json["path"],
        type: json["type"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cattle_id": cattleId,
        "path": image,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

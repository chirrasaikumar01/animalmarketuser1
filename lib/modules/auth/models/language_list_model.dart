class LanguageListModel {
  int? id;
  String? title;
  String? slug;
  String? languageCode;
  String? firstLetter;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  LanguageListModel({
    this.id,
    this.title,
    this.slug,
    this.languageCode,
    this.firstLetter,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory LanguageListModel.fromJson(Map<String, dynamic> json) => LanguageListModel(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        languageCode: json["language_code"],
        status: json["status"],
        firstLetter: json["visible_code"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "language_code": languageCode,
        "visible_code": firstLetter,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

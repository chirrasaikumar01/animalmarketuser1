class BreedListModel {
  int? id;
  int? categoryId;
  int? subCategoryId;
  String? title;
  String? slug;
  int? status;

  BreedListModel({
    this.id,
    this.categoryId,
    this.subCategoryId,
    this.title,
    this.slug,
    this.status,
  });

  factory BreedListModel.fromJson(Map<String, dynamic> json) => BreedListModel(
        id: json["id"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        title: json["title"],
        slug: json["slug"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "title": title,
        "slug": slug,
        "status": status,
      };
}

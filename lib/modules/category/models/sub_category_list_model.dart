class SubCategoryListModel {
  int? id;
  String? title;
  String? image;
  String? slug;

  SubCategoryListModel({
    this.id,
    this.title,
    this.image,
    this.slug,
  });

  factory SubCategoryListModel.fromJson(Map<String, dynamic> json) => SubCategoryListModel(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "slug": slug,
      };
}

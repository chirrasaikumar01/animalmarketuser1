class CategoryListModel {
  int? id;
  String? title;
  String? subHeading;
  String? image;

  CategoryListModel({
    this.id,
    this.title,
    this.subHeading,
    this.image,
  });

  factory CategoryListModel.fromJson(Map<String, dynamic> json) => CategoryListModel(
        id: json["id"],
        title: json["title"],
        subHeading: json["sub_heading"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sub_heading": subHeading,
        "image": image,
      };
}



class KnowledgeListData {
  int? id;
  String? title;
  int? catId;
  String? subCatId;
  String? categoryName;
  String? subcategoryName;
  String? description;
  String? image;
  String? video;
  dynamic document;
  dynamic pdf;
  dynamic isFavourite;
  String? link;
  String? date;
  String? postedAgo;

  KnowledgeListData({
    this.id,
    this.title,
    this.catId,
    this.subCatId,
    this.categoryName,
    this.subcategoryName,
    this.description,
    this.image,
    this.video,
    this.document,
    this.pdf,
    this.link,
    this.date,
    this.isFavourite,
    this.postedAgo,
  });

  factory KnowledgeListData.fromJson(Map<String, dynamic> json) => KnowledgeListData(
        id: json["id"],
        title: json["title"],
        catId: json["cat_id"],
        subCatId: json["sub_cat_id"],
        categoryName: json["category_name"],
        subcategoryName: json["subcategory_name"],
        description: json["description"],
        image: json["image"],
        video: json["video"],
        document: json["document"]??"",
        pdf: json["pdf"]??"",
        link: json["link"],
        date: json["date"],
        postedAgo: json["posted_ago"],
        isFavourite: json["is_favourite"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "cat_id": catId,
        "sub_cat_id": subCatId,
        "category_name": categoryName,
        "subcategory_name": subcategoryName,
        "description": description,
        "image": image,
        "video": video,
        "document": document,
        "pdf": pdf,
        "link": link,
        "date": date,
       "posted_ago":postedAgo,
        "is_favourite": isFavourite,
      };
}

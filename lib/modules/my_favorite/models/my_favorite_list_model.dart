import 'package:animal_market/modules/buy/models/seller_model.dart';

class MyFavoriteListModel {
  int? id;
  dynamic categoryId;
  dynamic subCategoryId;
  int? sellerId;
  String? title;
  dynamic price;
  String? address;
  String? state;
  String? city;
  String? latitude;
  String? longitude;
  String? verifyStatus;
  int? viewsCount;
  int? callsCount;
  String? description;
  String? type;
  Seller? seller;
  List<Image>? images;
  int? catId;
  int? isLiked;
  String? image;
  int? commentCount;
  String? postTime;
  String? userName;
  String? userProfileImage;
  String? subCatId;
  String? categoryName;
  String? subcategoryName;
  String? video;
  String? document;
  String? pdf;
  String? link;
  String? date;

  MyFavoriteListModel({
    this.id,
    this.categoryId,
    this.subCategoryId,
    this.sellerId,
    this.title,
    this.price,
    this.address,
    this.state,
    this.city,
    this.latitude,
    this.longitude,
    this.verifyStatus,
    this.viewsCount,
    this.callsCount,
    this.description,
    this.type,
    this.seller,
    this.images,
    this.catId,
    this.isLiked,
    this.image,
    this.commentCount,
    this.postTime,
    this.userName,
    this.userProfileImage,
    this.subCatId,
    this.categoryName,
    this.subcategoryName,
    this.video,
    this.document,
    this.pdf,
    this.link,
    this.date,
  });

  factory MyFavoriteListModel.fromJson(Map<String, dynamic> json) => MyFavoriteListModel(
    id: json["id"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    sellerId: json["seller_id"],
    title: json["title"],
    price: json["price"],
    address: json["address"],
    state: json["state"],
    city: json["city"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    verifyStatus: json["verify_status"],
    viewsCount: json["views_count"],
    callsCount: json["calls_count"],
    description: json["description"],
    type: json["type"],
    seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
    images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
    catId: json["cat_id"],
    isLiked: json["is_liked"],
    image: json["image"],
    commentCount: json["comment_count"],
    postTime: json["post_time"],
    userName: json["user_name"],
    userProfileImage: json["user_profile_image"],
    subCatId: json["sub_cat_id"],
    categoryName: json["category_name"],
    subcategoryName: json["subcategory_name"],
    video: json["video"],
    document: json["document"],
    pdf: json["pdf"],
    link: json["link"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "seller_id": sellerId,
    "title": title,
    "price": price,
    "address": address,
    "state": state,
    "city": city,
    "latitude": latitude,
    "longitude": longitude,
    "verify_status": verifyStatus,
    "views_count": viewsCount,
    "calls_count": callsCount,
    "description": description,
    "type": type,
    "seller": seller?.toJson(),
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    "cat_id": catId,
    "is_liked": isLiked,
    "image": image,
    "comment_count": commentCount,
    "post_time": postTime,
    "user_name": userName,
    "user_profile_image": userProfileImage,
    "sub_cat_id": subCatId,
    "category_name": categoryName,
    "subcategory_name": subcategoryName,
    "video": video,
    "document": document,
    "pdf": pdf,
    "link": link,
    "date": date,
  };
}

class Image {
  int? id;
  int? cropId;
  String? type;
  String? path;
  dynamic deletedAt;
  int? cattleId;
  int? petId;

  Image({
    this.id,
    this.cropId,
    this.type,
    this.path,
    this.deletedAt,
    this.cattleId,
    this.petId,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json["id"],
    cropId: json["crop_id"],
    type: json["type"],
    path: json["path"],
    deletedAt: json["deleted_at"],
    cattleId: json["cattle_id"],
    petId: json["pet_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "crop_id": cropId,
    "type": type,
    "path": path,
    "deleted_at": deletedAt,
    "cattle_id": cattleId,
    "pet_id": petId,
  };
}


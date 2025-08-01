import 'package:animal_market/modules/buy/models/cattle_image.dart';
import 'package:animal_market/modules/buy/models/seller_model.dart';

class CattleListModel {
  int? id;
  String? uniqueCode;
  String? title;
  dynamic price;
  String? address;
  String? state;
  String? city;
  dynamic isNegotiable;
  dynamic isFavourite;
  dynamic categoryId;
  String? pincode;
  Seller? seller;
  String? postedAgo;
  List<CattleImage>? cattleImages;
  List<CattleImage>? audioFiles;

  CattleListModel({
    this.id,
    this.uniqueCode,
    this.title,
    this.price,
    this.address,
    this.state,
    this.city,
    this.isNegotiable,
    this.pincode,
    this.seller,
    this.cattleImages,
    this.audioFiles,
    this.isFavourite,
    this.postedAgo,
    this.categoryId,
  });

  factory CattleListModel.fromJson(Map<String, dynamic> json) => CattleListModel(
      id: json["id"],
      uniqueCode: json["unique_code"],
      title: json["title"],
      price: json["price"],
      address: json["address"],
      state: json["state"],
      city: json["city"],
      isNegotiable: json["is_negotiable"],
      pincode: json["pincode"],
      isFavourite: json["is_favourite"],
      postedAgo: json["posted_ago"],
      categoryId: json["category_id"],
      seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
      cattleImages: json["cattle_images"] == null
          ? []
          : List<CattleImage>.from(
              json["cattle_images"]!.where((x) => x["type"] == "Video" || x["type"] == "Image").map((x) => CattleImage.fromJson(x)),
            ),
      audioFiles: json["cattle_images"] == null
          ? []
          : List<CattleImage>.from(
              json["cattle_images"]!.where((x) => x["type"] == "audio").map((x) => CattleImage.fromJson(x)).toList(),
            )
      // cattleImages: json["cattle_images"] == null ? [] : List<CattleImage>.from(json["cattle_images"]!.map((x) => CattleImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unique_code": uniqueCode,
        "title": title,
        "price": price,
        "address": address,
        "state": state,
        "city": city,
        "is_negotiable": isNegotiable,
        "pincode": pincode,
        "is_favourite": isFavourite,
        "seller": seller?.toJson(),
        "posted_ago": postedAgo,
        "category_id": categoryId,
        "cattle_images": cattleImages == null ? [] : List<dynamic>.from(cattleImages!.map((x) => x.toJson())),
      };
}

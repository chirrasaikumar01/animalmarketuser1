import 'package:animal_market/modules/buy/models/seller_model.dart';
import 'package:animal_market/modules/buy_crop/models/crop_image.dart';

class CropListModel {
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
  List<CropImage>? cropImages;
  List<CropImage>? audioFiles;
  String? postedAgo;

  CropListModel({
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
    this.cropImages,
    this.isFavourite,
    this.postedAgo,
    this.categoryId,
    this.audioFiles,
  });

  factory CropListModel.fromJson(Map<String, dynamic> json) => CropListModel(
        id: json["id"],
        uniqueCode: json["unique_code"],
        categoryId: json["category_id"],
        title: json["title"],
        price: json["price"],
        address: json["address"],
        state: json["state"],
        city: json["city"],
        isNegotiable: json["is_negotiable"],
        pincode: json["pincode"],
        isFavourite: json["is_favourite"],
        seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
    cropImages: json["crop_images"] == null
        ? []
        : List<CropImage>.from(
      json["crop_images"]!.where((x) => x["type"] == "Video" || x["type"] == "Image").map((x) => CropImage.fromJson(x)),
    ),
        audioFiles: json["crop_images"] == null
            ? []
            : List<CropImage>.from(
                json["crop_images"]!.where((x) => x["type"] == "audio").map((x) => CropImage.fromJson(x)),
              ),
       // cropImages: json["crop_images"] == null ? [] : List<CropImage>.from(json["crop_images"]!.map((x) => CropImage.fromJson(x))),
        postedAgo: json["posted_ago"],
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
        "is_favourite": isFavourite,
        "pincode": pincode,
        "category_id": categoryId,
        "seller": seller?.toJson(),
        "crop_images": cropImages == null ? [] : List<dynamic>.from(cropImages!.map((x) => x.toJson())),
         "posted_ago":postedAgo,
      };
}

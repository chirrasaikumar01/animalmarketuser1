import 'package:animal_market/modules/buy/models/seller_model.dart';
import 'package:animal_market/modules/buy_pet/models/pet_image.dart';

class PetListModel {
  int? id;
  String? uniqueCode;
  String? title;
  String? price;
  String? address;
  String? state;
  String? city;
  String? latitude;
  String? longitude;
  dynamic isNegotiable;
  dynamic categoryId;
  String? pincode;
  Seller? seller;
  int? isFavourite;
  List<PetImage>? petImages;
  List<PetImage>? audioFiles;
  String? postedAgo;


  PetListModel({
    this.id,
    this.uniqueCode,
    this.title,
    this.price,
    this.address,
    this.state,
    this.city,
    this.latitude,
    this.longitude,
    this.isNegotiable,
    this.pincode,
    this.seller,
    this.isFavourite,
    this.petImages,
    this.postedAgo,
    this.categoryId,
    this.audioFiles,
  });

  factory PetListModel.fromJson(Map<String, dynamic> json) => PetListModel(
        id: json["id"],
        uniqueCode: json["unique_code"],
        title: json["title"],
        price: json["price"],
        address: json["address"],
        state: json["state"],
        city: json["city"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isNegotiable: json["is_negotiable"],
        pincode: json["pincode"],
        seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
        isFavourite: json["is_favourite"],
        categoryId: json["category_id"],
        petImages: json["pet_images"] == null
            ? []
            : List<PetImage>.from(
                json["pet_images"]!.where((x) => x["type"] == "Video" || x["type"] == "Image").map((x) => PetImage.fromJson(x)),
              ),
        audioFiles: json["pet_images"] == null
            ? []
            : List<PetImage>.from(
                json["pet_images"]!.where((x) => x["type"] == "audio").map((x) => PetImage.fromJson(x)),
              ),
        //    petImages: json["pet_images"] == null ? [] : List<PetImage>.from(json["pet_images"]!.map((x) => PetImage.fromJson(x))),
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
        "latitude": latitude,
        "longitude": longitude,
        "is_negotiable": isNegotiable,
        "pincode": pincode,
        "seller": seller?.toJson(),
        "is_favourite": isFavourite,
        "pet_images": petImages == null ? [] : List<dynamic>.from(petImages!.map((x) => x.toJson())),
        "posted_ago": postedAgo,
        "category_id": categoryId,
      };
}

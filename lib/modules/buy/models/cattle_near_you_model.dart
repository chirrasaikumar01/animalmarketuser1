import 'package:animal_market/modules/buy/models/cattle_image.dart';

class CattleNearYouModel {
  int? id;
  String? title;
  String? description;
  String? address;
  dynamic state;
  dynamic city;
  String? latitude;
  String? longitude;
  dynamic price;
  List<CattleImage>? cattleImages;

  CattleNearYouModel({
    this.id,
    this.title,
    this.description,
    this.address,
    this.state,
    this.city,
    this.latitude,
    this.longitude,
    this.price,
    this.cattleImages,
  });

  factory CattleNearYouModel.fromJson(Map<String, dynamic> json) => CattleNearYouModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    address: json["address"],
    state: json["state"],
    city: json["city"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    price: json["price"],
    cattleImages: json["cattle_images"] == null ? [] : List<CattleImage>.from(json["cattle_images"]!.map((x) => CattleImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "address": address,
    "state": state,
    "city": city,
    "latitude": latitude,
    "longitude": longitude,
    "price": price,
    "cattle_images": cattleImages == null ? [] : List<dynamic>.from(cattleImages!.map((x) => x.toJson())),
  };
}



import 'package:animal_market/modules/buy_pet/models/pet_image.dart';

class PetNearYouModel {
  int? id;
  String? title;
  String? description;
  String? address;
  String? state;
  String? city;
  String? latitude;
  String? longitude;
  String? price;
  int? isFavourite;
  List<PetImage>? petImages;

  PetNearYouModel({
    this.id,
    this.title,
    this.description,
    this.address,
    this.state,
    this.city,
    this.latitude,
    this.longitude,
    this.price,
    this.isFavourite,
    this.petImages,
  });

  factory PetNearYouModel.fromJson(Map<String, dynamic> json) => PetNearYouModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    address: json["address"],
    state: json["state"],
    city: json["city"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    price: json["price"],
    isFavourite: json["is_favourite"],
    petImages: json["pet_images"] == null ? [] : List<PetImage>.from(json["pet_images"]!.map((x) => PetImage.fromJson(x))),
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
    "is_favourite": isFavourite,
    "pet_images": petImages == null ? [] : List<dynamic>.from(petImages!.map((x) => x.toJson())),
  };
}



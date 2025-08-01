import 'package:animal_market/modules/account/models/city_list_model.dart';
import 'package:animal_market/modules/account/models/state_list_model.dart';
import 'package:animal_market/modules/buy/models/cattle_image.dart';
import 'package:animal_market/modules/buy/models/seller_model.dart';

class CattleDetailsModel {
  int? id;
  String? uniqueCode;
  dynamic sellerId;
  String? subCategoryId;
  String? categoryId;
  String? breed;
  dynamic age;
  String? title;
  String? description;
  dynamic isMilk;
  dynamic milkCapacity;
  dynamic isNegotiable;
  dynamic price;
  String? gender;
  String? breedName;
  String? pregnencyHistoryTitle;
  dynamic isVaccinated;
  dynamic isBabyDelivered;
  dynamic healthStatusTitle;
  dynamic isPregnent;
  dynamic isCalf;
  dynamic calfCount;
  dynamic healthStatus;
  String? state;
  String? city;
  String? pincode;
  String? address;
  String? latitude;
  String? longitude;
  String? sellerType;
  dynamic status;
  String? verifyStatus;
  dynamic callsCount;
  dynamic viewsCount;
  dynamic createdBy;
  String? postedAgo;
  List<CattleImage>? cattleImages;
  Seller? seller;
  StateListModel? stateData;
  CityListModel? cities;

  CattleDetailsModel({
    this.id,
    this.uniqueCode,
    this.sellerId,
    this.subCategoryId,
    this.categoryId,
    this.breed,
    this.age,
    this.title,
    this.description,
    this.isMilk,
    this.milkCapacity,
    this.isNegotiable,
    this.price,
    this.gender,
    this.breedName,
    this.pregnencyHistoryTitle,
    this.isVaccinated,
    this.isBabyDelivered,
    this.healthStatusTitle,
    this.isPregnent,
    this.isCalf,
    this.calfCount,
    this.healthStatus,
    this.state,
    this.city,
    this.pincode,
    this.address,
    this.latitude,
    this.longitude,
    this.sellerType,
    this.status,
    this.verifyStatus,
    this.callsCount,
    this.viewsCount,
    this.createdBy,
    this.cattleImages,
    this.seller,
    this.stateData,
    this.cities,
    this.postedAgo,
  });

  factory CattleDetailsModel.fromJson(Map<String, dynamic> json) => CattleDetailsModel(
        id: json["id"],
        uniqueCode: json["unique_code"],
        sellerId: json["seller_id"],
        subCategoryId: json["sub_category_id"],
        categoryId: json["category_id"],
        breed: json["breed"],
        age: json["age"],
        title: json["title"],
        description: json["description"],
        isMilk: json["is_milk"],
        milkCapacity: json["milk_capacity"],
        isNegotiable: json["is_negotiable"],
        price: json["price"],
        gender: json["gender"],
        breedName: json["breed_name"],
        pregnencyHistoryTitle: json["pregnency_history_title"],
        isVaccinated: json["is_vaccinated"],
        isBabyDelivered: json["is_baby_delivered"],
        healthStatusTitle: json["health_status_title"],
        isPregnent: json["is_pregnent"],
        isCalf: json["is_calf"],
        calfCount: json["calf_count"],
        healthStatus: json["health_status"],
        state: json["state"],
        city: json["city"],
        pincode: json["pincode"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        sellerType: json["seller_type"],
        status: json["status"],
        verifyStatus: json["verify_status"],
        callsCount: json["calls_count"],
        viewsCount: json["views_count"],
        createdBy: json["created_by"],
        postedAgo: json["posted_ago"],
        cattleImages: json["cattle_images"] == null ? [] : List<CattleImage>.from(json["cattle_images"]!.map((x) => CattleImage.fromJson(x))),
        seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
        stateData: json["state_data"] == null ? null : StateListModel.fromJson(json["state_data"]),
        cities: json["cities"] == null ? null : CityListModel.fromJson(json["cities"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unique_code": uniqueCode,
        "seller_id": sellerId,
        "sub_category_id": subCategoryId,
        "category_id": categoryId,
        "breed": breed,
        "age": age,
        "title": title,
        "description": description,
        "is_milk": isMilk,
        "milk_capacity": milkCapacity,
        "is_negotiable": isNegotiable,
        "price": price,
        "gender": gender,
        "breed_name": breedName,
        "pregnency_history_title": pregnencyHistoryTitle,
        "is_vaccinated": isVaccinated,
        "is_baby_delivered": isBabyDelivered,
        "health_status_title": healthStatusTitle,
        "is_pregnent": isPregnent,
        "is_calf": isCalf,
        "calf_count": calfCount,
        "health_status": healthStatus,
        "state": state,
        "city": city,
        "pincode": pincode,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "seller_type": sellerType,
        "status": status,
        "verify_status": verifyStatus,
        "calls_count": callsCount,
        "views_count": viewsCount,
        "created_by": createdBy,
        "posted_ago":postedAgo,
        "cattle_images": cattleImages == null ? [] : List<dynamic>.from(cattleImages!.map((x) => x.toJson())),
        "seller": seller?.toJson(),
        "state_data": stateData?.toJson(),
        "cities": cities?.toJson(),
      };
}

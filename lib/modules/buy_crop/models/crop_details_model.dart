

import 'package:animal_market/modules/buy/models/seller_model.dart';
import 'package:animal_market/modules/buy_crop/models/crop_image.dart';


class CropDetailModel {
  int? id;
  String? uniqueCode;
  int? sellerId;
  int? categoryId;
  int? subCategoryId;
  String? title;
  String? description;
  int? cropVariety;
  int? cropType;
  String? quantityType;
  int? quantity;
  String? cropCondition;
  String? age;
  dynamic otherAgeValue;
  int? price;
  int? isOrganic;
  int? isQualityTested;
  String? storageCondition;
  int? isNegotiable;
  String? cropQuality;
  dynamic weight;
  String? state;
  String? city;
  String? pincode;
  String? address;
  String? latitude;
  String? longitude;
  String? harvestAge;
  String? dryorwet;
  String? transportationFacility;
  String? remainTimeToHarvest;
  String? farmingType;
  int? isHarvested;
  int? callsCount;
  int? viewsCount;
  int? status;
  String? verifyStatus;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? isFavourite;
  List<CropImage>? cropImages;
  Seller? seller;
  String? postedAgo;

  CropDetailModel({
    this.id,
    this.uniqueCode,
    this.sellerId,
    this.categoryId,
    this.subCategoryId,
    this.title,
    this.description,
    this.cropVariety,
    this.cropType,
    this.quantityType,
    this.quantity,
    this.cropCondition,
    this.age,
    this.otherAgeValue,
    this.price,
    this.isOrganic,
    this.isQualityTested,
    this.storageCondition,
    this.isNegotiable,
    this.cropQuality,
    this.weight,
    this.state,
    this.city,
    this.pincode,
    this.address,
    this.latitude,
    this.longitude,
    this.harvestAge,
    this.dryorwet,
    this.transportationFacility,
    this.remainTimeToHarvest,
    this.farmingType,
    this.isHarvested,
    this.callsCount,
    this.viewsCount,
    this.status,
    this.verifyStatus,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isFavourite,
    this.cropImages,
    this.seller,
    this.postedAgo
  });

  factory CropDetailModel.fromJson(Map<String, dynamic> json) => CropDetailModel(
    id: json["id"],
    uniqueCode: json["unique_code"],
    sellerId: json["seller_id"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    title: json["title"],
    description: json["description"],
    cropVariety: json["crop_variety"],
    cropType: json["crop_type"],
    quantityType: json["quantity_type"],
    quantity: json["quantity"],
    cropCondition: json["crop_condition"],
    age: json["age"],
    otherAgeValue: json["other_age_value"],
    price: json["price"],
    isOrganic: json["is_organic"],
    isQualityTested: json["is_quality_tested"],
    storageCondition: json["storage_condition"],
    isNegotiable: json["is_negotiable"],
    cropQuality: json["crop_quality"],
    weight: json["weight"],
    state: json["state"],
    city: json["city"],
    pincode: json["pincode"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    harvestAge: json["harvest_age"],
    dryorwet: json["dryorwet"],
    transportationFacility: json["transportation_facility"],
    remainTimeToHarvest: json["remain_time_to_harvest"],
    farmingType: json["farming_type"],
    isHarvested: json["is_harvested"],
    callsCount: json["calls_count"],
    viewsCount: json["views_count"],
    status: json["status"],
    verifyStatus: json["verify_status"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    isFavourite: json["is_favourite"],
    cropImages: json["crop_images"] == null ? [] : List<CropImage>.from(json["crop_images"]!.map((x) => CropImage.fromJson(x))),
    seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
    postedAgo: json["posted_ago"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_code": uniqueCode,
    "seller_id": sellerId,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "title": title,
    "description": description,
    "crop_variety": cropVariety,
    "crop_type": cropType,
    "quantity_type": quantityType,
    "quantity": quantity,
    "crop_condition": cropCondition,
    "age": age,
    "other_age_value": otherAgeValue,
    "price": price,
    "is_organic": isOrganic,
    "is_quality_tested": isQualityTested,
    "storage_condition": storageCondition,
    "is_negotiable": isNegotiable,
    "crop_quality": cropQuality,
    "weight": weight,
    "state": state,
    "city": city,
    "pincode": pincode,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "harvest_age": harvestAge,
    "dryorwet": dryorwet,
    "transportation_facility": transportationFacility,
    "remain_time_to_harvest": remainTimeToHarvest,
    "farming_type": farmingType,
    "is_harvested": isHarvested,
    "calls_count": callsCount,
    "views_count": viewsCount,
    "status": status,
    "verify_status": verifyStatus,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "is_favourite": isFavourite,
    "crop_images": cropImages == null ? [] : List<CropImage>.from(cropImages!.map((x) => x.toJson())),
    "seller": seller?.toJson(),
    "posted_ago":postedAgo,
  };
}


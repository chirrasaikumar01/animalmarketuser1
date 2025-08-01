// To parse this JSON data, do
//
//     final patDetailsModel = patDetailsModelFromJson(jsonString);



import 'package:animal_market/modules/buy/models/seller_model.dart';
import 'package:animal_market/modules/buy_pet/models/pet_image.dart';


class PatDetailsModel {
  int? id;
  String? uniqueCode;
  int? sellerId;
  String? title;
  String? description;
  String? purpose;
  int? categoryId;
  int? subCategoryId;
  int? breed;
  String? gender;
  String? ageType;
  dynamic age;
  dynamic isNegotiable;
  dynamic price;
  String? vaccination;
  dynamic vaccineName;
  dynamic vaccineDate;
  String? state;
  String? city;
  String? pincode;
  String? address;
  dynamic latitude;
  dynamic longitude;
  dynamic isMicrochipped;
  dynamic isDewormed;
  dynamic isNeutered;
  dynamic requiresSpecialCare;
  dynamic goodWithPets;
  dynamic goodWithKids;
  dynamic isTrained;
  String? trainingType;
  String? deliveryOption;
  String? shippingCharges;
  String? packingCharges;
  dynamic createdBy;
  dynamic callsCount;
  dynamic viewsCount;
  dynamic status;
  String? verifyStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? farmingType;
  String? petQuality;
  dynamic isFavourite;
  String? breedName;
  List<PetImage>? petImages;
  Seller? seller;
  String? postedAgo;

  PatDetailsModel({
    this.id,
    this.uniqueCode,
    this.sellerId,
    this.title,
    this.description,
    this.purpose,
    this.categoryId,
    this.subCategoryId,
    this.breed,
    this.gender,
    this.ageType,
    this.age,
    this.isNegotiable,
    this.price,
    this.vaccination,
    this.vaccineName,
    this.vaccineDate,
    this.state,
    this.city,
    this.pincode,
    this.address,
    this.latitude,
    this.longitude,
    this.isMicrochipped,
    this.isDewormed,
    this.isNeutered,
    this.requiresSpecialCare,
    this.goodWithPets,
    this.goodWithKids,
    this.isTrained,
    this.trainingType,
    this.deliveryOption,
    this.shippingCharges,
    this.packingCharges,
    this.createdBy,
    this.callsCount,
    this.viewsCount,
    this.status,
    this.verifyStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.farmingType,
    this.petQuality,
    this.isFavourite,
    this.breedName,
    this.petImages,
    this.seller,
    this.postedAgo,
  });

  factory PatDetailsModel.fromJson(Map<String, dynamic> json) => PatDetailsModel(
    id: json["id"],
    uniqueCode: json["unique_code"],
    sellerId: json["seller_id"],
    title: json["title"],
    description: json["description"],
    purpose: json["purpose"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    breed: json["breed"],
    gender: json["gender"],
    ageType: json["age_type"],
    age: json["age"],
    isNegotiable: json["is_negotiable"],
    price: json["price"],
    vaccination: json["vaccination"],
    vaccineName: json["vaccine_name"],
    vaccineDate: json["vaccine_date"],
    state: json["state"],
    city: json["city"],
    pincode: json["pincode"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    isMicrochipped: json["is_microchipped"],
    isDewormed: json["is_dewormed"],
    isNeutered: json["is_neutered"],
    requiresSpecialCare: json["requires_special_care"],
    goodWithPets: json["good_with_pets"],
    goodWithKids: json["good_with_kids"],
    isTrained: json["is_trained"],
    trainingType: json["training_type"],
    deliveryOption: json["delivery_option"],
    shippingCharges: json["shipping_charges"],
    packingCharges: json["packing_charges"],
    createdBy: json["created_by"],
    callsCount: json["calls_count"],
    viewsCount: json["views_count"],
    status: json["status"],
    verifyStatus: json["verify_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    farmingType: json["farming_type"],
    petQuality: json["pet_quality"],
    isFavourite: json["is_favourite"],
    breedName: json["breed_name"],
    petImages: json["pet_images"] == null ? [] : List<PetImage>.from(json["pet_images"]!.map((x) => PetImage.fromJson(x))),
    seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
    postedAgo: json["posted_ago"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_code": uniqueCode,
    "seller_id": sellerId,
    "title": title,
    "description": description,
    "purpose": purpose,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "breed": breed,
    "gender": gender,
    "age_type": ageType,
    "age": age,
    "is_negotiable": isNegotiable,
    "price": price,
    "vaccination": vaccination,
    "vaccine_name": vaccineName,
    "vaccine_date": vaccineDate,
    "state": state,
    "city": city,
    "pincode": pincode,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "is_microchipped": isMicrochipped,
    "is_dewormed": isDewormed,
    "is_neutered": isNeutered,
    "requires_special_care": requiresSpecialCare,
    "good_with_pets": goodWithPets,
    "good_with_kids": goodWithKids,
    "is_trained": isTrained,
    "training_type": trainingType,
    "delivery_option": deliveryOption,
    "shipping_charges": shippingCharges,
    "packing_charges": packingCharges,
    "created_by": createdBy,
    "calls_count": callsCount,
    "views_count": viewsCount,
    "status": status,
    "verify_status": verifyStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "farming_type": farmingType,
    "pet_quality": petQuality,
    "is_favourite": isFavourite,
    "breed_name": breedName,
    "pet_images": petImages == null ? [] : List<dynamic>.from(petImages!.map((x) => x.toJson())),
    "seller": seller?.toJson(),
    "posted_ago":postedAgo,
  };
}



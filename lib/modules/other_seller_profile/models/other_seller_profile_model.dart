import 'package:animal_market/modules/buy/models/cattle_list_model.dart';
import 'package:animal_market/modules/buy/models/seller_model.dart';
import 'package:animal_market/modules/buy_crop/models/crop_list_model.dart';
import 'package:animal_market/modules/buy_pet/models/pet_list_model.dart';
import 'package:animal_market/modules/community/models/blog_post_list_model.dart';

class OtherSellerProfileModel {
  Seller? seller;
  List<CropListModel>? crop;
  List<CattleListModel>? cattle;
  List<PetListModel>? pet;
  List<BlogListModel>? community;

  OtherSellerProfileModel({
    this.seller,
    this.crop,
    this.cattle,
    this.pet,
    this.community,
  });

  factory OtherSellerProfileModel.fromJson(Map<String, dynamic> json) => OtherSellerProfileModel(
    seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
    crop: json["crop"] == null ? [] : List<CropListModel>.from(json["crop"]!.map((x) => CropListModel.fromJson(x))),
    cattle: json["cattle"] == null ? [] : List<CattleListModel>.from(json["cattle"]!.map((x) => CattleListModel.fromJson(x))),
    pet: json["pet"] == null ? [] : List<PetListModel>.from(json["pet"]!.map((x) => PetListModel.fromJson(x))),
    community: json["community"] == null ? [] : List<BlogListModel>.from(json["community"]!.map((x) => BlogListModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "seller": seller?.toJson(),
    "crop": crop == null ? [] : List<dynamic>.from(crop!.map((x) => x.toJson())),
    "cattle": cattle == null ? [] : List<dynamic>.from(cattle!.map((x) => x.toJson())),
    "pet": pet == null ? [] : List<dynamic>.from(pet!.map((x) => x.toJson())),
    "community": community == null ? [] : List<dynamic>.from(community!.map((x) => x.toJson())),
  };
}


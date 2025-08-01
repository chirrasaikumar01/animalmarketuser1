import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/buy_crop/models/crop_argument.dart';
import 'package:animal_market/modules/buy_crop/models/crop_details_model.dart';
import 'package:animal_market/modules/buy_crop/models/crop_image.dart';
import 'package:animal_market/modules/buy_crop/models/crop_list_model.dart';
import 'package:animal_market/modules/category/models/banners_model.dart';
import 'package:animal_market/modules/category/models/category_list_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/sell_crop/models/crop_type_model.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_controller.dart';

class MarketProvider extends ChangeNotifier {
  CarouselSliderController carouselSliderController = CarouselSliderController();
  int selectedIndex = 0;
  bool isLoading = true;
  bool isLoading2 = true;
  bool isLoading3 = true;
  bool noData1 = false;
  var bannerList = <BannersModel>[];
  var cattleList = <CategoryListModel>[];
  var selectedCattle = <CategoryListModel>[];
  var cropList = <CropListModel>[];
  var filteredList = <CropListModel>[];
  CropDetailModel? cropDetailModel;
  TextEditingController cropNameController = TextEditingController();
  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();
  String latitude = '';
  String longitude = '';
  String city = '';
  String state = '';
  String pinCode = '';
  var subCategoryList = <SubCategoryListModel>[];
  SubCategoryListModel? subCategoryModel;
  String subCategoryId = "";
  var cropTypeList = <CropTypeModel>[];
  var cropImages = <CropImage>[];
  CropTypeModel? cropTypeModel;
  String cropTypeId = "";
  String audioFile = "";

  void resetFilter() {
    minPrice.text = '';
    maxPrice.text = '';
    latitude = '';
    longitude = '';
    city = '';
    state = '';
    pinCode = '';
    subCategoryId="";
  }

  void updateIndexBanner(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void updateSubCategory(BuildContext context, SubCategoryListModel model) {
    subCategoryModel = model;
    subCategoryId = subCategoryModel!.id.toString();
    cropName(context, subCategoryId);
    notifyListeners();
  }

  void updateCropType(BuildContext context, CropTypeModel model) {
    cropTypeModel = model;
    cropTypeId = cropTypeModel!.id.toString();
    notifyListeners();
  }

  Future<void> subCategory(BuildContext context, String categoryId) async {
    try {
      subCategoryList.clear();
      subCategoryModel = null;
      cropTypeModel = null;
      var result = await ApiService.subCategory(categoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          subCategoryList = List<SubCategoryListModel>.from(json['data'].map((i) => SubCategoryListModel.fromJson(i))).toList(growable: true);
        }
      } else {
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> cropName(BuildContext context, String categoryId) async {
    try {
      cropTypeList.clear();
      cropTypeModel = null;
      var result = await ApiService.cropName(categoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          cropTypeList = List<CropTypeModel>.from(json['data'].map((i) => CropTypeModel.fromJson(i))).toList(growable: true);
        }
      } else {
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      Log.console(e.toString());
    }
    notifyListeners();
  }

  void locationUpdate(BuildContext context, LocationModel result,String categoryId) {
    state = result.stateName;
    city = result.cityName;
    pinCode = result.pinCode;
    latitude = result.lat;
    longitude = result.long;
    cropListGet(context, false,true);
    Navigator.pushNamed(context, Routes.marketCrop, arguments: CropArgument(id: "", isUser: false, categoryId:categoryId));
    notifyListeners();
  }

  Future<void> cropListGet(BuildContext context, bool isFilter,bool isLoad) async {
    try {
      if (isFilter) {
        showProgress(context);
      } else {
        isLoading2 = isLoad;
      }
      var result = await ApiService.cropList(
        subCategoryId,
        minPrice.text,
        maxPrice.text,
        latitude,
        longitude,
        city,
        state,
        pinCode,
      );
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          if (isFilter) {
            closeProgress(context);
            Navigator.pop(context);
            notifyListeners();
          } else {
            isLoading2 = false;
            notifyListeners();
          }
          cropList = List<CropListModel>.from(json['data'].map((i) => CropListModel.fromJson(i))).toList(growable: true);
          filteredList = cropList;
        }
      } else {
        if (context.mounted) {
          if (isFilter) {
            closeProgress(context);
          } else {
            isLoading2 = false;
          }
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        if (isFilter) {
          closeProgress(context);
        } else {
          isLoading2 = false;
        }
      }
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> cropDetail(BuildContext context, String cropId) async {
    try {
      isLoading3 = true;
      audioFile = '';
      cropImages.clear();
      var result = await ApiService.cropDetail(cropId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        noData1 = false;
        isLoading3 = false;
        if (context.mounted) {
          cropDetailModel = CropDetailModel.fromJson(json["data"]);
          if (cropDetailModel != null && cropDetailModel!.cropImages != null && cropDetailModel!.cropImages!.isNotEmpty) {
            for (int i = 0; i < cropDetailModel!.cropImages!.length; i++) {
              if (cropDetailModel!.cropImages![i].type == "audio") {
                audioFile = cropDetailModel!.cropImages![i].image.toString();
              } else {
                cropImages.add(cropDetailModel!.cropImages![i]);
              }
            }
          } else {
            audioFile = '';
          }
        }
      } else {
        if (context.mounted) {
          isLoading3 = false;
          noData1 = true;
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading3 = false;
      noData1 = true;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredList = cropList;
    } else {
      List<CropListModel> tempList = [];
      for (var item in cropList) {
        if (item.title!.toLowerCase().toString().contains(query.toLowerCase()) || item.title!.toLowerCase().toString().contains(query.toLowerCase())) {
          tempList.add(item);
        }
      }
      filteredList = tempList;
    }
    notifyListeners();
  }
  Future<void> addRemoveFavourite(BuildContext context, String catId, String listingId) async {
    try {
      showProgress(context);
      var result = await ApiService.addRemoveFavourite(catId, listingId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          cropListGet(context, false,false);
        }
      } else {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
    }
    notifyListeners();
  }
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Future<void> initAudioServices() async {
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerComplete.listen((event) {
      isPlaying = false;
      notifyListeners();
    });
  }
  void updateAudioFile(String file) {
    audioFile = file;
    notifyListeners();
  }

  Future<void> playAudio() async {
    if (audioFile.isEmpty) return;
    try {
      await audioPlayer.play(UrlSource(ApiUrl.imageUrl+audioFile));
      isPlaying = true;
      notifyListeners();
    } catch (e) {
      Log.console("Error playing audio: $e");
    }
  }
  Future<void> stopAudio() async {
    try {
      await audioPlayer.stop();
      isPlaying = false;
      notifyListeners();
    } catch (e) {
      Log.console("Error stopping audio: $e");
    }
  }
  void resetPlayer() {
    audioPlayer.dispose();
  }
}

import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/buy_pet/models/pet_argument.dart';
import 'package:animal_market/modules/buy_pet/models/pet_image.dart';
import 'package:animal_market/modules/buy_pet/models/pet_list_model.dart';
import 'package:animal_market/modules/category/models/banners_model.dart';
import 'package:animal_market/modules/category/models/category_list_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/sell_pet/models/pet_details_model.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_controller.dart';

class MarketPetProvider extends ChangeNotifier {
  CarouselSliderController carouselSliderController = CarouselSliderController();
  int selectedIndex = 0;
  bool isLoading = true;
  bool isLoading2 = true;
  bool isLoading3 = true;
  bool noData1 = false;
  var bannerList = <BannersModel>[];
  var cattleList = <CategoryListModel>[];
  var selectedCattle = <CategoryListModel>[];
  var petList = <PetListModel>[];
  var petImages = <PetImage>[];
  var filteredList = <PetListModel>[];
  PatDetailsModel? petDetailModel;
  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();
  String latitude = '';
  String longitude = '';
  String city = '';
  String state = '';
  String pinCode = '';
  String subCategoryId = '';
  String audioFile = '';
  var subCategoryList = <SubCategoryListModel>[];
  SubCategoryListModel? subCategoryModel;

  void resetFilter() {
    minPrice.text = '';
    maxPrice.text = '';
    latitude = '';
    longitude = '';
    city = '';
    state = '';
    pinCode = '';
  }

  void updateSubCategory(BuildContext context, SubCategoryListModel model) {
    subCategoryModel = model;
    subCategoryId = subCategoryModel!.id.toString();
    notifyListeners();
  }

  Future<void> subCategory(BuildContext context, String categoryId) async {
    try {
      subCategoryList.clear();
      subCategoryModel = null;
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

  void locationUpdate(BuildContext context, LocationModel result, String categoryId) {
    state = result.stateName;
    city = result.cityName;
    pinCode = result.pinCode;
    latitude = result.lat;
    longitude = result.long;
    petListGet(context,false,true);
    Navigator.pushNamed(context, Routes.petMarket, arguments: PetArgument(id: "", isUser: false, categoryId: categoryId));
    notifyListeners();
  }

  void updateIndexBanner(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> petListGet(BuildContext context, bool isFilter,isLoad) async {
    try {
      if (isFilter) {
        showProgress(context);
      } else {
        isLoading2 = isLoad;
      }
      var result = await ApiService.petList(
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
          } else {
            isLoading2 = false;
          }
          petList = List<PetListModel>.from(json['data'].map((i) => PetListModel.fromJson(i))).toList(growable: true);
          filteredList = petList;
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

  Future<void> petDetail(BuildContext context, String petId) async {
    try {
      isLoading3 = true;
      audioFile="";
      petImages.clear();
      var result = await ApiService.petDetail(petId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        noData1 = false;
        isLoading3 = false;
        if (context.mounted) {
          petDetailModel = PatDetailsModel.fromJson(json["data"]);
          if (petDetailModel != null && petDetailModel!.petImages != null && petDetailModel!.petImages!.isNotEmpty) {
            for (int i = 0; i < petDetailModel!.petImages!.length; i++) {
              if (petDetailModel!.petImages![i].type == "audio") {
                audioFile = petDetailModel!.petImages![i].path.toString();
              } else {
                petImages.add(petDetailModel!.petImages![i]);
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
      filteredList = petList;
    } else {
      List<PetListModel> tempList = [];
      for (var item in petList) {
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
          petListGet(context,false,false);
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
  void updateAudioFile(String filePath) {
    audioFile = filePath;
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

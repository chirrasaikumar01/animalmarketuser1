import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/buy/models/cattle_argument.dart';
import 'package:animal_market/modules/buy/models/cattle_details_model.dart';
import 'package:animal_market/modules/buy/models/cattle_image.dart';
import 'package:animal_market/modules/buy/models/cattle_list_model.dart';
import 'package:animal_market/modules/buy/models/cattle_near_you_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/sell/models/breed_list_model.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_controller.dart';

class BuyProvider extends ChangeNotifier {
  bool isLoading = true;
  bool isLoading1 = true;
  bool isLoading2 = true;
  bool isLoading3 = true;
  var buyCattleList = <SubCategoryListModel>[];
  var cattleNearYou = <CattleNearYouModel>[];
  var subCategoryList = <SubCategoryListModel>[];
  var cattleList = <CattleListModel>[];
  var filteredList = <CattleListModel>[];
  TextEditingController searchController = TextEditingController();
  bool noData = false;
  bool noData1 = false;
  CarouselSliderController carouselSliderController = CarouselSliderController();
  int selectedIndex = 0;
  CattleDetailsModel? cattleDetailsModel;
  TextEditingController minMilkCapacity = TextEditingController();
  TextEditingController maxMilkCapacity = TextEditingController();
  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();
  String latitude = '';
  String longitude = '';
  String city = '';
  String state = '';
  String pinCode = '';
  String subCategoryId = '';
  String categoryId = '';
  String breedId = '';
  String audioFile = '';
  SubCategoryListModel? subCategoryModel;
  BreedListModel? breedListModel;
  var breedList = <BreedListModel>[];
  var cattleImage = <CattleImage>[];

  void resetFilter() {
    minMilkCapacity.text = '';
    maxMilkCapacity.text = '';
    minPrice.text = '';
    maxPrice.text = '';
    latitude = '';
    longitude = '';
    city = '';
    state = '';
    pinCode = '';
    breedId = "";
  }

  void updateIndexBanner(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredList = cattleList;
    } else {
      List<CattleListModel> tempList = [];
      for (var item in cattleList) {
        if (item.title!.toLowerCase().toString().contains(query.toLowerCase()) || item.title!.toLowerCase().toString().contains(query.toLowerCase())) {
          tempList.add(item);
        }
      }
      filteredList = tempList;
    }
    notifyListeners();
  }

  Future<void> buyCattleHome(BuildContext context, String category) async {
    try {
      categoryId = category;
      isLoading = true;
      var result = await ApiService.buyCropCattleHome(categoryId, "cattle");
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        if (context.mounted) {
          if (json["data"] != null) {
            noData = false;
            buyCattleList =
                json["data"]["sub_category"] == null ? [] : List<SubCategoryListModel>.from(json['data']["sub_category"].map((i) => SubCategoryListModel.fromJson(i))).toList(growable: true);
            cattleNearYou = json["data"]["near_you"] == null ? [] : List<CattleNearYouModel>.from(json['data']["near_you"].map((i) => CattleNearYouModel.fromJson(i))).toList(growable: true);
          } else {
            noData = true;
          }
        }
      } else {
        if (context.mounted) {
          noData = true;
          isLoading = false;
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      noData = true;
      isLoading = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> subCategory(BuildContext context, String category) async {
    try {
      categoryId = categoryId;
      isLoading1 = true;
      subCategoryModel = null;
      breedListModel = null;
      var result = await ApiService.subCategory(categoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading1 = false;
        if (context.mounted) {
          subCategoryList = List<SubCategoryListModel>.from(json['data'].map((i) => SubCategoryListModel.fromJson(i))).toList(growable: true);
        }
      } else {
        if (context.mounted) {
          isLoading1 = false;
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading1 = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  void locationUpdate(BuildContext context, LocationModel result) {
    state = result.stateName;
    city = result.cityName;
    pinCode = result.pinCode;
    latitude = result.lat;
    longitude = result.long;
    cattleListGet(context, false, true);
    Navigator.pushNamed(context, Routes.market, arguments: CattleArgument(id: "", isUser: false, categoryId: categoryId));
    notifyListeners();
  }

  void updateSubCategory(BuildContext context, SubCategoryListModel model) {
    subCategoryModel = model;
    subCategoryId = subCategoryModel!.id.toString();
    breed(context, subCategoryId);
    notifyListeners();
  }

  void updateBreed(BuildContext context, BreedListModel model) {
    breedListModel = model;
    breedId = breedListModel!.id.toString();
    notifyListeners();
  }

  Future<void> breed(BuildContext context, String subCategoryId) async {
    try {
      breedList.clear();
      breedListModel = null;
      var result = await ApiService.breed(categoryId, subCategoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          breedList = List<BreedListModel>.from(json['data'].map((i) => BreedListModel.fromJson(i))).toList(growable: true);
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

  Future<void> cattleListGet(
    BuildContext context,
    bool isFilter,
    bool isLoad,
  ) async {
    try {
      if (isFilter) {
        showProgress(context);
      } else {
        isLoading2 = isLoad;
      }

      var result = await ApiService.cattleList(
        subCategoryId,
        breedId,
        minMilkCapacity.text,
        maxMilkCapacity.text,
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
          cattleList = List<CattleListModel>.from(json['data'].map((i) => CattleListModel.fromJson(i))).toList(growable: true);
          filteredList = cattleList;
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
        Log.console(e.toString());
      }
    }
    notifyListeners();
  }

  Future<void> cattleDetailGet(BuildContext context, String cattleId) async {
    try {
      isLoading3 = true;
      audioFile = '';
      cattleImage.clear();
      var result = await ApiService.cattleDetail(cattleId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        noData1 = false;
        isLoading3 = false;
        if (context.mounted) {
          cattleDetailsModel = CattleDetailsModel.fromJson(json["data"]);
          if (cattleDetailsModel != null && cattleDetailsModel!.cattleImages != null && cattleDetailsModel!.cattleImages!.isNotEmpty) {
            for (int i = 0; i < cattleDetailsModel!.cattleImages!.length; i++) {
              if (cattleDetailsModel!.cattleImages![i].type == "audio") {
                audioFile = cattleDetailsModel!.cattleImages![i].image.toString();
              } else {
                cattleImage.add(cattleDetailsModel!.cattleImages![i]);
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

  Future<void> addRemoveFavourite(BuildContext context, String catId, String listingId) async {
    try {
      showProgress(context);
      var result = await ApiService.addRemoveFavourite(catId, listingId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          cattleListGet(context, false, false);
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

  void updateAudioFile(String value) {
    audioFile = value;
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

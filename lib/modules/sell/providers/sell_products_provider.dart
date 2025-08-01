// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:animal_market/core/common_widgets/media_source_picker.dart';
import 'package:animal_market/core/constants.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/image_picker_utils.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/account/models/city_list_model.dart';
import 'package:animal_market/modules/account/models/state_list_model.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/buy/models/cattle_details_model.dart';
import 'package:animal_market/modules/buy/models/seller_model.dart';
import 'package:animal_market/modules/category/models/banners_model.dart';
import 'package:animal_market/modules/category/models/feature_list_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/sell/models/breed_list_model.dart';
import 'package:animal_market/modules/sell/models/pregnancy_history_list_model.dart';
import 'package:animal_market/modules/sell/models/success_argument.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class SellProductsProvider extends ChangeNotifier {
  bool isLoading = true;
  bool isLoading1 = true;
  bool noData = false;
  bool noData1 = false;
  String categoryId = "";
  String image = "";
  String image1 = "";
  String image2 = "";
  String image3 = "";

  String selectedLocation = "Select a location";

  var videoFile = "";
  bool isVideo = false;
  VideoPlayerController? videoPlayerController;
  File? file;
  final picker = ImagePicker();
  CattleDetailsModel? cattleDetailsModel;
  var images = [];
  var audios = [];
  var videos = [];
  var bannerList = <BannersModel>[];
  Seller? seller;
  int selectedIndex = 0;
  String totalListed = "0";
  String totalCallsReceived = "0";
  String totalViewsReceived = "0";
  var cattleList = <CattleDetailsModel>[];
  CarouselSliderController carouselSliderController = CarouselSliderController();
  var subCategoryList = <SubCategoryListModel>[];
  SubCategoryListModel? subCategoryModel;
  String subCategoryId = "";
  var breedList = <BreedListModel>[];
  String breedId = "";
  var heathStatusList = <BreedListModel>[];
  var pregnancyHistoryList = <PregnancyHistoryListModel>[];
  PregnancyHistoryListModel? pregnancyHistoryListModel;
  String pregnancyHistoryId = "";
  String pregnancyHistoryTittle = "";
  var featureList = <FeatureListModel>[];
  BreedListModel? breedListModel;

  BreedListModel? healthStatusModel;
  String healthStatusId = "";
  String addressLocation = "";
  Position? currentPosition;
  var long = 00.00;
  var lat = 00.00;
  String? selectedSellerType;
  TextEditingController isNegotiableController = TextEditingController();
  TextEditingController isVaccinatedController = TextEditingController();
  TextEditingController isBabyDeliveredController = TextEditingController();
  TextEditingController isPregnantController = TextEditingController();
  TextEditingController isCalfController = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController milkCapacity = TextEditingController();
  TextEditingController calfCount = TextEditingController();
  TextEditingController breedName = TextEditingController();
  String isNegotiable = "0";
  String isVaccinated = "";
  String isMilk = "0";
  String isBabyDelivered = "";
  String isPregnant = "";
  String isCalf = "";
  var stateList = <StateListModel>[];
  var cityList = <CityListModel>[];
  var stateModel;
  var cityModel;
  String stateId = "";
  String cityId = "";
  String stateName = "";
  String cityName = "";
  String area = "";
  String? isMilkController;
  String? gender;
  String statusType = "";

  String isHarvested = "";
  bool isShow = false;
  bool isCompress = false;
  late FlutterSoundRecorder recorder;
  late AudioPlayer audioPlayer;

  bool isRecording = false;
  bool isPlaying = false;
  bool showPlayer = false;
  String recordedFilePath = "";

  Future<void> initAudioServices() async {
    recorder = FlutterSoundRecorder();
    audioPlayer = AudioPlayer();
    await recorder.openRecorder();
    audioPlayer.onPlayerComplete.listen((event) {
      isPlaying = false;
      notifyListeners();
    });
    bool permissionGranted = await _requestPermissions();
    if (!permissionGranted) {
      Log.console("Permissions not granted!");
    }
    notifyListeners();
  }

  Future<bool> _requestPermissions() async {
    final micStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();

    return micStatus.isGranted && storageStatus.isGranted;
  }

  Future<void> startRecording() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      recordedFilePath = "${dir.path}/voice.m4a";
      await recorder.startRecorder(
        toFile: recordedFilePath,
        codec: Codec.aacMP4,
      );
      isRecording = true;
      showPlayer = false;
      notifyListeners();
    } catch (e) {
      Log.console("Error starting recording: $e");
    }
    notifyListeners();
  }

  Future<void> stopRecording() async {
    try {
      await recorder.stopRecorder();
      isRecording = false;
      showPlayer = true;
      notifyListeners();
    } catch (e) {
      Log.console("Error stopping recording: $e");
    }
  }

  Future<void> playAudio() async {
    if (recordedFilePath.isEmpty) return;
    try {
      await audioPlayer.play(DeviceFileSource(recordedFilePath));
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

  void reset() {
    recordedFilePath = "";
    isPlaying = false;
    showPlayer = false;
    notifyListeners();
  }

  void resetPlayer() {
    recorder.closeRecorder();
    audioPlayer.dispose();
  }

  void isFull(bool v) {
    isShow = v;
    notifyListeners();
  }

  void updateLocation(String newLocation) {
    selectedLocation = newLocation;
    notifyListeners();
  }

  void playAndPause(bool isPlay) {
    if (isPlay) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
    notifyListeners();
  }

  void stateUpdate(BuildContext context, StateListModel model) {
    stateModel = model;
    stateId = stateModel.id.toString();
    cityListGet(context, stateModel.id.toString());
    notifyListeners();
  }

  void cityUpdate(CityListModel model) {
    cityModel = model;
    cityId = cityModel.id.toString();
    notifyListeners();
  }

  void updateGender(String v) {
    gender = v;
    notifyListeners();
  }

  void updateSellerType(String type) {
    selectedSellerType = type;
    notifyListeners();
  }

  void updateIsNegotiable(String v) {
    if (v == "yes") {
      isNegotiable = "1";
    } else {
      isNegotiable = "0";
    }
    notifyListeners();
  }

  void updateIsMilk(String v) {
    isMilkController = v;
    if (v == "yes") {
      isMilk = "1";
    } else {
      isMilk = "0";
    }
    notifyListeners();
  }

  void updateIsBabyDelivered(String value) {
    isBabyDelivered = value;
    notifyListeners();
  }

  void updateIsPregnant(String value) {
    isPregnant = value;
    notifyListeners();
  }

  void updateIsCalf(String value) {
    isCalf = value;
    notifyListeners();
  }

  void updateIsVaccinated(String value) {
    isVaccinated = value;
    notifyListeners();
  }

  void updateIndexBanner(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void isVideoUpdate(bool v) {
    isVideo = v;
    notifyListeners();
  }

  void locationUpdate(LocationModel result) {
    stateName = result.stateName;
    cityName = result.cityName;
    pinCode.text = result.pinCode;
    addressLocation = result.addressLocation;
    lat = double.parse(result.lat);
    long = double.parse(result.long);
    notifyListeners();
  }

  Future<void> stateListGet(BuildContext context) async {
    try {
      stateModel = null;
      stateList.clear();
      var result = await ApiService.stateList();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        stateList = List<StateListModel>.from(json['data'].map((i) => StateListModel.fromJson(i))).toList(growable: true);
        for (int i = 0; i < stateList.length; i++) {
          if (stateList[i].id.toString() == stateId) {
            stateModel = stateList[i];
            if (context.mounted) {
              cityListGet(context, stateId);
            }
          }
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

  Future<void> cityListGet(BuildContext context, String stateId) async {
    try {
      cityModel = null;
      cityList.clear();
      var result = await ApiService.cityList(stateId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        cityList = List<CityListModel>.from(json['data'].map((i) => CityListModel.fromJson(i))).toList(growable: true);
        for (int i = 0; i < cityList.length; i++) {
          if (cityList[i].id.toString() == cityId) {
            cityModel = cityList[i];
          }
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

  void updateSubCategory(BuildContext context, SubCategoryListModel model) {
    subCategoryModel = model;
    subCategoryId = subCategoryModel!.id.toString();
    if (subCategoryModel?.slug?.trim().toLowerCase() == "cow" || subCategoryModel?.slug?.trim().toLowerCase() == "Buffalo") {
      gender = "female";
    }
    if (subCategoryModel?.slug?.trim().toLowerCase() == "male-buffalo" ||
        subCategoryModel!.slug!.trim().toLowerCase().contains("ox") ||
        subCategoryModel!.slug!.trim().toLowerCase().contains("bull")) {
      gender = "male";
      pregnancyHistoryId = "";
      pregnancyHistoryTittle = "";
      isMilk = "0";
      milkCapacity.text = "";
      isBabyDelivered = "";
      isPregnant = "";
      isCalf = "";
      calfCount.text = "";
    }
    breed(context, subCategoryId);
    featuresListGet(context, subCategoryId);
    heathStatusListGet(context);
    notifyListeners();
  }

  void updateBreed(BuildContext context, BreedListModel model) {
    breedListModel = model;
    breedId = breedListModel!.id.toString();
    notifyListeners();
  }

  void updatePregnancyHistory(BuildContext context, PregnancyHistoryListModel model) {
    pregnancyHistoryListModel = model;
    pregnancyHistoryId = pregnancyHistoryListModel!.id.toString();
    notifyListeners();
  }

  void updateHealthStatus(BuildContext context, BreedListModel model) {
    healthStatusModel = model;
    healthStatusId = healthStatusModel!.id.toString();
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
          for (int i = 0; i < subCategoryList.length; i++) {
            if (subCategoryList[i].id.toString() == subCategoryId) {
              subCategoryModel = subCategoryList[i];
              breed(context, subCategoryId);
              featuresListGet(context, subCategoryId);
              heathStatusListGet(context);
            }
          }
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

  Future<void> featuresListGet(BuildContext context, String subCategoryId) async {
    try {
      featureList.clear();
      var result = await ApiService.featuresList(subCategoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          featureList = List<FeatureListModel>.from(json['data'].map((i) => FeatureListModel.fromJson(i))).toList(growable: true);
          for (int i = 0; i < featureList.length; i++) {}
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

  Future<void> breed(BuildContext context, String subCategoryId) async {
    try {
      breedList.clear();
      breedListModel = null;
      var result = await ApiService.breed(categoryId, subCategoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          breedList = List<BreedListModel>.from(json['data'].map((i) => BreedListModel.fromJson(i))).toList(growable: true);
          for (int i = 0; i < breedList.length; i++) {
            if (breedList[i].id.toString() == breedId) {
              breedListModel = breedList[i];
            }
          }
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

  Future<void> heathStatusListGet(BuildContext context) async {
    try {
      heathStatusList.clear();
      healthStatusModel = null;
      var result = await ApiService.heathStatusList();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          heathStatusList = List<BreedListModel>.from(json['data'].map((i) => BreedListModel.fromJson(i))).toList(growable: true);
          for (int i = 0; i < heathStatusList.length; i++) {
            if (heathStatusList[i].id.toString() == healthStatusId) {
              healthStatusModel = heathStatusList[i];
            }
          }
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

  Future<void> pregnancyHistory(BuildContext context) async {
    try {
      pregnancyHistoryList.clear();
      pregnancyHistoryListModel = null;
      var result = await ApiService.pregnancyHistory();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          pregnancyHistoryList = List<PregnancyHistoryListModel>.from(json['data'].map((i) => PregnancyHistoryListModel.fromJson(i))).toList(growable: true);
          for (int i = 0; i < pregnancyHistoryList.length; i++) {
            if (pregnancyHistoryList[i].title!.toLowerCase().toString() == pregnancyHistoryTittle.toLowerCase()) {
              pregnancyHistoryListModel = pregnancyHistoryList[i];
              pregnancyHistoryId = pregnancyHistoryListModel!.id.toString();
            }
          }
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

  void removeImage(String type) {
    switch (type) {
      case 'image':
        image = "";
        break;
      case 'image1':
        image1 = "";
        break;
      case 'image2':
        image2 = "";
        break;
      case 'image3':
        image3 = "";
        break;
      case 'video':
        videoFile = "";
        break;
    }
    notifyListeners();
  }

  void onUploadImage(BuildContext context, String imageType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstant.white,
      builder: (_) {
        return const MediaSourcePicker();
      },
    ).then(
      (value) async {
        if (value != null && value is ImageSource) {
          if (context.mounted) {
            File? pickedFile = await PickImageUtility.instance(
              applyEditor: false,
              context: context,
              toolbarBackgroundColor: ColorConstant.appCl,
            ).pickedFile(value);
            if (pickedFile != null) {
              var compressedFile = await compressImage(pickedFile);
              if (imageType == "image") {
                image = compressedFile!.path;
              }
              if (imageType == "image1") {
                image1 = compressedFile!.path;
              }
              if (imageType == "image2") {
                image2 = compressedFile!.path;
              }
              notifyListeners();
            }
          }
        }
      },
    );
  }

  Future<void> pickMedia({required BuildContext context, required bool isVideo}) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Container(
          height: 150.h,
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                leading: SizedBox(
                  width: 150.w,
                  height: 70.h,
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: ColorConstant.appCl,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Camera',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorConstant.appCl,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                leading: SizedBox(
                  width: 150.w,
                  height: 70.h,
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: ColorConstant.appCl,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Gallery',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorConstant.appCl,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    final pickedFile = isVideo ? await picker.pickVideo(source: source) : await picker.pickImage(source: source);

    if (pickedFile != null) {
      file = File(pickedFile.path);

      if (isVideo) {
        final mediaInfo = await compressVideo(file!.path);
        if (mediaInfo != null) {
          videoFile = mediaInfo.path ?? "";
          videoPlayerController = VideoPlayerController.file(file!)
            ..initialize().then((_) {
              notifyListeners();
            });
        }
      } else {
        images.add(file!.path);
      }

      notifyListeners();
    } else {
      Log.console("No file selected");
    }
  }

  Future<MediaInfo?> compressVideo(String path) async {
    isCompress = true;
    notifyListeners();
    final info = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    Log.console("VideoCompress => ${info?.path}");
    isCompress = false;
    notifyListeners();
    return info;
  }

  Future<XFile?> compressImage(File file) async {
    Log.console(file.path);

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.path,
      '${file.path}_compressed.jpg',
      quality: 70,
    );
    Log.console("compressedFile => ${compressedFile?.path}");

    return compressedFile;
  }

  Future<void> sellerHome(bool isLoad) async {
    try {
      isLoading = isLoad;
      var result = await ApiService.sellerHome("cattle");
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        noData = false;
        isLoading = false;
        bannerList = json['data']['banners'] == null ? [] : List<BannersModel>.from(json['data']['banners'].map((i) => BannersModel.fromJson(i))).toList(growable: true);
        seller = json['data']['seller'] == null ? null : Seller.fromJson(json['data']['seller']);
        totalListed = json['data']['total_listed'] == null ? "0" : json['data']['total_listed'].toString();
        totalCallsReceived = json['data']['total_calls_received'] == null ? "0" : json['data']['total_calls_received'].toString();
        totalViewsReceived = json['data']['total_views_received'] == null ? "0" : json['data']['total_views_received'].toString();
      } else {
        isLoading = false;
        noData = true;
        Log.console(json["message"].toString());
      }
    } catch (e) {
      isLoading = false;
      noData = true;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> sellerDashboard(String status, bool isLoad) async {
    try {
      isLoading1 = isLoad;
      statusType = status;
      var result = await ApiService.sellerDashboard("cattle", status);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        noData1 = false;
        isLoading1 = false;
        cattleList = json['data']['listing'] == null ? [] : List<CattleDetailsModel>.from(json['data']['listing'].map((i) => CattleDetailsModel.fromJson(i))).toList(growable: true);
        totalListed = json['data']['total_listed'] == null ? "0" : json['data']['total_listed'].toString();
        totalCallsReceived = json['data']['total_calls_received'] == null ? "0" : json['data']['total_calls_received'].toString();
        totalViewsReceived = json['data']['total_views_received'] == null ? "0" : json['data']['total_views_received'].toString();
      } else {
        isLoading1 = false;
        noData1 = true;
        Log.console(json["message"].toString());
      }
    } catch (e) {
      isLoading1 = false;
      noData1 = true;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  String generateTitle({
    required String? category,
    required String? breed,
    required String? gender,
    required String? milkCapacity,
    required String? price,
    required String? buySlug, // Add this
  }) {
    List<String> titleParts = [];

    if (category != null && category.isNotEmpty) {
      titleParts.add(category);
    }

    if (breed != null && breed.isNotEmpty) {
      titleParts.add(breed);
    }

    if (gender != null && gender.isNotEmpty) {
      titleParts.add(gender);
    }

    if (gender?.toLowerCase() == "female" && milkCapacity != null && milkCapacity.isNotEmpty) {
      titleParts.add("$milkCapacity Litres Milk Capacity");
    }

    if (price != null && price.isNotEmpty) {
      String priceSuffix = "";

      if (buySlug != null) {
        if (["hen", "goat", "sheep", "pig"].contains(buySlug.toLowerCase())) {
          priceSuffix = " per kg/unit";
        }
      }

      titleParts.add("Rs $price$priceSuffix");
    }

    return titleParts.join(" | ");
  }

  Future<void> createEditCattle(BuildContext context, String cattleId, bool isEdit) async {
    title.text = generateTitle(
      category: '${subCategoryModel?.title}',
      breed: breedListModel!.title!.toLowerCase() == "other" ? breedName.text : '${breedListModel?.title}',
      gender: gender != null
          ? gender!.toLowerCase() == "male"
              ? "Male"
              : gender!.toLowerCase() == "female"
                  ? "Female"
                  : gender!.toLowerCase() == "other"
                      ? "Other"
                      : ""
          : "",
      milkCapacity: milkCapacity.text,
      price: price.text,
      buySlug: subCategoryModel?.slug, // Make sure this is available
    );
    images.clear();
    videos.clear();
    audios.clear();
    if (recordedFilePath.isNotEmpty) {
      audios.add(recordedFilePath);
    }
    if (videoFile.isNotEmpty) {
      videos.add(videoFile);
    }
    if (image.isNotEmpty) {
      images.add(image);
    }
    if (image1.isNotEmpty) {
      images.add(image1);
    }
    if (image2.isNotEmpty) {
      images.add(image2);
    }
    if (image3.isNotEmpty) {
      images.add(image3);
    }
    if (images.isEmpty) {
      errorToast(context, "Please select images");
      return;
    }

    try {
      showProgress(context);
      var result = await ApiService.createEditCattle(
        cattleId,
        title.text,
        description.text,
        breedName.text,
        categoryId,
        subCategoryId,
        stateName,
        cityName,
        pinCode.text,
        addressLocation,
        lat.toString(),
        long.toString(),
        breedId,
        isNegotiable,
        price.text,
        gender != null ? gender!.toLowerCase() : "",
        isMilk,
        milkCapacity.text,
        isBabyDelivered,
        isPregnant,
        isCalf,
        calfCount.text,
        isVaccinated,
        healthStatusId,
        selectedSellerType ?? "",
        age.text,
        pregnancyHistoryId,
        images,
        videos,
        audios,
      );
      if (result["status"] == true) {
        if (context.mounted) {
          sellerHome(false);
          sellerDashboard(statusType, false);
          closeProgress(context);
          resetData();
          if (isEdit) {
            Navigator.pop(context);
            successToast(context, result["message"]);
          } else {
            Navigator.pushReplacementNamed(context, Routes.successfullyCreated,
                arguments: SuccessArgument(
                  title: result["data"]["title"] ?? "",
                  price: result["data"]["price"] ?? "",
                  image: result["data"]["image"] ?? "",
                  subCategoryId: result["data"]["sub_category_id"].toString(),
                  id: result["data"]["id"].toString(),
                ));
          }
        }
      } else {
        if (context.mounted) {
          errorToast(context, result["message"]);
          closeProgress(context);
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

  Future<void> getLocationStatus() async {
    try {
      await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showLocationDialog();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        showLocationDialog();
        return;
      }
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      final position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      if (position.latitude != 0.0 && position.longitude != 0.0) {
        await getCurrentPosition();
      } else {
        Log.console('Unable to get location. Make sure GPS is enabled.');
      }
    } catch (e) {
      Log.console("getLocationStatus error: ${e.toString()}");
    }
  }

  void showLocationDialog() {
    var context = Constants.navigatorKey.currentContext!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const TText(keyName: "Location Access Required"),
        content: const TText(
          keyName: "We need your location to continue. Please enable location permissions in settings.",
        ),
        actions: [
          TextButton(
            child: const TText(keyName: "Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const TText(keyName: "Open Settings"),
            onPressed: () {
              Geolocator.openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // Get the current position of the user
  Future<void> getCurrentPosition() async {
    try {
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      await Geolocator.getCurrentPosition(locationSettings: locationSettings).then((Position position) async {
        currentPosition = position;
        long = currentPosition?.longitude ?? 00.00;
        lat = currentPosition?.latitude ?? 00.00;
        List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);
        Placemark place = placeMarks.first;
        cityName = "${place.locality}";
        area = "${place.subLocality}";
        stateName = "${place.administrativeArea}";
        pinCode.text = "${place.postalCode}";
        addressLocation = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}";
        Log.console("Latitude: $lat, Longitude: $long");
        Log.console("Address: $addressLocation");
        var context = Constants.navigatorKey.currentContext!;
        if (context.mounted) {
          Provider.of<AccountProvider>(context, listen: false).state.text = stateName;
          Provider.of<AccountProvider>(context, listen: false).city.text = cityName;
          Provider.of<AccountProvider>(context, listen: false).pinCode.text = pinCode.text;
          Provider.of<AccountProvider>(context, listen: false).latitude.text = lat.toString();
          Provider.of<AccountProvider>(context, listen: false).longitude.text = long.toString();
          Provider.of<AccountProvider>(context, listen: false).address.text = addressLocation;
          Provider.of<AccountProvider>(context, listen: false).updateProfile(context, false, false, true);
        }
        notifyListeners();
      }).catchError((e) {
        Log.console("$e");
      });
    } catch (e) {
      Log.console(e.toString());
    }
  }

  void resetData() {
    image = "";
    image1 = "";
    image2 = "";
    image3 = "";
    videoFile = "";
    images.clear();
    audios.clear();
    videos.clear();
    bannerList.clear();
    selectedIndex = 0;
    totalListed = "0";
    totalCallsReceived = "0";
    totalViewsReceived = "0";
    cattleList.clear();
    subCategoryList.clear();
    subCategoryModel = null;
    subCategoryId = "";
    breedList.clear();
    heathStatusList.clear();
    pregnancyHistoryList.clear();
    pregnancyHistoryListModel = null;
    pregnancyHistoryId = "";
    featureList.clear();
    breedListModel = null;
    breedId = "";
    healthStatusModel = null;
    healthStatusId = "";
    addressLocation = "";
    currentPosition = null;
    long = 00.00;
    lat = 00.00;
    selectedSellerType = null;
    isNegotiableController.text = "";
    isVaccinatedController.text = "";
    isMilkController = null;
    isBabyDeliveredController.text = "";
    isPregnantController.text = "";
    isCalfController.text = "";
    gender = null;
    title.text = "";
    description.text = "";
    price.text = "";
    age.text = "";
    address.text = "";
    pinCode.text = "";
    milkCapacity.text = "";
    calfCount.text = "";
    isNegotiable = "0";
    isVaccinated = "";
    isMilk = "0";
    isBabyDelivered = "";
    isPregnant = "";
    isCalf = "";
    stateList.clear();
    cityList.clear();
    stateModel = null;
    cityModel = null;
    stateId = "";
    cityId = "";
    stateName = "";
    cityName = "";
    isShow = false;
  }

  Future<void> deleteCattle(BuildContext context, String cattleId) async {
    try {
      showProgress(context);
      var result = await ApiService.deleteCattle(cattleId);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          sellerHome(false);
          sellerDashboard(statusType, false);
          closeProgress(context);
          Navigator.pop(context);
          successToast(context, json["message"]);
        } else {
          closeProgress(context);
          errorToast(context, json["message"]);
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

  Future<void> cattleMarkToSold(BuildContext context, String cattleId) async {
    try {
      showProgress(context);
      var result = await ApiService.cattleMarkToSold(cattleId);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          sellerHome(false);
          sellerDashboard(statusType, false);
          closeProgress(context);
          successToast(context, json["message"]);
        } else {
          closeProgress(context);
          errorToast(context, json["message"]);
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

  Future<void> cattleDetailGet(BuildContext context, String cattleId) async {
    try {
      var result = await ApiService.cattleDetail(cattleId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        cattleDetailsModel = CattleDetailsModel.fromJson(json["data"]);
        title.text = cattleDetailsModel?.title ?? "";
        description.text = cattleDetailsModel?.description ?? "";
        categoryId = cattleDetailsModel?.categoryId ?? "";
        subCategoryId = cattleDetailsModel?.subCategoryId ?? "";
        stateName = cattleDetailsModel?.state ?? "";
        cityName = cattleDetailsModel?.city ?? "";
        pinCode.text = cattleDetailsModel?.pincode ?? "";
        addressLocation = cattleDetailsModel?.address ?? "";
        breedId = cattleDetailsModel?.breed ?? "";
        isNegotiable = cattleDetailsModel!.isNegotiable.toString();
        if (isNegotiable == "1") {
          isNegotiableController.text = "Yes".toLowerCase();
        } else {
          isNegotiableController.text = "No".toLowerCase();
        }
        price.text = cattleDetailsModel?.price ?? "";
        gender = cattleDetailsModel?.gender;
        isMilk = cattleDetailsModel!.isMilk.toString();
        if (isMilk == "1") {
          isMilkController = "Yes".toLowerCase();
        } else {
          isMilkController = "No".toLowerCase();
        }
        milkCapacity.text = cattleDetailsModel!.milkCapacity??"";
        isBabyDelivered = cattleDetailsModel!.isBabyDelivered??"";
        if (isBabyDelivered == "1") {
          isBabyDeliveredController.text = "Yes".toLowerCase();
        } else {
          isBabyDeliveredController.text = "No".toLowerCase();
        }
        isPregnant = cattleDetailsModel!.isPregnent??"";
        if (isPregnant == "1") {
          isPregnantController.text = "Yes".toLowerCase();
        } else {
          isPregnantController.text = "No".toLowerCase();
        }
        isCalf = cattleDetailsModel!.isCalf??"";
        if (isCalf == "1") {
          isCalfController.text = "Yes".toLowerCase();
        } else {
          isCalfController.text = "No".toLowerCase();
        }
        calfCount.text = cattleDetailsModel!.calfCount??"";
        isVaccinated = cattleDetailsModel!.isVaccinated??"";
        if (isVaccinated == "1") {
          isVaccinatedController.text = "Yes".toLowerCase();
        } else {
          isVaccinatedController.text = "No".toLowerCase();
        }
        healthStatusId = cattleDetailsModel!.healthStatus??"";
        selectedSellerType = cattleDetailsModel?.sellerType ?? "";
        age.text = cattleDetailsModel!.age??"";
        pregnancyHistoryTittle = cattleDetailsModel!.pregnencyHistoryTitle.toString();
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
}

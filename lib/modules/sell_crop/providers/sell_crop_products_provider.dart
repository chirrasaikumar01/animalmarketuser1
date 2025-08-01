// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:animal_market/core/common_widgets/media_source_picker.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/image_picker_utils.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/helper/location_status.dart';
import 'package:animal_market/modules/account/models/city_list_model.dart';
import 'package:animal_market/modules/account/models/state_list_model.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/buy/models/seller_model.dart';
import 'package:animal_market/modules/buy_crop/models/crop_details_model.dart';
import 'package:animal_market/modules/category/models/banners_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/sell/models/success_argument.dart';
import 'package:animal_market/modules/sell_crop/models/crop_quantities_model.dart';
import 'package:animal_market/modules/sell_crop/models/crop_type_model.dart';
import 'package:animal_market/modules/sell_crop/models/crop_variety_model.dart';
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

class SellCropProductsProvider extends ChangeNotifier {
  bool isLoading = true;
  bool isLoading1 = true;
  bool noData = false;
  bool noData1 = false;
  String categoryId = "";
  String image = "";
  String image1 = "";
  String image2 = "";
  String image3 = "";
  var bannerList = <BannersModel>[];
  Seller? seller;
  int selectedIndex = 0;
  String totalListed = "0";
  String totalCallsReceived = "0";
  String totalViewsReceived = "0";
  var cropList = <CropDetailModel>[];
  var images = <String>[];
  var videos = <String>[];
  var audios = <String>[];
  bool isOtherSelected = false;
  var videoFile = "";
  bool isVideo = false;
  VideoPlayerController? videoPlayerController;
  File? file;
  final picker = ImagePicker();
  CropDetailModel? cropDetailModel;
  CarouselSliderController carouselSliderController = CarouselSliderController();
  var subCategoryList = <SubCategoryListModel>[];
  SubCategoryListModel? subCategoryModel;
  String subCategoryId = "";
  var cropTypeList = <CropTypeModel>[];
  CropTypeModel? cropTypeModel;
  String cropTypeId = "";
  var cropVarietyList = <CropVarietyModel>[];
  CropVarietyModel? cropVarietyModel;
  String cropVarietyId = "";
  var cropQuantitiesList = <CropQuantitiesModel>[];
  CropQuantitiesModel? cropQuantitiesModel;
  String cropQuantityId = "";
  String isHarvested = "";
  TextEditingController isNegotiableController = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController cropNameController = TextEditingController();
  String isNegotiable = "0";
  String isOrganic = "0";
  String isQualityTested = "0";
  String? selectedSellerType;
  String? isOrganicController;
  String? isQualityTestedController;
  String? cropCondition;
  String? age;
  String? storageCondition;
  var stateList = <StateListModel>[];
  var cityList = <CityListModel>[];
  var stateModel;
  var cityModel;
  String stateId = "";
  String cityId = "";
  String stateName = "";
  String cityName = "";
  String statusType = "";
  String addressLocation = "";
  Position? currentPosition;
  var long = 00.00;
  var lat = 00.00;
  var sellerTypeList = [
    {"type": "farmer", "title": "farmer"},
    {"type": "reseller", "title": "reseller"},
  ];
  var storageList = [
    {"type": "warehouse", "title": "warehouse"},
    {"type": "open", "title": "open"},
    {"type": "cold_storage", "title": "coldStorage"},
    {"type": "not_applicable", "title": "notApplicable"},
  ];
  var ageList = [
    {"type": "less_than_3_months", "title": "lessThanThreeMonths"},
    {"type": "3_6_months", "title": "threeToSixMonths"},
    {"type": "6_12_months", "title": "sixToTwelveMonths"},
    {"type": "more_than_1_year", "title": "moreThanOneYear"},
    {"type": "other", "title": "other"},
  ];
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

  void updateIndexBanner(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void updateSellerType(String type) {
    selectedSellerType = type;
    notifyListeners();
  }

  void updateAge(String type) {
    age = type;
    notifyListeners();
  }

  void updateStorageCondition(String type) {
    storageCondition = type;
    notifyListeners();
  }

  void updateCropCondition(String type) {
    cropCondition = type;
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

  void updateIsOrganic(String v) {
    isOrganicController = v;
    if (v == "yes") {
      isOrganic = "1";
    } else {
      isOrganic = "0";
    }
    notifyListeners();
  }

  void updateIsQualityTested(String v) {
    isQualityTestedController = v;
    if (v == "yes") {
      isQualityTested = "1";
    } else {
      isQualityTested = "0";
    }
    notifyListeners();
  }

  void updateIsHarvested(String value) {
    isHarvested = value;
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

  void updateSubCategory(BuildContext context, SubCategoryListModel model) {
    subCategoryModel = model;
    subCategoryId = subCategoryModel!.id.toString();
    isOtherSelected = subCategoryModel?.title?.toLowerCase() == "other";
    cropName(context, subCategoryId);
    notifyListeners();
  }

  void updateCropQuantities(BuildContext context, CropQuantitiesModel model) {
    cropQuantitiesModel = model;
    cropQuantityId = cropQuantitiesModel!.slug.toString();
    notifyListeners();
  }

  void updateCropType(BuildContext context, CropTypeModel model) {
    cropTypeModel = model;
    cropTypeId = cropTypeModel!.id.toString();
    cropVariety(context, subCategoryId, cropTypeId);
    notifyListeners();
  }

  void updateCropVariety(BuildContext context, CropVarietyModel model) {
    cropVarietyModel = model;
    cropVarietyId = cropVarietyModel!.id.toString();
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
              cropName(context, subCategoryId);
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

  Future<void> cropName(BuildContext context, String categoryId) async {
    try {
      cropTypeList.clear();
      cropTypeModel = null;
      var result = await ApiService.cropName(categoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          cropTypeList = List<CropTypeModel>.from(json['data'].map((i) => CropTypeModel.fromJson(i))).toList(growable: true);
          for (int i = 0; i < cropTypeList.length; i++) {
            if (cropTypeList[i].id.toString() == cropTypeId) {
              cropTypeModel = cropTypeList[i];
              cropVariety(context, subCategoryId, cropTypeId);
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

  Future<void> cropVariety(BuildContext context, String cropCat, cropName) async {
    try {
      cropVarietyList.clear();
      cropVarietyModel = null;
      var result = await ApiService.cropVariety(cropCat, cropName);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          cropVarietyList = List<CropVarietyModel>.from(json['data'].map((i) => CropVarietyModel.fromJson(i))).toList(growable: true);
          for (int i = 0; i < cropVarietyList.length; i++) {
            if (cropVarietyList[i].id.toString() == cropVarietyId) {
              cropVarietyModel = cropVarietyList[i];
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

  Future<void> cropQualities(BuildContext context) async {
    try {
      cropQuantitiesList.clear();
      cropQuantitiesModel = null;
      var result = await ApiService.cropQualities();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          cropQuantitiesList = List<CropQuantitiesModel>.from(json['data'].map((i) => CropQuantitiesModel.fromJson(i))).toList(growable: true);
          for (int i = 0; i < cropQuantitiesList.length; i++) {
            if (cropQuantitiesList[i].slug.toString() == cropQuantityId) {
              cropQuantitiesModel = cropQuantitiesList[i];
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

  Future<void> sellerHome(bool isLoad) async {
    try {
      isLoading = isLoad;
      var result = await ApiService.sellerHome("crop");
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
      var result = await ApiService.sellerDashboard("crop", status);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        noData1 = false;
        isLoading1 = false;
        cropList = json['data']['listing'] == null ? [] : List<CropDetailModel>.from(json['data']['listing'].map((i) => CropDetailModel.fromJson(i))).toList(growable: true);
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
    required String? cropName,
    required String? cropVariety,
    required String? quantity,
    required String? price,
  }) {
    List<String> titleParts = [];
    if (category != null && category.isNotEmpty) {
      titleParts.add(category);
    }
    if (cropName != null && cropName.isNotEmpty) {
      titleParts.add(cropName);
    }
    if (cropVariety != null && cropVariety.isNotEmpty) {
      titleParts.add(cropVariety);
    }
    if (price != null && price.isNotEmpty) {
      titleParts.add("Rs $price");
    }
    return titleParts.join(" | ");
  }

  Future<void> createEditCattle(BuildContext context, String cropId, bool isEdit) async {
    title.text = generateTitle(
        category: '${subCategoryModel?.title}',
        cropName: isOtherSelected ? cropNameController.text : cropTypeModel?.title ?? "",
        cropVariety: cropVarietyModel?.title ?? "",
        quantity: cropQuantitiesModel?.title,
        price: " ${price.text} per ${cropQuantitiesModel?.title}");
    // if (!isEdit) {
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
    //  }
    try {
      showProgress(context);
      var result = await ApiService.createEditCrop(
        cropId,
        title.text,
        description.text,
        categoryId,
        subCategoryId,
        stateName,
        cityName,
        pinCode.text,
        addressLocation,
        lat.toString(),
        long.toString(),
        cropTypeId,
        isNegotiable,
        price.text,
        cropVarietyId,
        cropQuantityId,
        quantity.text,
        cropCondition != null ? cropCondition!.toLowerCase().trim() : "",
        isOrganic,
        isQualityTested,
        storageCondition ?? "",
        selectedSellerType ?? "",
        isHarvested,
        age ?? "",
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
          } else {
            Navigator.pushReplacementNamed(context, Routes.successfullyCreatedCrop,
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

  // Fetch user location
  Future<void> getLocationStatus() async {
    try {
      final position = await LocationStatus().determinePosition();
      if (position.latitude != 0.0 && position.longitude != 0.0) {
        await getCurrentPosition();
      } else {
        Log.console('Location is not detected. Please check if location is enabled and try again.');
      }
    } catch (e) {
      Log.console(e.toString());
    }
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
        stateName = "${place.administrativeArea}";
        pinCode.text = "${place.postalCode}";
        addressLocation = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}";
        Log.console("Latitude: $lat, Longitude: $long");
        Log.console("Address: $addressLocation");
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
    subCategoryList.clear();
    subCategoryModel = null;
    subCategoryId = "";
    cropTypeList.clear();
    cropTypeModel = null;
    cropTypeId = "";
    cropVarietyList.clear();
    cropVarietyModel = null;
    cropVarietyId = "";
    cropQuantitiesList.clear();
    cropQuantitiesModel = null;
    cropQuantityId = "";
    isHarvested = "";
    isNegotiableController.text = "";
    isOrganicController = null;
    isQualityTestedController = null;
    storageCondition = null;
    cropCondition = null;
    price.text = "";
    quantity.text = "";
    title.text = "";
    description.text = "";
    pinCode.text = "";
    isNegotiable = "0";
    isOrganic = "0";
    isQualityTested = "0";
    selectedSellerType = null;
    age = null;
    stateList.clear();
    cityList.clear();
    stateModel = null;
    cityModel = null;
    stateId = "";
    cityId = "";
    stateName = "";
    cityName = "";
    statusType = "";
    addressLocation = "";
    currentPosition = null;
    long = 00.00;
    lat = 00.00;
    images.clear();
    videos.clear();
    audios.clear();
    isShow = false;
  }

  Future<void> deleteCrop(BuildContext context, String cropId) async {
    try {
      showProgress(context);
      var result = await ApiService.deleteCrop(cropId);
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

  Future<void> cropMarkToSold(BuildContext context, String cattleId) async {
    try {
      showProgress(context);
      var result = await ApiService.cropMarkToSold(cattleId);
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

  Future<void> cropDetail(BuildContext context, String cropId) async {
    try {
      var result = await ApiService.cropDetail(cropId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        cropDetailModel = CropDetailModel.fromJson(json["data"]);
        title.text = cropDetailModel?.title ?? "";
        description.text = cropDetailModel?.description ?? "";
        categoryId = cropDetailModel!.categoryId.toString();
        subCategoryId = cropDetailModel!.subCategoryId.toString();
        stateName = cropDetailModel?.state ?? "";
        cityName = cropDetailModel?.city ?? "";
        pinCode.text = cropDetailModel?.pincode ?? "";
        addressLocation = cropDetailModel?.address ?? "";
        cropTypeId = cropDetailModel!.cropType.toString();
        isNegotiable = cropDetailModel!.isNegotiable.toString();
        if (isNegotiable == "1") {
          isNegotiableController.text = "Yes".toLowerCase();
        } else {
          isNegotiableController.text = "No".toLowerCase();
        }
        price.text = cropDetailModel!.price.toString();
        cropVarietyId = cropDetailModel!.cropVariety.toString();
        cropQuantityId = cropDetailModel?.quantityType ?? "";
        quantity.text = cropDetailModel!.quantity.toString();
        cropCondition = cropDetailModel?.cropCondition ?? "";
        isOrganic = cropDetailModel!.isOrganic.toString();
        isHarvested = (cropDetailModel?.isHarvested??0).toString();
        if (isOrganic == "1") {
          isOrganicController = "Yes".toLowerCase();
        } else {
          isOrganicController = "No".toLowerCase();
        }
        isQualityTested = cropDetailModel!.isQualityTested.toString();
        if (isQualityTested == "1") {
          isQualityTestedController = "Yes".toLowerCase();
        } else {
          isQualityTestedController = "No".toLowerCase();
        }
        storageCondition = cropDetailModel?.storageCondition;
        age = cropDetailModel?.age;
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

  void playAndPause(bool isPlay) {
    if (isPlay) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
    notifyListeners();
  }
}

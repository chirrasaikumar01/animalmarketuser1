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
import 'package:animal_market/modules/category/models/banners_model.dart';
import 'package:animal_market/modules/category/models/feature_list_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/sell/models/breed_list_model.dart';
import 'package:animal_market/modules/sell_pet/models/pet_details_model.dart';
import 'package:animal_market/modules/sell_pet/models/pet_purpose_model.dart';
import 'package:animal_market/modules/sell_pet/models/pet_success_argument.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class PetSellProductsProvider extends ChangeNotifier {
  bool isLoading = true;
  bool isLoading1 = true;
  bool noData = false;
  bool noData1 = false;
  String categoryId = "";
  String image = "";
  String image1 = "";
  String image2 = "";
  var images = [];
  var audios = [];
  var videos = [];
  var bannerList = <BannersModel>[];
  Seller? seller;
  int selectedIndex = 0;
  String totalListed = "0";
  String totalCallsReceived = "0";
  String totalViewsReceived = "0";
  var petList = <PatDetailsModel>[];
  CarouselSliderController carouselSliderController = CarouselSliderController();
  var subCategoryList = <SubCategoryListModel>[];
  SubCategoryListModel? subCategoryModel;
  String subCategoryId = "";
  var breedList = <BreedListModel>[];
  var heathStatusList = <BreedListModel>[];
  var featureList = <FeatureListModel>[];
  BreedListModel? breedListModel;
  String breedId = "";
  BreedListModel? healthStatusModel;
  String healthStatusId = "";
  String addressLocation = "";
  Position? currentPosition;
  var long = 00.00;
  var lat = 00.00;
  var genderList = [
    {"type": "male", "title": "male"},
    {"type": "female", "title": "female"},
    {"type": "other", "title": "other"},
  ];

  var vaccineList = [
    {"type": "fully", "title": "fullyVaccinated"},
    {"type": "partially", "title": "partiallyVaccinated"},
    {"type": "none", "title": "notVaccinated"},
  ];

  var sellerTypeList = [
    {"type": "Individual", "title": "individual"},
    {"type": "Licensed Breeder", "title": "licensedBreeder"},
    {"type": "Registered Pet Shop", "title": "registeredPetShop"},
    {"type": "Rescue Organization", "title": "rescueOrganization"},
  ];
  var purposeList = <PetPurposeModel>[
    PetPurposeModel(title: "forSale", type: "for_sale"),
    PetPurposeModel(title: "forAdoption", type: "for_adoption"),
    PetPurposeModel(title: "forMating", type: "for_mating"),
  ];
  var ageTypeList = [
    {"type": "years", "title": "years"},
    {"type": "months", "title": "months"},
    {"type": "days", "title": "days"},
  ];
  var trainingTypeList = [
    {"type": "house_trained", "title": "houseTrained"},
    {"type": "guard_trained", "title": "guardTrained"},
    {"type": "defence_trained", "title": "defenceTrained"},
  ];
  var deliveryTypeList = [
    {"type": "pickup_only", "title": "pickUpOnly"},
    {"type": "delivery_available", "title": "deliveryAvailable"},
    {"type": "ship_nationwide", "title": "shipNationwide"},
  ];
  String? selectedSellerType;
  PetPurposeModel? selectedPurpose;
  String? selectedAgeType;
  String? selectedGender;
  String? selectedVaccine;
  String? selectedTrainingType;
  String? selectedDeliveryType;
  TextEditingController isNegotiableController = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController sellerName = TextEditingController();
  TextEditingController sellerMobile = TextEditingController();
  TextEditingController sellerWhatsappMobile = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController vaccineName = TextEditingController();
  TextEditingController vaccineDate = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController shipping = TextEditingController();
  TextEditingController packing = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController breedName = TextEditingController();

  DateTime? selectedVaccineDate;
  PatDetailsModel? petDetailModel;
  String formattedVaccineDate = "";

  String isNegotiable = "0";
  String isVaccinated = "0";
  String isTrained = "0";
  var stateList = <StateListModel>[];
  var cityList = <CityListModel>[];
  var stateModel;
  var cityModel;
  String stateId = "";
  String cityId = "";
  String stateName = "";
  String cityName = "";
  String statusType = "";
  String microChippedSelected = "0";
  String dewormedSelected = "0";
  String neuteredSelected = "0";
  String careSelected = "0";
  String petsSelected = "0";
  String kidsSelected = "0";
  String trainedSelected = "0";
  var videoFile = "";
  bool isVideo = false;
  VideoPlayerController? videoPlayerController;
  File? file;
  final picker = ImagePicker();
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

  void setPickerDate(DateTime date) {
    selectedVaccineDate = date;
    Log.console(selectedVaccineDate.toString());
    formattedVaccineDate = DateFormat('yyyy-MM-dd').format(selectedVaccineDate!);
    vaccineDate.text = formattedVaccineDate;
    Log.console(formattedVaccineDate);
    notifyListeners();
  }

  void selectMicroChippedSelection(String v) {
    microChippedSelected = v;
    notifyListeners();
  }

  void selectDewormedSelection(String v) {
    dewormedSelected = v;
    notifyListeners();
  }

  void selectNeuteredSelection(String v) {
    neuteredSelected = v;
    notifyListeners();
  }

  void selectSpecialCareSelection(String v) {
    careSelected = v;
    notifyListeners();
  }

  void selectPetsSelection(String v) {
    petsSelected = v;
    notifyListeners();
  }

  void selectKidsSelection(String v) {
    kidsSelected = v;
    notifyListeners();
  }

  void selectTrainedSelection(String v) {
    trainedSelected = v;
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
    selectedGender = v;
    notifyListeners();
  }

  void updateSellerType(String type) {
    selectedSellerType = type;
    notifyListeners();
  }

  void updatePurpose(PetPurposeModel petPurposeModel) {
    selectedPurpose = petPurposeModel;
    notifyListeners();
  }

  void updateAgeType(String type) {
    selectedAgeType = type;
    notifyListeners();
  }

  void updateTrainingType(String type) {
    selectedTrainingType = type;
    notifyListeners();
  }

  void updateDeliveryType(String type) {
    selectedDeliveryType = type;
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

  void updateIsVaccinated(String v) {
    selectedVaccine = v;
    notifyListeners();
  }

  void updateIsTrained(String value) {
    isTrained = value;
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
          // featureList = List<FeatureListModel>.from(json['data'].map((i) => FeatureListModel.fromJson(i))).toList(growable: true);
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
      healthStatusId = "";
      var result = await ApiService.heathStatusList();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          heathStatusList = List<BreedListModel>.from(json['data'].map((i) => BreedListModel.fromJson(i))).toList(growable: true);
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
      var result = await ApiService.sellerHome("pet");
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
      var result = await ApiService.sellerDashboard("pet", status);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        noData1 = false;
        isLoading1 = false;

        seller = json['data']['seller'] == null ? null : Seller.fromJson(json['data']['seller']);
        petList = json['data']['listing'] == null ? [] : List<PatDetailsModel>.from(json['data']['listing'].map((i) => PatDetailsModel.fromJson(i))).toList(growable: true);
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
    required String? purpose,
    required String? gender,
    required String? price,
  }) {
    List<String> titleParts = [];
    if (category != null && category.isNotEmpty) {
      titleParts.add(category);
    }
    if (breed != null && breed.isNotEmpty) {
      titleParts.add(breed);
    }
    if (purpose != null && purpose.isNotEmpty) {
      titleParts.add(purpose);
    }
    if (gender != null && gender.isNotEmpty) {
      titleParts.add(gender);
    }
    if (price != null && price.isNotEmpty) {
      titleParts.add("Rs $price");
    }
    return titleParts.join(" | ");
  }

  Future<void> createEditPet(BuildContext context, String petId, bool isEdit) async {
    title.text = generateTitle(
        category: '${subCategoryModel?.title}',
        breed: breedListModel!.title!.toString().toLowerCase() == "Other".toLowerCase() ? breedName.text : '${breedListModel?.title}',
        purpose: selectedPurpose != null
            ? selectedPurpose!.title.toString().toLowerCase() == "forMating".toLowerCase()
                ? "For Mating"
                : selectedPurpose!.title.toString().toLowerCase() == "forSale".toLowerCase()
                    ? "For sale"
                    : selectedPurpose!.title.toString().toLowerCase() == "forAdoption".toLowerCase()
                        ? "For Adoption"
                        : selectedPurpose!.title.toString()
            : "",
        gender: selectedGender != null
            ? selectedGender!.toString().toLowerCase() == "male".toLowerCase()
                ? "Male"
                : selectedGender!.toString().toLowerCase() == "Female".toLowerCase()
                    ? "Female"
                    : selectedGender!.toString().toLowerCase() == "other".toLowerCase()
                        ? "Other"
                        : ""
            : "",
        price: price.text);
    if (!isEdit) {
      images.clear();
      videos.clear();
      audios.clear();
      if (recordedFilePath.isNotEmpty) {
        audios.add(recordedFilePath);
      }
      if (image.isNotEmpty) {
        Log.console(image);
        images.add(image);
      }
      if (image1.isNotEmpty) {
        images.add(image1);
      }
      if (image2.isNotEmpty) {
        images.add(image2);
      }
      if (images.isEmpty && videoFile.isEmpty) {
        errorToast(context, "Please select images");
        return;
      }
      if (videoFile.isNotEmpty) {
        Log.console(videoFile);
        videos.add(videoFile);
      }
    }
    try {
      showProgress(context);
      var result = await ApiService.createEditPet(
        petId,
        title.text,
        description.text,
        breedName.text,
        selectedPurpose?.type ?? "",
        categoryId,
        subCategoryId,
        breedId,
        selectedGender.toString(),
        selectedAgeType.toString(),
        age.text,
        isNegotiable,
        price.text,
        selectedVaccine.toString(),
        vaccineName.text,
        formattedVaccineDate,
        stateName,
        cityName,
        pinCode.text,
        addressLocation,
        lat.toString(),
        long.toString(),
        images,
        videos,
        audios,
        microChippedSelected.toString(),
        dewormedSelected.toString(),
        neuteredSelected.toString(),
        careSelected.toString(),
        petsSelected.toString(),
        kidsSelected.toString(),
        isTrained,
        selectedTrainingType ?? "",
        selectedDeliveryType ?? "",
        shipping.text,
        packing.text,
        sellerWhatsappMobile.text,
        sellerMobile.text,
        sellerName.text,
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
            Navigator.pushReplacementNamed(context, Routes.successfullyCreatedPet,
                arguments: PetSuccessArgument(
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
    images.clear();
    audios.clear();
    videos.clear();
    bannerList = <BannersModel>[];
    selectedIndex = 0;
    petList = <PatDetailsModel>[];
    subCategoryList.clear();
    subCategoryModel = null;
    subCategoryId = "";
    breedList.clear();
    heathStatusList.clear();
    featureList.clear();
    breedListModel = null;
    breedId = "";
    healthStatusModel = null;
    healthStatusId = "";
    addressLocation = "";
    long = 00.00;
    lat = 00.00;
    selectedSellerType = null;
    selectedPurpose = null;
    selectedAgeType = null;
    selectedGender = null;
    selectedVaccine = null;
    selectedTrainingType = null;
    selectedDeliveryType = null;
    isNegotiableController.text = "";
    title.text = "";
    sellerName.text = "";
    sellerMobile.text = "";
    sellerWhatsappMobile.text = "";
    description.text = "";
    vaccineName.text = "";
    vaccineDate.text = "";
    price.text = "";
    age.text = "";
    shipping.text = "";
    packing.text = "";
    pinCode.text = "";
    selectedVaccineDate = null;
    petDetailModel = null;
    formattedVaccineDate = "";
    isNegotiable = "0";
    isVaccinated = "0";
    isTrained = "0";
    stateList.clear();
    cityList.clear();
    stateModel = null;
    cityModel = null;
    stateId = "";
    cityId = "";
    stateName = "";
    cityName = "";
    statusType = "";
    microChippedSelected = "0";
    dewormedSelected = "0";
    neuteredSelected = "0";
    careSelected = "0";
    petsSelected = "0";
    kidsSelected = "0";
    trainedSelected = "0";
    videoFile = "";
    isVideo = false;
    isShow = false;
  }

  void playAndPause(bool isPlay) {
    if (isPlay) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
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
      case 'video':
        videoFile = "";
        break;
    }
    notifyListeners();
  }

  Future<void> petDelete(BuildContext context, String petId) async {
    try {
      showProgress(context);
      var result = await ApiService.deletePet(petId);
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

  Future<void> petMarkToSold(BuildContext context, String petId) async {
    try {
      showProgress(context);
      var result = await ApiService.petMarkToSold(petId);
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

  Future<void> petDetail(BuildContext context, String petId) async {
    try {
      var result = await ApiService.petDetail(petId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          petDetailModel = PatDetailsModel.fromJson(json["data"]);
          petId = petDetailModel!.id.toString();
          title.text = petDetailModel!.title.toString();
          description.text = petDetailModel!.description.toString();
          var selected = petDetailModel!.purpose.toString();
          for (var purpose in purposeList) {
            if (purpose.type == selected) {
              selectedPurpose = purpose;
              break;
            }
          }
          categoryId = petDetailModel!.categoryId.toString();
          subCategoryId = petDetailModel!.subCategoryId.toString();
          breedId = petDetailModel!.breed.toString();
          selectedGender = petDetailModel!.gender;
          selectedAgeType = petDetailModel!.ageType == "null" ? null : petDetailModel!.ageType;
          age.text = petDetailModel!.age ?? "";
          isNegotiable = petDetailModel!.isNegotiable.toString();
          if (isNegotiable == "1") {
            isNegotiableController.text = "Yes";
          } else {
            isNegotiableController.text = "No";
          }
          price.text = petDetailModel!.price.toString();
          selectedVaccine = petDetailModel!.vaccination;
          vaccineName.text = petDetailModel!.vaccineName.toString();
          formattedVaccineDate = petDetailModel!.vaccineDate ?? "";
          stateName = petDetailModel!.state.toString();
          cityName = petDetailModel!.city.toString();
          pinCode.text = petDetailModel!.pincode.toString();
          addressLocation = petDetailModel!.address.toString();
          // images = petDetailModel!.petImages ?? [];
          microChippedSelected = petDetailModel!.isMicrochipped.toString();
          dewormedSelected = petDetailModel!.isDewormed.toString();
          neuteredSelected = petDetailModel!.isNeutered.toString();
          careSelected = petDetailModel!.requiresSpecialCare.toString();
          petsSelected = petDetailModel!.goodWithPets.toString();
          kidsSelected = petDetailModel!.goodWithKids.toString();
          isTrained = petDetailModel!.isTrained;
          selectedTrainingType = petDetailModel!.trainingType;
          selectedDeliveryType = petDetailModel!.deliveryOption;
          shipping.text = petDetailModel!.shippingCharges.toString();
          packing.text = petDetailModel!.packingCharges.toString();
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
}

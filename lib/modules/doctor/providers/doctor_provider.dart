// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:animal_market/core/common_widgets/media_source_picker.dart';
import 'package:animal_market/core/common_widgets/select_date.dart';
import 'package:animal_market/core/constants.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/image_picker_utils.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/account/models/city_list_model.dart';
import 'package:animal_market/modules/account/models/state_list_model.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/auth/models/user_model.dart';
import 'package:animal_market/modules/doctor/models/banner_model.dart';
import 'package:animal_market/modules/doctor/models/doctor_home_model.dart';
import 'package:animal_market/modules/doctor/models/my_appointment_model.dart';
import 'package:animal_market/modules/doctor/models/plan_list_model.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DoctorProvider extends ChangeNotifier {
  CarouselSliderController carouselSliderController = CarouselSliderController();
  bool isLoading = true;
  bool isLoading1 = true;
  DoctorHomeModel? doctorHomeModel;
  var bannerList = <BannerModel>[];
  var myAppointmentList = <MyAppointment>[];
  int selectedIndex = 0;
  TextEditingController name = TextEditingController();
  TextEditingController clinicName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController fees = TextEditingController();
  TextEditingController aboutUs = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController searchKey = TextEditingController();
  var stateList = <StateListModel>[];
  var cityList = <CityListModel>[];
  var imageList = <String>[];
  var stateModel;
  var cityModel;
  String stateId = "";
  String cityId = "";
  String image = "";
  String image1 = "";
  String image2 = "";
  String image3 = "";
  var experience;
  var experienceList = List.generate(51, (index) => index.toString());
  var selectedPlan;
  var selectedPlanId = "";
  var selectedPlanPrice = "";
  var paymentMethod = "online";
  var planList = <PlanListModel>[];
  var paymentStatus = "Success";
  var transactionId = "";

  void reset() {
    name.text = "";
    clinicName.text = "";
    address.text = "";
    pinCode.text = "";
    aboutUs.text = "";
    startDate.text = "";
    endDate.text = "";
    stateId = "";
    cityId = "";
    image = "";
    image1 = "";
    image2 = "";
    image3 = "";
    selectedPlan = null;
    selectedPlanId = "";
    selectedPlanPrice = "";
    stateModel = null;
    cityModel = null;
    selectedIndex = 0;
    experience = null;
    imageList.clear();
  }

  void updateIndexBanner(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void updateExperience(String v) {
    experience = v;
    notifyListeners();
  }

  void updatePlan(BuildContext context, PlanListModel model) {
    selectedPlan = model;
    selectedPlanId = selectedPlan.id.toString();
    selectedPlanPrice = selectedPlan.price.toString();
    notifyListeners();
  }

  void cityUpdate(CityListModel model) {
    cityModel = model;
    cityId = cityModel.id.toString();
    notifyListeners();
  }

  void stateUpdate(BuildContext context, StateListModel model) {
    stateModel = model;
    stateId = stateModel.id.toString();
    cityListGet(context, stateId);
    notifyListeners();
  }

  Future<void> dateOfBirthSelect(BuildContext context, String type) {
    return selectDate(
      context: context,
      dateController: type == "end" ? endDate : startDate,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      onDatePicked: (pickedDate) {
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        if (type == "end") {
          endDate.text = formatter.format(pickedDate);
        } else {
          startDate.text = formatter.format(pickedDate);
        }
      },
    );
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
              if (imageType == "image") {
                image = pickedFile.path;
              }
              if (imageType == "image1") {
                image1 = pickedFile.path;
              }
              if (imageType == "image2") {
                image2 = pickedFile.path;
              }
              if (imageType == "image3") {
                image3 = pickedFile.path;
              }

              notifyListeners();
            }
          }
        }
      },
    );
  }

  Future<void> doctorHome(BuildContext context, bool loading) async {
    try {
      isLoading = loading;
      var result = await ApiService.doctorHome();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        doctorHomeModel = DoctorHomeModel.fromJson(json['data']);
        bannerList = doctorHomeModel!.banners!;
        name.text = doctorHomeModel!.doctor!.name!;
        clinicName.text = doctorHomeModel!.doctor!.clinicName!;
        experience = doctorHomeModel!.doctor!.experience!;
        address.text = doctorHomeModel!.doctor!.address!;
        pinCode.text = doctorHomeModel!.doctor!.pincode!;
        aboutUs.text = doctorHomeModel!.doctor!.aboutDoctor!;
        fees.text = doctorHomeModel!.doctor!.fees!;
        stateId = doctorHomeModel!.doctor!.state.toString();
        cityId = doctorHomeModel!.doctor!.city.toString();
      } else {
        isLoading = false;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> subscriptionPlanList(BuildContext context) async {
    try {
      isLoading = true;
      var result = await ApiService.subscriptionPlanList();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        planList = List<PlanListModel>.from(json['data'].map((i) => PlanListModel.fromJson(i))).toList(growable: true);
      } else {
        isLoading = false;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading = false;
      Log.console(e.toString());
    }
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

  Future createDoctor(BuildContext context, String doctorId, bool isEdit) async {
    imageList.add(image);
    imageList.add(image1);
    imageList.add(image2);
    imageList.add(image3);
    try {
      showProgress(context);
      final response = await ApiService.createDoctor(
        doctorId,
        name.text,
        clinicName.text,
        experience,
        stateId,
        cityId,
        address.text,
        pinCode.text,
        aboutUs.text,
        fees.text,
        imageList,
      );
      if (context.mounted) {
        if (response["status"] == true) {
          closeProgress(context);
          if (isEdit) {
            doctorHome(context, true);
            Navigator.pop(context);
          } else {
            Navigator.pushNamed(context, Routes.doctorPlan);
          }

          successToast(context, response["message"]);
        } else {
          closeProgress(context);
          errorToast(context, response["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
        Log.console(e.toString());
      }
    }
    notifyListeners();
  }

  Future<void> buySubscription(BuildContext context) async {
    try {
      var result = await ApiService.buySubscription(selectedPlanId, paymentMethod);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          doctorHome(context, true);
          Navigator.pop(context);
          Navigator.pop(context);
          reset();
          successToast(context, json["message"]);
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

  void resetFilter(BuildContext context) {
    searchKey.text = "";
    startDate.text = "";
    endDate.text = "";
    myAppointmentGet(context, false);
  }

  Future<void> myAppointmentGet(BuildContext context, bool isLoading) async {
    try {
      isLoading1 = isLoading;
      myAppointmentList.clear();
      var result = await ApiService.myAppointment(searchKey.text, "doctor", startDate.text, endDate.text);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading1 = false;
        myAppointmentList = List<MyAppointment>.from(json['data'].map((i) => MyAppointment.fromJson(i))).toList(growable: true);
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

  Future<void> cancelAppointment(BuildContext context, String appointmentId) async {
    try {
      showProgress(context);
      var result = await ApiService.cancelAppointment(appointmentId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          myAppointmentGet(context, false);
          doctorHome(context, false);
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
        Log.console(e.toString());
      }
    }
    notifyListeners();
  }

  Razorpay razorpay = Razorpay();
  String testKey = "rzp_test_6jyJ5wxNr6iRYz";
  String liveKey = "	";
  String testKeySecret = "ChINvTSZdU1ff2TvH7mtr932";
  String liveKeySecret = "";
  String userMobile = "12312112";
  String userEmail = "your_user_email";
  bool isTest = true;

  void handleExternalWallet(ExternalWalletResponse response) {
    closeProgress(Constants.navigatorKey.currentContext!);
    notifyListeners();
  }

  Future<void> userDetails(BuildContext context) async {
    AccountProvider p = Provider.of<AccountProvider>(context, listen: false);
    p.getProfile(context);
    User? crtUser = p.user;
    userEmail = crtUser?.email ?? "test@gamil.com";
    userMobile = crtUser?.mobile ?? "1234567890";
    Log.console(crtUser);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  Future<void> sendOrderRazor(BuildContext context) async {
    showProgress(context);
    var price = (int.parse(selectedPlan?.price ?? "0")).toString();
    double price2 = double.parse(price);
    int finalPrices = (price2 * 100).toInt();
    String basicAuth = 'Basic ${base64Encode(utf8.encode("${isTest ? testKey : liveKey}:${isTest ? testKeySecret : liveKeySecret}"))}';
    var headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
    };
    var data = {
      "amount": finalPrices,
      "currency": "INR",
      "receipt": "Receipt no. : ${DateTime.now()}",
      "payment_capture": 1,
    };
    var url = Uri.parse('https://api.razorpay.com/v1/orders');
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    var body = json.decode(response.body);
    debugPrint("$body");
    if (response.statusCode == 200) {
      var orderId = body['id'];
      if (context.mounted) {
        openPay(context, orderId, finalPrices);
      }
    } else {
      if (context.mounted) {
        errorToast(context, "Error Get Order Id.!!");
      }
      isLoading = false;
      notifyListeners();
    }
  }

  void openPay(BuildContext context, String id, int finalPrice) {
    isLoading = false;
    var options = {
      'key': isTest ? testKey : liveKey,
      'amount': finalPrice,
      'name': "Animal Market",
      'image': 'https://aegistax.co.in/animal_market/public/admin/images/logo.png',
      'order_id': id,
      'description': 'You Added $finalPrice Amount to your Wallet',
      'timeout': 300,
      'prefill': {
        'contact': "91$userMobile",
        'email': userEmail,
      },
      'theme': {'color': "#74AC42"}
    };
    try {
      closeProgress(context);
      razorpay.open(options);
    } catch (e) {
      closeProgress(context);
      isLoading = false;
      errorToast(context, e.toString());
      debugPrint(e.toString());
      notifyListeners();
    }
  }

  initRazorPay() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    paymentStatus = "Success";
    transactionId = response.paymentId.toString();
    await buySubscription(Constants.navigatorKey.currentContext!);
    notifyListeners();
  }

  Future<void> handlePaymentError(PaymentFailureResponse response) async {
    paymentStatus = "failed";
    Log.console("$response");
    errorToast(Constants.navigatorKey.currentContext!, "Payment Fail. !!");
    notifyListeners();
  }
}

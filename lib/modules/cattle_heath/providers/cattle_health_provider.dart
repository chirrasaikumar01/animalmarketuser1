// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:animal_market/core/constants.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/auth/models/user_model.dart';
import 'package:animal_market/modules/category/models/banners_model.dart';
import 'package:animal_market/modules/cattle_heath/models/my_reports_list_model.dart';
import 'package:animal_market/modules/doctor/models/plan_list_model.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:video_player/video_player.dart';

class CattleHealthProvider extends ChangeNotifier {
  CarouselSliderController carouselSliderController = CarouselSliderController();
  int currentStep = 0;
  final desController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final picker = ImagePicker();
  File? file;
  var images = [];
  var imagesFile = [];
  var videos = [];
  var videoFile = "";
  var reportPlanId = "";
  var paymentStatus = "Success";
  var transactionId = "";
  var bannerList = <BannersModel>[];
  var planList = <PlanListModel>[];
  var myReportAll = <MyReportsListModel>[];
  var myReport = <MyReportsListModel>[];
  PlanListModel? selectedPlan;
  var selectedPlanId = "";
  bool isLoading = true;
  bool noData = false;
  bool isLoading1 = true;
  bool isLoading2 = true;
  int selectedIndex = 0;
  Razorpay razorpay = Razorpay();
  String testKey = "rzp_test_6jyJ5wxNr6iRYz";
  String liveKey = "	";
  String testKeySecret = "ChINvTSZdU1ff2TvH7mtr932";
  String liveKeySecret = "";
  String userMobile = "12312112";
  String userEmail = "your_user_email";
  bool isTest = true;

  void updateIndexBanner(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void updatePlan(BuildContext context, PlanListModel model) {
    selectedPlan = model;
    selectedPlanId = selectedPlan!.id.toString();
    notifyListeners();
  }

  bool isVideo = false;
  VideoPlayerController? videoPlayerController;

  void isVideoUpdate(bool v) {
    isVideo = v;
    notifyListeners();
  }

  Future<void> downloadAndOpenFile(BuildContext context, String url) async {
    try {
      showProgress(context);
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, storagePermissionRequired);
        }
        return;
      }
      Directory? downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir = await getExternalStorageDirectory();
      }
      String filePath = '${downloadsDir!.path}/document.docx';
      if (context.mounted) {
        closeProgress(context);
        successToast(context, downloadFile);
      }
      final response = await http.get(Uri.parse(url));
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      if (context.mounted) {
        successToast(context, fileSavedFolder);
      }
      OpenFile.open(filePath);
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
        errorToast(context, failedDownloadFile);
      }
      Log.console("Error: $e");
    }
  }

  Future<bool?> getStoragePermission1() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {
        // await showPermissionDeniedDialog(Get.context!);
        return false;
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        return true;
      } else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
        return false;
      } else if (await Permission.photos.request().isDenied) {
        // await showPermissionDeniedDialog(Get.context!);
        return false;
      }
    }
    return null;
  }

  Future<void> downloadPdf1(BuildContext context, String pdfUrl) async {
    try {
      // Check and request permissions if necessary
      bool? permissionsGranted = await getStoragePermission1();
      if (!permissionsGranted!) {
        if (context.mounted) {
          errorToast(context, storagePermissionRequired);
        }
        return;
      }

      // Get the Downloads directory
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      if (downloadsDirectory == null) {
        throw Exception(failedDownloadFile);
      }

      // Construct the file path
      String fileName = pdfUrl.split('/').last;
      String filePath = p.join(downloadsDirectory.path, fileName);
      Log.console('Saving file to: $filePath');

      // Show progress while downloading
      if (context.mounted) {
        showProgress(context);
      }
      Dio dio = Dio();
      await dio.download(
        pdfUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total) * 100;
            Log.console('Download progress: $progress%');
          }
        },
      );

      // Verify if the file exists
      final file = File(filePath);
      if (await file.exists()) {
        Log.console('File successfully downloaded to: $filePath');
        OpenFile.open(filePath);
      } else {
        if (context.mounted) {
          closeProgress(context);
        }
        throw Exception("File not found after download.");
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console('Error downloading PDF: $e');
      if (context.mounted) {
        closeProgress(context);
        errorToast(context, 'Error downloading PDF: $e');
      }
    }
  }

  void resetData() {
    file = null;
    isVideo = false;
    noData = false;
    desController.text = "";
    locationController.text = "";
    priceController.text = "";
    videoFile = "";
    selectedPlanId = "";
    images.clear();
    imagesFile.clear();
    currentStep = 0;
    videos.clear();
  }

  void removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  Future<void> pickMedia({required BuildContext context, required bool isVideo}) async {
    final pickedFile = isVideo ? await picker.pickVideo(source: ImageSource.gallery) : await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      file = File(pickedFile.path);
      if (isVideo) {
        videoFile = file!.path;
      } else {
        images.add(file);
        imagesFile.add(file?.path);
      }

      if (isVideo) {
        videoPlayerController = VideoPlayerController.file(file!)
          ..initialize().then((_) {
            videoPlayerController!.play();
            notifyListeners();
          });
      } else {
        notifyListeners();
      }
    } else {
      Log.console("No file selected");
    }
  }

  void nextStep() {
    if (currentStep < 3) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  Widget buildStep(int step, String icon, String label,String label1) {
    bool isActive = step <= currentStep;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 28.h,
          width: 28.h,
          padding: EdgeInsets.all(4.h),
          decoration: BoxDecoration(
            color: isActive ? ColorConstant.appCl : ColorConstant.borderCl,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              icon,
              height: 20.h,
              width: 20.w,
              color: isActive ? Colors.white : ColorConstant.textLightCl,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        TText(
          keyName: label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? ColorConstant.appCl : ColorConstant.textDarkCl,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            fontSize: 9.sp,
            fontFamily: isActive ? FontsStyle.semiBold : FontsStyle.medium,
            fontStyle: FontStyle.normal,
          ),
        ),
        TText(
          keyName: label1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? ColorConstant.appCl : ColorConstant.textDarkCl,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            fontSize: 9.sp,
            fontFamily: isActive ? FontsStyle.semiBold : FontsStyle.medium,
            fontStyle: FontStyle.normal,
          ),
        ),
      ],
    );
  }

  Widget buildStepContainer(int step) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(vertical: 2.w),
      margin: EdgeInsets.only(top: 12.h),
      decoration: BoxDecoration(
        color: currentStep == step || currentStep > step ? ColorConstant.appCl : ColorConstant.borderCl,
        borderRadius: BorderRadius.circular(2.dm),
      ),
    );
  }

  Future<void> healthReportHome(BuildContext context) async {
    try {
      myReport.clear();
      bannerList.clear();
      isLoading = true;
      var result = await ApiService.healthReportHome();
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading = false;
          noData = false;
          bannerList = json['data']['banners'] == null ? [] : List<BannersModel>.from(json['data']['banners'].map((i) => BannersModel.fromJson(i))).toList(growable: true);
          myReport = json['data']['my_reports'] == null ? [] : List<MyReportsListModel>.from(json['data']['my_reports'].map((i) => MyReportsListModel.fromJson(i))).toList(growable: true);
        } else {
          noData = true;
          isLoading = false;
        }
      }
    } catch (e) {
      noData = true;
      isLoading = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> reportPlanList(BuildContext context) async {
    try {
      isLoading1 = true;
      var result = await ApiService.reportPlanList();
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading1 = false;
          planList = json['data'] == null ? [] : List<PlanListModel>.from(json['data'].map((i) => PlanListModel.fromJson(i))).toList(growable: true);
        } else {
          isLoading1 = false;
        }
      }
    } catch (e) {
      isLoading1 = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<bool> healthReportAdd(BuildContext context) async {
    videos.add(videoFile.toString());
    try {
      showProgress(context);
      var result = await ApiService.healthReportAdd(
        selectedPlanId,
        selectedPlan?.price ?? "",
        selectedPlan?.gst,
        desController.text,
        imagesFile,
        videos,
      );
      if (result["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
        }
        reportPlanId = result['report_id'].toString();
        notifyListeners();
        return true;
      } else {
        if (context.mounted) {
          closeProgress(context);
        }
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> payForHealthReport(BuildContext context) async {
    try {
      showProgress(context);
      var result = await ApiService.payForHealthReport(
        reportPlanId,
        paymentStatus,
        transactionId,
      );
      var json = jsonDecode(result.body);

      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          healthReportHome(context);
        }
        notifyListeners();
        nextStep();
        return true;
      } else {
        if (context.mounted) {
          closeProgress(context);
        }
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
      notifyListeners();
      return false;
    }
  }

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
    var price = (int.parse(selectedPlan?.price ?? "0") + int.parse(selectedPlan?.gst ?? "0")).toString();
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
    await payForHealthReport(Constants.navigatorKey.currentContext!);
    notifyListeners();
  }

  Future<void> handlePaymentError(PaymentFailureResponse response) async {
    paymentStatus = "failed";
    Log.console("$response");
    errorToast(Constants.navigatorKey.currentContext!, "Payment Fail. !!");
    notifyListeners();
  }

  Future<void> myHealthReport(BuildContext context, String date) async {
    try {
      myReportAll.clear();
      isLoading2 = true;
      var result = await ApiService.myHealthReport(date);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading2 = false;
          myReportAll = json['data'] == null ? [] : List<MyReportsListModel>.from(json['data'].map((i) => MyReportsListModel.fromJson(i))).toList(growable: true);
        } else {
          isLoading2 = false;
        }
      }
    } catch (e) {
      isLoading2 = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }
}

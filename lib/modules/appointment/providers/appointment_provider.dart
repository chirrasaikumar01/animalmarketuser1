import 'dart:convert';

import 'package:animal_market/core/constants.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/auth/models/user_model.dart';
import 'package:animal_market/modules/doctor/models/my_appointment_model.dart';
import 'package:animal_market/modules/doctor/models/time_slot_list_model.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AppointmentProvider extends ChangeNotifier {
  var selectedDateValue = "0";
  var timeSlotList = <TimeSlotsListModel>[];
  TimeSlotsListModel? selectedTimeSlot;
  var selectedTimeSlotId = "0";
  var doctorId = "0";
  var fees = "0";
  var paymentMode = "online";
  bool isLoading = true;
  bool isLoading1 = true;
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController searchKey = TextEditingController();
  var myAppointmentList = <MyAppointment>[];
  String paymentStatus = "";
  String transactionId = "";

  void resetData() {
    selectedDateValue = "0";
    selectedTimeSlotId = "0";
    isLoading = true;
    timeSlotList = [];
    selectedTimeSlot = null;
    notifyListeners();
  }

  void dateChange(BuildContext context, var value) {
    selectedDateValue = DateFormat('yyyy-MM-dd').format(value);
    timeSlotsList(context, doctorId, DateFormat('EEE').format(value).toLowerCase());
    notifyListeners();
  }

  void timeSlotIdUpdate(TimeSlotsListModel timeSlot, String id) {
    selectedTimeSlot = timeSlot;
    selectedTimeSlotId = id;
    notifyListeners();
  }

  Future<void> timeSlotsList(BuildContext context, String doctorId, String day) async {
    try {
      isLoading = true;
      var result = await ApiService.timeSlotsList(doctorId, day);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        timeSlotList = List<TimeSlotsListModel>.from(json['data'].map((i) => TimeSlotsListModel.fromJson(i))).toList(growable: true);
      } else {
        isLoading = false;
        if (context.mounted) {
          errorToast(context, json["message"]);
        }
      }
    } catch (e) {
      isLoading = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> appointmentCreate(BuildContext context) async {
    try {
      showProgress(context);
      var result = await ApiService.bookAppointment(
        doctorId,
        selectedDateValue,
        selectedTimeSlotId,
        paymentMode,
      );
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          Navigator.pop(context);
          successToast(context, json["message"]);
        }
      } else {
        if (context.mounted) {
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
      var result = await ApiService.myAppointment(searchKey.text, "patient", startDate.text, endDate.text);
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
    var price = (int.parse(fees)).toString();
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
        closeProgress(context);
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
    await appointmentCreate(Constants.navigatorKey.currentContext!);
    notifyListeners();
  }

  Future<void> handlePaymentError(PaymentFailureResponse response) async {
    paymentStatus = "failed";
    Log.console("$response");
    errorToast(Constants.navigatorKey.currentContext!, "Payment Fail. !!");
    notifyListeners();
  }
}

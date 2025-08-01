import 'dart:async';
import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/auth/models/language_argument.dart';
import 'package:animal_market/modules/auth/models/language_list_model.dart';
import 'package:animal_market/modules/auth/models/location_argument.dart';
import 'package:animal_market/modules/auth/models/otp_argument.dart';
import 'package:animal_market/modules/auth/models/user_model.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController otp = TextEditingController();
  var languageList = <LanguageListModel>[];
  String languageCode = "en";
  bool isLoading = true;
  int remainingSeconds = 30;
  Timer? timer;
  bool isResend = false;

  void startCountdown() {
    isResend = false;
    remainingSeconds = 30;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timers) {
        if (remainingSeconds > 0) {
          remainingSeconds--;
          notifyListeners();
        } else {
          remainingSeconds = 0;
          timer?.cancel();
          isResend = true;
          notifyListeners();
        }
      },
    );
  }

  Future<void> initApp({required BuildContext context}) async {
    var instance = await SharedPreferences.getInstance();
    var crtData = instance.getString('currentUser');
    await Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        if (context.mounted) {
          if (crtData != null) {
            User crtUser = User.fromJson(jsonDecode(crtData));
            var lang = instance.getString('langCode');
            var selectedLanguage = lang ?? "";
            Provider.of<TranslationsProvider>(context, listen: false).loadLanguage(selectedLanguage);
            Log.console(crtUser);
            if (crtUser.name == "") {
              Navigator.pushNamedAndRemoveUntil(context, Routes.userName, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, Routes.category, (route) => false);
            }
          } else {
            Navigator.pushNamedAndRemoveUntil(context, Routes.selectLanguage, arguments: LanguageArgument(isEdit: false), (route) => false);
          }
        }
      },
    );
  }

  void updateLanguageCode(String v) {
    languageCode = v;
    notifyListeners();
  }

  void updateOtp(String v) {
    otp.text = v;
    notifyListeners();
  }

  Future<void> updateLanguage(String v,String code) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString('lang', v);
    await pref.setString('langCode', code);
    notifyListeners();
  }

  Future<void> changeLanguage(BuildContext context) async {
    try {
      showProgress(context);
      var result = await ApiService.changeLanguage(languageCode);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          closeProgress(context);
          Navigator.pushNamedAndRemoveUntil(context, Routes.category, (route) => false);
          successToast(context, json["message"].toString());
        } else {
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

  Future<void> registerApi(BuildContext context, bool isNavigation) async {
    try {
      showProgress(context);
      var result = await ApiService.registerApi(languageCode, "91", mobile.text);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          closeProgress(context);
          if (isNavigation) {
            Navigator.pushNamed(context, Routes.otp, arguments: OtpArgument(phone: mobile.text));
          } else {}

          successToast(context, json["message"].toString());
        } else {
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

  Future<void> languageListGet(BuildContext context) async {
    try {
      isLoading = true;
      var result = await ApiService.languageList();
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading = false;
          languageList = List<LanguageListModel>.from(json['data'].map((i) => LanguageListModel.fromJson(i))).toList(growable: true);
        } else {
          isLoading = false;
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> verifyOtpApi(BuildContext context) async {
    if (otp.text.isEmpty) {
      errorToast(context, enterOTP);
      return;
    }

    if (otp.text.length < 4) {
      errorToast(context, enterOTPValid);
      return;
    }
    try {
      showProgress(context);
      var result = await ApiService.verifyOtpApi(
        mobile.text,
        otp.text,
      );
      var json = jsonDecode(result.body);
      final apiResponse = UserModel.fromJson(json);
      if (json["status"] == true) {
        var pref = await SharedPreferences.getInstance();
        await pref.setString('currentUser', jsonEncode(apiResponse.user?.toJson()));
        await pref.setString('currentToken', apiResponse.accessToken.toString());
        if (context.mounted) {
          closeProgress(context);
          if (apiResponse.user?.address == "") {
            name.text = apiResponse.user!.name.toString();
            Navigator.pushNamedAndRemoveUntil(context, Routes.location, arguments: LocationArgument(isEdit: false), (route) => false);
          } else if (apiResponse.user?.name == "") {
            Navigator.pushNamedAndRemoveUntil(context, Routes.userName, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, Routes.category, (route) => false);
          }
          successToast(context, json["message"].toString());
        }
      } else {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, json["msg"].toString());
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

  double late = 00.0;
  double long = 00.0;
  String cityName = "";
  String stateName = "";
  String stateCode = "";
  String pinCode = "";

  Future<void> fetchPlaceDetails(String placeId) async {
    final String apiKey = "AIzaSyDqa48JWUaqiPJfGPVAjjFR0Zmd74U3y1E";
    final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";
    Log.console(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] != null) {
        final lat = data['result']['geometry']['location']['lat'];
        final lng = data['result']['geometry']['location']['lng'];
        for (var component in data['result']['address_components']) {
          if (component['types'].contains('locality')) {
            cityName = component['long_name'];
          }
          if (component['types'].contains('administrative_area_level_1')) {
            stateName = component['long_name'];
            stateCode = component['short_name'];
          }
          if (component['types'].contains('postal_code')) {
            pinCode = component['long_name'] ?? "";
          }
        }
        Log.console("City: $cityName");
        Log.console("State: $stateName");
        Log.console("State Code: $stateCode");

        late = lat;
        long = lng;
      }
    } else {
      Log.console("Failed to fetch place details: ${response.statusCode}");
    }
  }
}

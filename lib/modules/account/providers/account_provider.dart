import 'dart:convert';
import 'dart:io';

import 'package:animal_market/core/common_widgets/media_source_picker.dart';
import 'package:animal_market/core/common_widgets/select_date.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/image_picker_utils.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/auth/models/language_argument.dart';
import 'package:animal_market/modules/auth/models/language_list_model.dart';
import 'package:animal_market/modules/auth/models/user_model.dart';
import 'package:animal_market/modules/community/models/reasons_list_model.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountProvider extends ChangeNotifier {
  String image = "";
  String imageUrl = "";
  String selectedReasonId = "";
  TextEditingController name = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController whatsAppNo = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  bool isLoading = true;
  bool noData = false;
  String countryCode = "91";
  String content = "";
  String mobileNo = "";
  String email = "";
  String whatsappNo = "";
  String twitter = "";
  String youtube = "";
  String facebook = "";
  String instagram = "";
  var languageList = <LanguageListModel>[];
  String languageCode = "";
  LanguageListModel? languageModel;
  String? gender;
  var reasonList = <ReasonsListModel>[];
  User? user;

  void updateGender(String v) {
    gender = v;
    notifyListeners();
  }

  void updateLanguageCode(LanguageListModel model, String v) {
    languageModel = model;
    languageCode = v;
    notifyListeners();
  }

  Future<void> dateOfBirthSelect(BuildContext context) {
    return selectDate(
      context: context,
      dateController: dateOfBirth,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      onDatePicked: (pickedDate) {
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        dateOfBirth.text = formatter.format(pickedDate);
      },
    );
  }

  void onUploadImage(BuildContext context) {
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
              applyEditor: true,
              context: context,
              toolbarBackgroundColor: ColorConstant.appCl,
            ).pickedFile(value);
            if (pickedFile != null) {
              image = pickedFile.path;
              notifyListeners();
            }
          }
        }
      },
    );
  }

  void selectReason(String id) {
    selectedReasonId = id;
    notifyListeners();
  }

  String? emailValidator(value) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(pattern);

    if (value!.isEmpty) {
      return enterEmail;
    } else if (!regExp.hasMatch(
      value.toString().trim(),
    )) {
      return enterEmailValid;
    } else {
      return null;
    }
  }

  Future<void> updateUser(User user) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString('currentUser', jsonEncode(user.toJson()));
    await pref.reload();
    notifyListeners();
  }

  Future<void> logoutRoute(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.selectLanguage,arguments: LanguageArgument(isEdit: false), (route) => false);
    }
  }

  Future<void> getCmsPages(BuildContext context, String type) async {
    isLoading = true;
    try {
      var result = await ApiService.getCmsPages(type);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading = false;
          noData = false;
          content = json["data"]["content"].toString();
          mobileNo = json["data"]["mobile_no"] ?? "";
          email = json["data"]["email"] ?? "";
          whatsappNo = json["data"]["whatsapp_no"] ?? "";
          twitter = json["data"]["twitter"] ?? "";
          youtube = json["data"]["youtube"] ?? "";
          facebook = json["data"]["facebook"] ?? "";
          instagram = json["data"]["instagram"] ?? "";
        } else {
          isLoading = false;
          noData = true;
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        isLoading = false;
        noData = true;
        Log.console(e.toString());
      }
    }
    notifyListeners();
  }

  Future<void> deactivateAccount(BuildContext context) async {
    showProgress(context);
    try {
      var result = await ApiService.deactivateAccount(selectedReasonId);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          closeProgress(context);
          logoutRoute(context);
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

  Future<void> launchURL(String url) async {
    try {
      Log.console('Attempting to launch URL: $url');
      final uri = Uri.tryParse(url);
      if (uri == null) {
        Log.console('Invalid URL: $url');
        throw 'Invalid URL';
      }
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Log.console('URL launched successfully: $url');
      } else {
        Log.console('Cannot launch URL: $url');
        throw 'Could not launch $url';
      }
    } catch (e) {
      Log.console('Error launching URL: $e');
      rethrow;
    }
  }

  Future<void> languageListGet(BuildContext context) async {
    languageModel = null;
    try {
      isLoading = true;
      var result = await ApiService.languageList();
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading = false;
          languageList = List<LanguageListModel>.from(json['data'].map((i) => LanguageListModel.fromJson(i))).toList(growable: true);
          for (int i = 0; i < languageList.length; i++) {
            if (languageList[i].languageCode.toString() == languageCode) {
              languageModel = languageList[i];
            }
          }
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

  Future<void> reasonsList(BuildContext context) async {
    selectedReasonId = "";
    try {
      isLoading = true;
      var result = await ApiService.reasonsList("delete");
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        reasonList = List<ReasonsListModel>.from(json['data'].map((i) => ReasonsListModel.fromJson(i))).toList(growable: true);
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

  Future<void> getProfile(BuildContext context) async {
    gender=null;
    try {
      isLoading = true;
      var result = await ApiService.getProfile();
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading = false;
          user = User.fromJson(json["data"]);
          await updateUser(user!);
          name.text = user?.name ?? "";
          emailController.text = user?.email ?? "";
          countryCode = user?.countryCode ?? "";
          whatsAppNo.text = user?.whatsappNo ?? "";
          languageCode = user?.languageCode ?? "";
          dateOfBirth.text = user?.dob ?? "";
          gender = user?.gender;
          address.text = user?.address ?? "";
          imageUrl = user?.profile ?? "";
          mobile.text = user?.mobile ?? "";
          state.text = user?.state ?? "";
          city.text = user?.city ?? "";
          pinCode.text = user?.pinCode ?? "";
          latitude.text = user?.latitude ?? "";
          longitude.text = user?.longitude ?? "";
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

  Future<void> updateProfile(BuildContext context, bool isUserName, bool isLocation, bool isHome) async {
    try {
      if (emailController.text.isNotEmpty) {
        var msg = emailValidator(emailController.text);
        if (msg != null) {
          errorToast(context, msg);
          return;
        }
      }
      if (!isHome) {
        showProgress(context);
      }

      final response = await ApiService.updateProfile(
        name.text,
        emailController.text,
        countryCode,
        whatsAppNo.text,
        languageCode,
        dateOfBirth.text,
        gender??"",
        address.text,
        image,
        state.text,
        city.text,
        pinCode.text,
        latitude.text,
        longitude.text,
      );

      if (context.mounted) {
        if (response["status"] == true) {
          if (!isHome) {
            closeProgress(context);
          }
          getProfile(context);
          _handleNavigation(context, isUserName, isLocation, isHome);
          if (!isHome) {
            successToast(context, response["message"]);
          }
        } else {
          if (!isHome) {
            closeProgress(context);
            errorToast(context, response["message"].toString());
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        if (!isHome) {
          closeProgress(context);
        }
        Log.console(e.toString());
      }
    }

    notifyListeners();
  }

  /// Handles navigation logic after profile update
  void _handleNavigation(BuildContext context, bool isUserName, bool isLocation, bool isHome) {
    if (isUserName) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.category, (route) => false);
    } else if (isLocation) {
      if (name.text.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, Routes.userName, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, Routes.category, (route) => false);
      }
    } else if (isHome) {
    } else {
      Navigator.pop(context);
    }
  }
  Future<void> shareApp() async {
    String packageName = 'com.animal_market';
    String appStoreUrl = 'https://apps.apple.com/app/$packageName';
    String playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';
    String msg = downLoadMsg;
    if (!Platform.isAndroid) {
      await Share.share('$msg\n $appStoreUrl');
    } else if (Platform.isAndroid) {
      await Share.share('$msg\n $playStoreUrl"');
    } else {
      throw 'Could not launch store';
    }
  }
}

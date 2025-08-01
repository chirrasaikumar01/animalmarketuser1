import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/category/models/banners_model.dart';
import 'package:animal_market/modules/category/models/category_list_model.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:carousel_slider/carousel_controller.dart';

class CategoryProvider extends ChangeNotifier {
  CarouselSliderController carouselSliderController = CarouselSliderController();
  var categoryList = <CategoryListModel>[];
  int selectedIndex = 0;
  bool isLoading = true;
  String unreadNotiCount = "0";
  String todayEventCount = "0";
  void updateIndexBanner(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  var bannerList = <BannersModel>[];

  Future<void> categoryListGet(BuildContext context,bool isLoad) async {
    try {
      isLoading = isLoad;
      var result = await ApiService.categoryList();
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading = false;
          unreadNotiCount = json["unread_noti_count"].toString();
          todayEventCount = json["today_event_count"].toString();
          categoryList = List<CategoryListModel>.from(json['data'].map((i) => CategoryListModel.fromJson(i))).toList(growable: true);
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
  Future<void> fcmUpdate(BuildContext context, String fcmToken) async {
    try {
      var result = await ApiService.fcmUpdate(fcmToken);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
        } else {
          Log.console(json["message"].toString());
        }
      }
    } catch (e) {
      Log.console(e.toString());
    }
    notifyListeners();
  }
}

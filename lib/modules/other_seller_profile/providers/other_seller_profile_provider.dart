import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/other_seller_profile/models/other_seller_profile_model.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:carousel_slider/carousel_controller.dart';

class OtherSellerProvider extends ChangeNotifier {
  bool isLoading = true;
  bool noData = false;
  OtherSellerProfileModel? otherSellerProfileModel;
  var sId = '';
  int selectedIndex = 0;
  CarouselSliderController carouselSliderController = CarouselSliderController();

  void updateIndexBanner(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> getOtherSellerDetail(BuildContext context, String sellerId, bool isLoad) async {
    sId = sellerId;
    try {
      isLoading = isLoad;
      var result = await ApiService.getOtherSellerDetail(sellerId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        noData = false;
        otherSellerProfileModel = OtherSellerProfileModel.fromJson(json["data"]);
      } else {
        isLoading = false;
        noData = true;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading = false;
      noData = true;
      Log.console('Exception loading translations: $e');
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
          getOtherSellerDetail(context, sId, false);
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

  Future<void> blogpostLike(BuildContext context, String postId) async {
    try {
      showProgress(context);
      var result = await ApiService.blogpostLike(postId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          getOtherSellerDetail(context, sId, false);
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
  Future<void> increaseCallCount(String type, String postId) async {
    try {
      var result = await ApiService.increaseCallCount(type, postId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
      } else {
      }
    } catch (e) {
      Log.console(e.toString());
    }
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/buy_crop/models/crop_near_you_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/services/api_service.dart';

class BuyCropProvider extends ChangeNotifier {
  bool isLoading = true;
  bool isLoading1 = true;
  bool noData = false;
  var buyCropList = <SubCategoryListModel>[];
  var cropNearYou = <CropNearYouModel>[];
  var subCategoryList = <SubCategoryListModel>[];
  TextEditingController searchController = TextEditingController();


  Future<void> buyCattleHome(BuildContext context, String categoryId) async {
    try {
      isLoading = true;
      var result = await ApiService.buyCropCattleHome(categoryId, "crop");
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        if (context.mounted) {
          if (json["data"] != null) {
            noData = false;
            buyCropList = json["data"]["sub_category"] == null ? [] : List<SubCategoryListModel>.from(json['data']["sub_category"].map((i) => SubCategoryListModel.fromJson(i))).toList(growable: true);
            cropNearYou = json["data"]["near_you"] == null ? [] : List<CropNearYouModel>.from(json['data']["near_you"].map((i) => CropNearYouModel.fromJson(i))).toList(growable: true);
          } else {
            noData = true;
          }
        }
      } else {
        if (context.mounted) {
          noData = true;
          isLoading = false;
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      noData = true;
      isLoading = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> subCategory(BuildContext context, String categoryId) async {
    try {
      isLoading1 = true;
      var result = await ApiService.subCategory(categoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading1 = false;
        if (context.mounted) {
          subCategoryList = List<SubCategoryListModel>.from(json['data'].map((i) => SubCategoryListModel.fromJson(i))).toList(growable: true);
        }
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
}

import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/my_favorite/models/my_favorite_list_model.dart';
import 'package:animal_market/services/api_service.dart';

class MyFavoriteProvider extends ChangeNotifier {
  bool isLoading1 = true;
  var myFavouriteList = <MyFavoriteListModel>[];
  Future<void> myFavouriteListGet(BuildContext context,String categoryId) async {
    try {
      myFavouriteList.clear();
      isLoading1 = true;
      var result = await ApiService.myFavouriteList(categoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading1 = false;
        myFavouriteList = List<MyFavoriteListModel>.from(json['data'].map((i) => MyFavoriteListModel.fromJson(i))).toList(growable: true);
      } else {
        isLoading1 = false;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading1 = false;
      Log.console(e.toString());
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
          myFavouriteListGet(context,"");
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
}

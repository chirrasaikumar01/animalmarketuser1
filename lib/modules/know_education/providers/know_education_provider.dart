import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/category/models/category_list_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/know_education/model/knowledge_list_model.dart';
import 'package:animal_market/services/api_service.dart';

class KnowEducationProvider extends ChangeNotifier {
  bool isLoading = true;
  bool isLoading1 = true;
  bool isLoading2 = true;
  bool noData = false;
  var knowEducationList = <KnowledgeListData>[];
  var myFavouriteList = <KnowledgeListData>[];
  var filteredList = <KnowledgeListData>[];
  var knowledgeListData=KnowledgeListData();
  String categoryId = "";
  String subCategoryId = "";
  var categoryList = <CategoryListModel>[];
  var subCategoryList = <SubCategoryListModel>[];
  SubCategoryListModel? subCategoryModel;
  CategoryListModel? categoryListModel;

  void reset() {
    subCategoryId = "";
    categoryListModel = null;
    subCategoryModel = null;
    categoryList.clear();
    subCategoryList.clear();
    knowEducationList.clear();
    isLoading = true;
  }

  void updateCategory(BuildContext context, CategoryListModel model) {
    categoryListModel = model;
    categoryId = categoryListModel!.id.toString();
    subCategory(context, categoryId);
    notifyListeners();
  }

  void updateSubCategory(BuildContext context, SubCategoryListModel model) {
    subCategoryModel = model;
    subCategoryId = subCategoryModel!.id.toString();
    notifyListeners();
  }

  Future<void> categoryListGet(BuildContext context) async {
    try {
      categoryList.clear();
      categoryListModel = null;
      subCategoryList.clear();
      subCategoryModel = null;
      subCategoryId = "";
      var result = await ApiService.categoryList();
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          categoryList = List<CategoryListModel>.from(json['data'].map((i) => CategoryListModel.fromJson(i))).toList(growable: true);
        } else {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> subCategory(BuildContext context, String categoryId) async {
    try {
      subCategoryList.clear();
      subCategoryModel = null;
      subCategoryId = "";
      var result = await ApiService.subCategory(categoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          subCategoryList = List<SubCategoryListModel>.from(json['data'].map((i) => SubCategoryListModel.fromJson(i))).toList(growable: true);
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

  Future<void> knowledgeListGet(BuildContext context, String catId, String subCatId) async {
    try {
      knowEducationList.clear();
      isLoading = true;
      var result = await ApiService.knowledgeList(catId, subCatId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        knowEducationList = List<KnowledgeListData>.from(json['data'].map((i) => KnowledgeListData.fromJson(i))).toList(growable: true);
        filteredList = knowEducationList;
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
  Future<void> knowledgeDetailsGet(BuildContext context, String knowledgeId) async {
    try {
      isLoading2 = true;
      var result = await ApiService.knowledgeDetails(knowledgeId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading2 = false;
        noData=false;
        knowledgeListData = KnowledgeListData.fromJson(json["data"]);
      } else {
        isLoading2 = false;
        noData=true;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      noData=true;
      isLoading2 = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }
  Future<void> myFavouriteListGet(BuildContext context,String categoryId) async {
    try {
      myFavouriteList.clear();
      isLoading1 = true;
      var result = await ApiService.myFavouriteList(categoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading1 = false;
        myFavouriteList = List<KnowledgeListData>.from(json['data'].map((i) => KnowledgeListData.fromJson(i))).toList(growable: true);
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

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredList = knowEducationList;
    } else {
      List<KnowledgeListData> tempList = [];
      for (var item in knowEducationList) {
        if (item.title!.toLowerCase().toString().contains(query.toLowerCase()) || item.title!.toLowerCase().toString().contains(query.toLowerCase())) {
          tempList.add(item);
        }
      }
      filteredList = tempList;
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
          knowledgeListGet(context, "", "");
          myFavouriteListGet(context,catId);
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

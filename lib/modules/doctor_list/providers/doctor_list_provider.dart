import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/doctor_list/models/doctor_details_model.dart';
import 'package:animal_market/modules/doctor_list/models/doctor_list_model.dart';
import 'package:animal_market/services/api_service.dart';

class DoctorListProvider extends ChangeNotifier {
  bool isLoading = true;
  bool isLoading1 = true;
  bool noData = false;
  var doctorList = <DoctorListModel>[];
  var filteredList = <DoctorListModel>[];
  DoctorDetailsModel? doctorDetailsModel;

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredList = doctorList;
    } else {
      List<DoctorListModel> tempList = [];
      for (var item in doctorList) {
        if (item.name!.toLowerCase().toString().contains(query.toLowerCase()) || item.name!.toLowerCase().toString().contains(query.toLowerCase())) {
          tempList.add(item);
        }
      }
      filteredList = tempList;
    }
    notifyListeners();
  }

  Future<void> doctorListGet(BuildContext context) async {
    try {
      isLoading = true;
      var result = await ApiService.doctorList();
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading = false;
          doctorList = List<DoctorListModel>.from(json['data'].map((i) => DoctorListModel.fromJson(i))).toList(growable: true);
          filteredList = doctorList;
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

  Future<void> doctorDetailGet(BuildContext context, String doctorId) async {
    try {
      isLoading1 = true;
      var result = await ApiService.doctorDetail(doctorId);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          isLoading1 = false;
          noData = false;
          doctorDetailsModel = DoctorDetailsModel.fromJson(json['data']);
        } else {
          isLoading1 = false;
          noData = true;
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading1 = false;
      noData = true;
      Log.console(e.toString());
    }
    notifyListeners();
  }
}

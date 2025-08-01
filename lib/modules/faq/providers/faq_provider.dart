import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/faq/models/faqs_model.dart';
import 'package:animal_market/services/api_service.dart';

class FaqProvider extends ChangeNotifier {
  var faqsList = <FaqsModel>[];
  bool isLoading = true;
  int selectedIndex = -1;

  void updateIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> faqsGet(BuildContext context) async {
    isLoading = true;
    try {
      var result = await ApiService.faqListApi();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        faqsList = List<FaqsModel>.from(json['data'].map((i) => FaqsModel.fromJson(i))).toList(growable: true);
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
}

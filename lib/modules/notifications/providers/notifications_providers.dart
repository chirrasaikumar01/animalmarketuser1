import 'dart:convert';

import 'package:animal_market/core/constants.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/buy/models/cattle_argument.dart';
import 'package:animal_market/modules/buy_crop/models/crop_argument.dart';
import 'package:animal_market/modules/buy_pet/models/pet_argument.dart';
import 'package:animal_market/modules/category/providers/category_provider.dart';
import 'package:animal_market/modules/community/models/blog_details_argument.dart';
import 'package:animal_market/modules/know_education/model/know_argument.dart';
import 'package:animal_market/modules/know_education/model/knowledge_list_model.dart';
import 'package:animal_market/modules/notifications/models/notification_list_model.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:intl/intl.dart';

class NotificationsProviders extends ChangeNotifier {
  bool isLoading = true;
  var notificationList = <NotificationListModel>[];

  Future<void> notificationListGet(BuildContext context) async {
    try {
      isLoading = true;
      var result = await ApiService.getNotificationList();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        notificationList = List<NotificationListModel>.from(json['data'].map((i) => NotificationListModel.fromJson(i))).toList(growable: true);
        if (context.mounted) {
          Provider.of<CategoryProvider>(context, listen: false).categoryListGet(context,false);
        }
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

  String formatDate(String date) {
    try {
      var parsedDate = DateFormat("yyyy-MM-dd").parse(date);
      var formattedDate = DateFormat("dd-MMM-yyyy").format(parsedDate);
      return formattedDate;
    } catch (e) {
      return "";
    }
  }
  // Deep link handler for notification URLs
   void handleLink(Uri uri) {
    try {
      Log.console("Deep link received: $uri");
      final segments = uri.pathSegments;
      if (segments.length < 3) {
        Log.console("Invalid deep link structure: $uri");
        return;
      }

      final type = segments[0];
      final catId = segments[1];
      final id = segments[2];
      final context = Constants.navigatorKey.currentState!.context;

      switch (type) {
        case 'Crop':
          Navigator.pushNamed(
            context,
            Routes.marketCropDetails,
            arguments: CropArgument(id: id, categoryId: catId, isUser: false),
          );
          break;

        case 'Cattle':
          Navigator.pushNamed(
            context,
            Routes.marketDetails,
            arguments: CattleArgument(id: id.toString(), isUser: false, categoryId: catId),
          );
          break;

        case 'Pet':
          Navigator.pushNamed(
            context,
            Routes.petMarketDetails,
            arguments: PetArgument(id: id, isUser: false, categoryId: catId),
          );
          break;

        case 'Blog':
          Navigator.pushNamed(
            context,
            Routes.communityDetails,
            arguments: BlogDetailsArgument(id: id, categoryId: catId, isEdit: false),
          );
          break;

        case 'Knowledge':
          final knowledgeData = KnowledgeListData(id: int.parse(id), catId: int.parse(catId));
          Navigator.pushNamed(
            context,
            Routes.knowEducationDetails,
            arguments: KnowArgument(knowledgeListData: knowledgeData),
          );
          break;

        default:
          Log.console("Unknown deep link path: $type");
      }
    } catch (e) {
      Log.console("Error handling deep link: $e");
    }
  }
}

import 'package:animal_market/core/constants.dart';
import 'package:animal_market/modules/buy/models/cattle_argument.dart';
import 'package:animal_market/modules/buy_crop/models/crop_argument.dart';
import 'package:animal_market/modules/buy_pet/models/pet_argument.dart';
import 'package:animal_market/modules/community/models/blog_details_argument.dart';
import 'package:animal_market/modules/know_education/model/know_argument.dart';
import 'package:animal_market/modules/know_education/model/knowledge_list_model.dart';
import 'package:animal_market/modules/other_seller_profile/models/other_seller_arguments.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_logs.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();

  factory DeepLinkService() => _instance;

  DeepLinkService._internal();

  //adb shell am start -a android.intent.action.VIEW -d "https://animalmarket.in/Cattle/0/10"
  final AppLinks appLinks = AppLinks();
  static const String _lastHandledLinkKey = 'last_handled_link';

  /// Initialize deep link listening
  void init() async {
    final Uri? initialLink = await appLinks.getInitialLink();
    if (initialLink != null) {
      Log.console("Initial deep link: $initialLink");
      await handleLink(initialLink);
    }

    appLinks.uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        Log.console("Stream deep link received: $uri");
        await handleLink(uri);
      }
    });
  }

  /// Handle deep link by navigating if not already handled
  Future<void> handleLink(Uri uri) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? lastHandledLink = prefs.getString(_lastHandledLinkKey);
      String currentLink = uri.toString();

      Log.console("[DeepLinkService] Received deep link: $currentLink");
      Log.console("[DeepLinkService] Last handled deep link: $lastHandledLink");

      // Skip if this deep link was already handled previously
      if (lastHandledLink == currentLink) {
        Log.console("[DeepLinkService] Deep link already handled before, skipping navigation.");
        return;
      }

      // Save the current deep link as handled
      bool saved = await prefs.setString(_lastHandledLinkKey, currentLink);
      Log.console("[DeepLinkService] Saved new last handled link: $saved");

      final segments = uri.pathSegments;
      if (segments.length < 3) {
        Log.console("[DeepLinkService] Invalid deep link structure: $uri");
        return;
      }

      final type = segments[0];
      final catId = segments[1];
      final id = segments[2];
      var context = Constants.navigatorKey.currentState?.context;

      if (context == null) {
        Log.console("[DeepLinkService] Navigator context is null, cannot navigate.");
        return;
      }

      Log.console("[DeepLinkService] Navigating to page for type: $type, catId: $catId, id: $id");

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
        case 'Seller':
          Navigator.pushNamed(
            context,
            Routes.otherSellerProfile,
            arguments: OtherSellerArguments(id: id),
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
          Log.console("[DeepLinkService] Unknown deep link path: $type");
      }
    } catch (e) {
      Log.console("[DeepLinkService] Error handling deep link: $e");
    }
  }

  /// Optional: clear stored last handled link if needed
  Future<void> clearLastHandledLink() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastHandledLinkKey);
    Log.console("Cleared last handled deep link.");
  }

  /// Generate deep link string by type
  String generateDeePLink(String catId, String id, String type) {
    switch (type) {
      case 'Crop':
        return "${ApiUrl.severUrl}/Crop/$catId/$id";
      case 'Cattle':
        return "${ApiUrl.severUrl}/Cattle/$catId/$id";
      case 'Pet':
        return "${ApiUrl.severUrl}/Pet/$catId/$id";
      case 'Blog':
        return "${ApiUrl.severUrl}/Blog/$catId/$id";
      case 'Knowledge':
        return "${ApiUrl.severUrl}/Knowledge/$catId/$id";
      case 'Seller':
        return "${ApiUrl.severUrl}/Seller/$catId/$id";
      default:
        Log.console("Unknown deep link type: $type");
        return "";
    }
  }
}

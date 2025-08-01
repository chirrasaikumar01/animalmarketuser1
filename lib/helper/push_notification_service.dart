// ignore_for_file: unused_local_variable

import 'package:animal_market/core/color_constant.dart';
import 'package:animal_market/core/constants.dart';
import 'package:animal_market/modules/buy/models/cattle_argument.dart';
import 'package:animal_market/modules/buy_crop/models/crop_argument.dart';
import 'package:animal_market/modules/buy_pet/models/pet_argument.dart';
import 'package:animal_market/modules/community/models/blog_details_argument.dart';
import 'package:animal_market/modules/know_education/model/know_argument.dart';
import 'package:animal_market/modules/know_education/model/knowledge_list_model.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_logs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Add this

class PushNotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? selectedChatter;

  static void updateSelectedChatter(String? chatter) {
    selectedChatter = chatter;
  }

  static Future<String?> getFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (e) {
      Log.console(e);
    }
    return null;
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    Log.console('Got a message in the foreground!');
    Log.console('Message data: ${message.data}');
    Log.console('Message body: ${message.notification?.body}');
    Log.console('Message title: ${message.notification?.title}');
    showNotification(message);
    _handleNotification(message, true);
    _fetchUserNotifications();
  }

  static void _handleNotification(RemoteMessage message, bool foreground) {
    try {
      final context = Constants.navigatorKey.currentState?.context;
      // Additional handling can go here
    } catch (e) {
      Log.console('Error processing incoming call: $e');
    }
  }

  static void showNotification(RemoteMessage message) {
    final context = Constants.navigatorKey.currentState?.context;
    if (context != null) {
      if (message.notification != null &&
          PushNotificationService.selectedChatter != message.notification!.title) {
        final title = message.notification!.title ?? "";
        final body = message.notification!.body ?? "New Message Received!";
        final url = message.data['url'];
        showSimpleNotification(
          GestureDetector(
            onTap: () {
              if (url != null) {
                final uri = Uri.tryParse(url);
                if (uri != null) {
                  handleLink(uri);
                } else {
                  Log.console("Invalid URL format: $url");
                }
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                border: Border.all(color: ColorConstant.borderCl),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          background: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        );
      }
    } else {
      Log.console('Context is null, unable to show notification UI.');
    }
  }

  static void _fetchUserNotifications() {
    try {
      // Integrate with your user provider
    } catch (e) {
      Log.console('Error fetching user notifications or details: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    Log.console('Got a message in the background!');
    Log.console('Message data: ${message.data}');
    Log.console("Handling a background message: ${message.messageId}");

    _handleNotification(message, false);

    final url = message.data['url'];
    if (url != null) {
      final uri = Uri.tryParse(url);
      if (uri != null) {
        handleLink(uri);
      }
    }
  }

  static Future<void> _handleAppOpen(RemoteMessage message) async {
    Log.console("FirebaseMessaging.onMessageOpenedApp.listen");
    final url = message.data['url'];
    if (url != null) {
      final uri = Uri.tryParse(url);
      if (uri != null) {
        handleLink(uri);
      }
    }
  }

  void registerNotification({bool isAnon = false, required String userId}) async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> init(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final prefs = await SharedPreferences.getInstance(); // ✅

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // ✅ Prevent duplicate navigation on app restart
    bool alreadyHandled = prefs.getBool('initial_message_handled') ?? false;
    if (!alreadyHandled) {
      RemoteMessage? initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        await prefs.setBool('initial_message_handled', true); // ✅ Mark as handled
        _handleAppOpen(initialMessage);
      }
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) => _handleAppOpen(message));
  }

  // ✅ Deep link handler
  static void handleLink(Uri uri) {
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

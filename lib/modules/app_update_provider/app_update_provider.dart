import 'dart:convert';
import 'dart:io';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/app_update_provider/app_download_dialog.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateProvider extends ChangeNotifier {
  bool isLoading = false;
  bool noData = false;
  String version = "";
  String appVersion = "";
  String appFile = "";

  Future<void> appDownload(BuildContext context) async {
    checkVersion();
    try {
      var result = await ApiService.appDownload();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        appVersion = json["data"]["app_version"].toString();
        Log.console("appVersion => $appVersion");
        appFile = json["data"]["app_download_link"].toString();
        if (version.toString() != appVersion.toString()) {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return const Dialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: AppDownloadDialog(),
                );
              },
            );
          }
        }
      } else {
        Log.console(json["status"].toString());
      }
    } catch (e) {
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    Log.console("version => $version");
    Log.console(buildNumber);
  }

  Future<void> checkForUpdate(BuildContext context) async {
    if (Platform.isAndroid) {
      try {
        final updateInfo = await InAppUpdate.checkForUpdate();
        if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
          if (updateInfo.immediateUpdateAllowed) {
            await InAppUpdate.performImmediateUpdate();
          } else if (updateInfo.flexibleUpdateAllowed) {
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          }
        }
      } catch (e) {
        debugPrint("Android update error: $e");
        if (context.mounted) {
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: const Text('Update Available'),
              content: const Text('Please download the latest version from the Play Store.'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  onPressed: () async {
                    const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.animal_market';
                    if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
                      await launchUrl(Uri.parse(playStoreUrl), mode: LaunchMode.externalApplication);
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          );
        }
      }
    } else if (Platform.isIOS) {
      await _checkIOSAppStoreVersion(context);
    }
  }

  Future<void> _checkIOSAppStoreVersion(BuildContext context) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      const appStoreID = 'id1234567890';
      final url = 'https://itunes.apple.com/lookup?bundleId=com.animal_market';
      final response = await HttpClient().getUrl(Uri.parse(url)).then((req) => req.close());
      final json = await response.transform(const Utf8Decoder()).join();
      final versionMatch = RegExp(r'"version":"([\d.]+)"').firstMatch(json);
      final storeVersion = versionMatch?.group(1);
      if (storeVersion != null && storeVersion != currentVersion) {
        if (context.mounted) {
          _showIOSUpdateDialog(context, appStoreID);
        }
      }
    } catch (e) {
      debugPrint("iOS update check failed: $e");
    }
  }

  void _showIOSUpdateDialog(BuildContext context, String appStoreID) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Update Available'),
          content: const Text(
            'A newer version of the app is available. Please update now.',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Later'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                final url = 'https://apps.apple.com/app/$appStoreID';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

}

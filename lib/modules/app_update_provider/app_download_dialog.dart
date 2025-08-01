import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/app_update_provider/app_update_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';


class AppDownloadDialog extends StatefulWidget {
  const AppDownloadDialog({super.key});

  @override
  State<AppDownloadDialog> createState() => _AppDownloadDialogState();
}

class _AppDownloadDialogState extends State<AppDownloadDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppUpdateProvider>(builder: (context, state, child) {
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    ImageConstant.downloadLottiIc,
                    height: 158.h,
                    width: 158.w,
                  ),
                  TText(keyName:
                    pleaseUpdate,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: FontsStyle.medium,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  TText(keyName:
                    "$newAppVersion ${state.appVersion}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: FontsStyle.medium,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 47.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 11.h),
                          decoration: const BoxDecoration(color: Color(0xFFF1F1F1), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20))),
                          child: CustomButtonWidget(
                            style: CustomButtonStyle.style2,
                            onPressed: () async {
                              openUrl(state.appFile);
                            },
                            text: downloadNow,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      });
    });
  }

  Future<void> openUrl(String url) async {
    final encodedUrl = Uri.encodeFull(url.trim());
    final uri = Uri.parse(encodedUrl);
    Log.console("Attempting to open: ${uri.toString()}");
    try {
      if (await canLaunchUrl(uri)) {
        Log.console("canLaunchUrl returned true for: ${uri.toString()}");
        final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          Log.console("Failed to open URL with external application. Trying in-app view.");
          await launchUrl(uri, mode: LaunchMode.inAppWebView);
        } else {
          Log.console("Successfully launched URL: ${uri.toString()}");
        }
      } else {
        Log.console("canLaunchUrl returned false for: ${uri.toString()}");
        if(mounted){
          errorToast(context, "Cannot launch URL.");
        }
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
      if(mounted){
        errorToast(context, "An error occurred while opening the URL.");
      }

    }
  }
}

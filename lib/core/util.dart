// ignore_for_file: deprecated_member_use


import 'package:animal_market/core/export_file.dart';

void showToast(BuildContext context, String msg, Color bgColor, Color textColor) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 10,
      right: 10,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  msg,
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

void successToast(BuildContext context, String msg) {
  showToast(context, msg, Colors.green, Colors.white);
}

void errorToast(BuildContext context, String msg) {
  showToast(context, msg, Colors.red, Colors.white);
}

void showProgress(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: ColorConstant.white.withOpacity(0.05),
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150.h,
              width: 150.w,
              padding: EdgeInsets.all(50.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const CircularProgressIndicator(
                color: ColorConstant.appCl,
              ),
            ),
          ],
        ),
      );
    },
  );
}

void closeProgress(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

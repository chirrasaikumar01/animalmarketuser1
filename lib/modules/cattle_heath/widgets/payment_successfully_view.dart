import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/export_file.dart';

class PaymentSuccessfullyView extends StatefulWidget {
  const PaymentSuccessfullyView({super.key});

  @override
  State<PaymentSuccessfullyView> createState() => _PaymentSuccessfullyViewState();
}

class _PaymentSuccessfullyViewState extends State<PaymentSuccessfullyView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80.h, width: MediaQuery.of(context).size.width),
              Image.asset(
                ImageConstant.doneIc,
                height: 126.h,
                width: 126.w,
              ),
              SizedBox(height: 27.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.dm),
                  border: Border.all(color: ColorConstant.borderCl),
                  color: ColorConstant.white,
                ),
                child: TText(keyName:
                  "thankYou",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.textDarkCl,
                    fontFamily: FontsStyle.medium,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TText(keyName:
                "yourPaymentIsSuccessfullyDone",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.appCl,
                  fontFamily: FontsStyle.medium,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: 17.h),
              TText(keyName:
                "waitForReportFromDoctor",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.textDarkCl,
                  fontFamily: FontsStyle.medium,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: 17.h),
              SizedBox(height: 17.h),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: ColorConstant.black.withValues(alpha:0.25),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 0),
            ),
          ], color: ColorConstant.white),
          child: Wrap(
            children: [
              CustomButtonWidget(
                style: CustomButtonStyle.style2,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "backToHome",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

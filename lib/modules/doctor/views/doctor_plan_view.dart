import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/doctor/providers/doctor_provider.dart';

class DoctorPlanView extends StatefulWidget {
  const DoctorPlanView({super.key});

  @override
  State<DoctorPlanView> createState() => _DoctorPlanViewState();
}

class _DoctorPlanViewState extends State<DoctorPlanView> {
  late DoctorProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<DoctorProvider>();
      provider.subscriptionPlanList(context);
      provider.initRazorPay();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0XFFBFE8CA), Color(0XFFFFFFF6)],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 26.h),
                  Align(
                    alignment: Alignment.center,
                    child: TText(
                      keyName: "chooseYourSubscription",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.textDarkCl,
                        fontFamily: FontsStyle.medium,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 26.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                          itemCount: state.planList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        state.updatePlan(context, state.planList[index]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
                                        decoration: BoxDecoration(
                                          color: state.selectedPlanId == state.planList[index].id.toString() ? ColorConstant.darkAppCl : ColorConstant.white,
                                          border: Border.all(
                                            color: state.selectedPlanId == state.planList[index].id.toString() ? ColorConstant.buttonCl : ColorConstant.borderCl,
                                          ),
                                          borderRadius: BorderRadius.circular(23),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(3.h),
                                              height: 18.h,
                                              width: 18.w,
                                              decoration: BoxDecoration(border: Border.all(color: ColorConstant.buttonCl, width: 1.w), color: ColorConstant.white, shape: BoxShape.circle),
                                              child: Container(
                                                height: 10.h,
                                                width: 10.w,
                                                decoration: BoxDecoration(
                                                  color: state.selectedPlanId == state.planList[index].id.toString() ? ColorConstant.buttonCl : ColorConstant.white,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 9.w),
                                            Expanded(
                                              child: TText(
                                                keyName: state.planList[index].duration.toString().toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: FontsStyle.medium,
                                                  fontStyle: FontStyle.normal,
                                                  color: state.selectedPlanId == state.planList[index].id.toString() ? ColorConstant.buttonCl : ColorConstant.textLightCl,
                                                ),
                                              ),
                                            ),
                                            TText(
                                              keyName: "₹ ${state.planList[index].price ?? ""}",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: FontsStyle.medium,
                                                fontStyle: FontStyle.normal,
                                                color: state.selectedPlanId == state.planList[index].id.toString() ? ColorConstant.buttonCl : ColorConstant.textLightCl,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    state.planList[index].isBestSelling.toString() == "1"
                                        ? Positioned(
                                            top: -10.h,
                                            left: 0,
                                            right: 0,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                    color: ColorConstant.appCl,
                                                    borderRadius: BorderRadius.all(Radius.circular(20.dm)),
                                                    border: Border.all(color: ColorConstant.white, width: 1.w),
                                                  ),
                                                  child: TText(
                                                    keyName: bestSelling,
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: ColorConstant.textDarkCl,
                                                      fontFamily: FontsStyle.semiBold,
                                                      fontStyle: FontStyle.normal,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                    Positioned(
                                        bottom: -22.h,
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 75.w, vertical: 4.h),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(ImageConstant.contBgCrop),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              child: TText(
                                                keyName: "${state.planList[index].duration} per Day Only",
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorConstant.textLightCl,
                                                  fontFamily: FontsStyle.medium,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                                SizedBox(height: 40.h),
                              ],
                            );
                          }),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: TText(
                      keyName: "benefitsOfPlan",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.textDarkCl,
                        fontFamily: FontsStyle.semiBold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                          itemCount: state.planList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      ImageConstant.checkIc,
                                      height: 14.h,
                                      width: 14.w,
                                    ),
                                    SizedBox(width: 10.w),
                                    TText(
                                      keyName: state.planList[index].description ?? "",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF263801),
                                        fontFamily: FontsStyle.medium,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h)
                              ],
                            );
                          }),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.dm),
                        topLeft: Radius.circular(10.dm),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0XFFFFEDD0),
                          ColorConstant.white,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        TText(
                          keyName: "buyASubscription",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.textDarkCl,
                            fontFamily: FontsStyle.semiBold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0XFFF1EE85),
                                      Color(0XFFAE956B),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.dm),
                                ),
                                padding: EdgeInsets.all(1.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.dm),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImageConstant.callNewIc,
                                        height: 20.h,
                                        width: 20.w,
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        children: [
                                          TText(
                                            keyName: "moreCallsWillCome",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstant.textDarkCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          TText(
                                            keyName: "moreCallsWillCome1",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstant.textDarkCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 7.w),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0XFFF1EE85),
                                      Color(0XFFAE956B),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.dm),
                                ),
                                padding: EdgeInsets.all(1.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.dm),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImageConstant.highQualityIc,
                                        height: 20.h,
                                        width: 20.w,
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        children: [
                                          TText(
                                            keyName: "listShowOnTop",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstant.textDarkCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          TText(
                                            keyName: "listShowOnTop1",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstant.textDarkCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 7.w),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0XFFF1EE85),
                                      Color(0XFFAE956B),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.dm),
                                ),
                                padding: EdgeInsets.all(1.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.dm),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImageConstant.verifyIc,
                                        height: 20.h,
                                        width: 20.w,
                                      ),
                                      SizedBox(width: 10.w),
                                  Column(
                                    children: [
                                      TText(
                                        keyName: "verifiedSign",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.textDarkCl,
                                          fontFamily: FontsStyle.regular,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      TText(
                                        keyName: "verifiedSign1",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.textDarkCl,
                                          fontFamily: FontsStyle.regular,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 120.h)
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: ColorConstant.black.withValues(alpha: 0.25),
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
                    if (state.selectedPlanId == "") {
                      errorToast(context, pleasSelectAPlan);
                    } else {
                      state.sendOrderRazor(context);
                    }
                  },
                  text: "",
                  iconWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TText(
                        keyName: "payNow",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      TText(
                        keyName: " ₹ ${state.selectedPlanPrice}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

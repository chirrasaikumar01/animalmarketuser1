import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/cattle_heath/providers/cattle_health_provider.dart';

class PaymentReportView extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PaymentReportView({super.key, required this.onNext, required this.onPrevious});

  @override
  State<PaymentReportView> createState() => _PaymentReportViewState();
}

class _PaymentReportViewState extends State<PaymentReportView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CattleHealthProvider>(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: ColorConstant.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 12.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.darkAppCl,
                      borderRadius: BorderRadius.circular(7.dm),
                      border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TText(
                                    keyName: "selectedPlan",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.white,
                                      fontFamily: FontsStyle.semiBold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  SizedBox(height: 14.h),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(3.w),
                                        height: 18.h,
                                        width: 18.w,
                                        decoration: BoxDecoration(border: Border.all(color: ColorConstant.buttonCl, width: 1.w), color: ColorConstant.white, shape: BoxShape.circle),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ColorConstant.buttonCl,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: TText(
                                          keyName: state.selectedPlan?.title ?? "",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant.white,
                                            fontFamily: FontsStyle.medium,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              ImageConstant.priceMultiIc,
                              height: 60.h,
                              width: 60.w,
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 43.w, vertical: 14.w),
                          decoration: BoxDecoration(
                            color: ColorConstant.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.dm),
                              topLeft: Radius.circular(10.dm),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TText(
                                keyName: "pay",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.medium,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              TText(
                                keyName: " ₹ ${state.selectedPlan?.price}",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.medium,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TText(
                    keyName: "benefitForYou",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.textDarkCl,
                      fontFamily: FontsStyle.semiBold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  ListView.builder(
                      itemCount: state.planList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var item = state.planList[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  ImageConstant.checkIc,
                                  height: 16.h,
                                  width: 16.w,
                                ),
                                SizedBox(width: 10.w),
                                TText(
                                  keyName: item.description ?? "",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF7A7A7A),
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h)
                          ],
                        );
                      }),
                  SizedBox(height: 12.h),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(9.dm),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(13.dm),
                      border: Border.all(color: ColorConstant.borderCl),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TText(
                          keyName: "paymentDetails",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.textDarkCl,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  ImageConstant.billIc,
                                  height: 16.h,
                                  width: 16.w,
                                ),
                                SizedBox(width: 9.w),
                                TText(
                                  keyName: "fees",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF5F5F5F),
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                            TText(
                              keyName: "₹ ${state.selectedPlan?.price}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.textLightCl,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Divider(color: ColorConstant.borderCl, height: 1.h),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  ImageConstant.gstIc,
                                  height: 16.h,
                                  width: 16.w,
                                ),
                                SizedBox(width: 9.w),
                                TText(
                                  keyName: "gST",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF5F5F5F),
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                            TText(
                              keyName: "₹ ${state.selectedPlan?.gst}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.textLightCl,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Divider(color: ColorConstant.borderCl, height: 1.h),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TText(
                              keyName: "totalFee",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            TText(
                              keyName: "₹ ${int.parse(state.selectedPlan!.price!) + int.parse(state.selectedPlan!.gst ?? "0")}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Accept ",
                        style: TextStyle(
                          color: ColorConstant.textDarkCl,
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                        children: [
                          TextSpan(
                            text: "T&C ",
                            style: TextStyle(
                              color: ColorConstant.appCl,
                              fontWeight: FontWeight.w400,
                              fontSize: 10.sp,
                              fontFamily: FontsStyle.regular,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 120.h),
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
                  onPressed: () async {
                    await state.sendOrderRazor(context);
                  },
                  text: "",
                  iconWidget: TText(
                    keyName: "payNow",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.textDarkCl,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

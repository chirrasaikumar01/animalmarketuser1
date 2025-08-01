import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/buy/models/seller_model.dart';

class SellProfileContainer extends StatefulWidget {
  final Seller seller;
  final String totalListed;
  final String totalCallsReceived;
  final String totalViewsReceived;

  const SellProfileContainer({super.key, required this.seller, required this.totalListed, required this.totalCallsReceived, required this.totalViewsReceived});

  @override
  State<SellProfileContainer> createState() => _SellProfileContainerState();
}

class _SellProfileContainerState extends State<SellProfileContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(8.dm),
        border: Border.all(
          color: ColorConstant.darkAppCl,
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: ColorConstant.darkAppCl,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10.dm),
                      bottomLeft: Radius.circular(10.dm),
                    ),
                    border: Border.all(
                      color: ColorConstant.darkAppCl,
                      width: 1.w,
                    ),
                  ),
                  child: TText(keyName:
                    "sellerIncompleteProfile",
                    style: TextStyle(
                      color: ColorConstant.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                SizedBox(width: 50.w),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 10.h,
                    borderRadius: BorderRadius.circular(20.dm),
                    backgroundColor: ColorConstant.grayCl,
                    valueColor: const AlwaysStoppedAnimation(
                      ColorConstant.appCl,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 11.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.dm),
                  child: Image.asset(
                    ImageConstant.demoUserImg,
                    height: 47.h,
                    width: 47.w,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TText(keyName:
                        widget.seller.name ?? "",
                        style: TextStyle(
                          color: ColorConstant.textDarkCl,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          TText(keyName:
                          "memberId",
                            style: TextStyle(
                              color: ColorConstant.textLightCl,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          TText(keyName:
                            " : ${widget.seller.memberId ?? ""}",
                            style: TextStyle(
                              color: ColorConstant.textLightCl,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  ImageConstant.arrowCircleIc,
                  height: 30.h,
                  width: 30.w,
                ),
              ],
            ),
          ),
          SizedBox(height: 11.h),
          Divider(
            color: ColorConstant.borderCl,
            height: 1.h,
          ),
          SizedBox(height: 11.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(6.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(6.dm),
                      border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              ImageConstant.dogHouseIc,
                              height: 20.h,
                              width: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            TText(keyName:
                              widget.totalListed,
                              style: TextStyle(
                                color: ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        TText(keyName:
                          "animalListed",
                          style: TextStyle(
                            color: ColorConstant.gray1Cl,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(6.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(6.dm),
                      border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              ImageConstant.telephoneCallIc,
                              height: 20.h,
                              width: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            TText(keyName:
                              widget.totalCallsReceived,
                              style: TextStyle(
                                color: ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        TText(keyName:
                          "callsReceived",
                          style: TextStyle(
                            color: ColorConstant.gray1Cl,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(6.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(6.dm),
                      border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              ImageConstant.eyeIc,
                              height: 20.h,
                              width: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            TText(keyName:
                              widget.totalViewsReceived,
                              style: TextStyle(
                                color: ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        TText(keyName:
                          "views",
                          style: TextStyle(
                            color: ColorConstant.gray1Cl,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

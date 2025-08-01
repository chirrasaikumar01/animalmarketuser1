import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/cattle_heath/providers/cattle_health_provider.dart';
import 'package:animal_market/modules/sell/widgets/benefits_of_selling_container.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CattleHeathStatusView extends StatefulWidget {
  const CattleHeathStatusView({super.key});

  @override
  State<CattleHeathStatusView> createState() => _CattleHeathStatusViewState();
}

class _CattleHeathStatusViewState extends State<CattleHeathStatusView> {
  late CattleHealthProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = context.read<CattleHealthProvider>();
      provider.healthReportHome(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CattleHealthProvider>(builder: (context, state, child) {
      return Scaffold(
        backgroundColor: ColorConstant.white,
        body: Builder(
          builder: (context) {
            if (state.isLoading) {
              return LoaderClass(height: double.infinity);
            }
            if (state.noData) {
              return NoDataClass(
                height: double.infinity,
                text: "noDataFound",
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                return await state.healthReportHome(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      TText(keyName:
                        "knowYourCattleHeathStatus",
                        style: TextStyle(
                          color: ColorConstant.appCl,
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Visibility(
                        visible: state.bannerList.isEmpty ? false : true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: ColorConstant.white,
                                borderRadius: BorderRadius.circular(13.dm),
                              ),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: CarouselSlider(
                                        carouselController: state.carouselSliderController,
                                        options: CarouselOptions(
                                          aspectRatio: 16 / 6.9,
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          viewportFraction: 1,
                                          padEnds: false,
                                          pauseAutoPlayOnTouch: true,
                                          enableInfiniteScroll: false,
                                          onPageChanged: (index, reason) {
                                            state.updateIndexBanner(index);
                                          },
                                        ),
                                        items: List.generate(
                                          state.bannerList.length,
                                          (ind) => Container(
                                            height: 140.h,
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.dm),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.dm),
                                              child: CustomImage(
                                                placeholderAsset: ImageConstant.bannerImg,
                                                errorAsset: ImageConstant.bannerImg,
                                                radius: 10.dm,
                                                imageUrl: state.bannerList[ind].image,
                                                baseUrl: ApiUrl.imageUrl,
                                                height: 140.h,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4.h,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4.dm),
                                            color: ColorConstant.darkAppCl.withValues(alpha:0.30),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(
                                              state.bannerList.length,
                                              (ind) => Container(
                                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                                height: 6.h,
                                                width: 6.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.dm),
                                                  color: ind == state.selectedIndex ? ColorConstant.textDarkCl : Colors.transparent,
                                                  border: Border.all(
                                                    color: ind == state.selectedIndex ? ColorConstant.textDarkCl : ColorConstant.white,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.scanNow);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: ColorConstant.darkAppCl,
                            borderRadius: BorderRadius.circular(10.dm),
                            boxShadow: [
                              BoxShadow(
                                color: ColorConstant.black.withValues(alpha:0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    ImageConstant.qrCodeIc,
                                    height: 24.h,
                                    width: 24.w,
                                  ),
                                  SizedBox(width: 16.w),
                                  TText(keyName:
                                    "scanNow",
                                    style: TextStyle(
                                      color: ColorConstant.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                ImageConstant.arrowCircleIc,
                                height: 24.h,
                                width: 24.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      const BenefitsOfSellingContainer(),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TText(keyName:
                            "myReports",
                            style: TextStyle(
                              color: ColorConstant.textDarkCl,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.myReport);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.borderCl,
                                borderRadius: BorderRadius.circular(4.dm),
                              ),
                              child: Row(
                                children: [
                                  TText(keyName:
                                    "seeAll",
                                    style: TextStyle(
                                      color: ColorConstant.textDarkCl,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Image.asset(
                                    ImageConstant.arrowForwardIc,
                                    height: 16.h,
                                    width: 10.w,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Builder(builder: (context) {
                        if (state.myReport.isEmpty) {
                          return NoDataClass(
                            height: 300.h,
                            text: noReportFound,
                          );
                        }
                        return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: state.myReport.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              var item = state.myReport[index];
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                                margin: EdgeInsets.only(bottom: 11.h),
                                decoration: BoxDecoration(
                                  border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                                  borderRadius: BorderRadius.circular(10.dm),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            TText(keyName:
                                            "reportId",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstant.textLightCl,
                                                fontFamily: FontsStyle.regular,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                            TText(keyName:
                                              " : ${item.uniqueCode}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstant.textLightCl,
                                                fontFamily: FontsStyle.regular,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            TText(keyName:
                                            "transactionId",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstant.textLightCl,
                                                fontFamily: FontsStyle.regular,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                            TText(keyName:
                                              ": ${item.transactionId}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstant.textLightCl,
                                                fontFamily: FontsStyle.regular,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Divider(color: ColorConstant.borderCl, height: 1.h),
                                    SizedBox(height: 10.h),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 7.h),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1F1F1),
                                        borderRadius: BorderRadius.circular(4.dm),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TText(keyName:
                                            "noteByYou",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: ColorConstant.textDarkCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          TText(keyName:
                                            "${item.moreInfo}",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: ColorConstant.textLightCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            TText(keyName:
                                            "payment",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstant.textDarkCl,
                                                fontFamily: FontsStyle.regular,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                            TText(keyName:
                                              " ₹ ${item.totalFees}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstant.textDarkCl,
                                                fontFamily: FontsStyle.regular,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (item.document != "")
                                          GestureDetector(
                                            onTap: () {
                                              state.downloadPdf1(context, "${ApiUrl.imageUrl}${item.document}");
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                              decoration: BoxDecoration(color: ColorConstant.appCl, borderRadius: BorderRadius.circular(4.dm)),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    ImageConstant.downloadIc,
                                                    height: 24.h,
                                                    width: 24.w,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  TText(keyName:
                                                    "downLoadReport",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: ColorConstant.white,
                                                      fontFamily: FontsStyle.regular,
                                                      fontStyle: FontStyle.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/media_preview_util.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/common_widgets/player_widget.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/helper/deep_link_service.dart';
import 'package:animal_market/helper/share_service.dart';
import 'package:animal_market/modules/buy_crop/models/crop_argument.dart';
import 'package:animal_market/modules/category/models/banners_model.dart';
import 'package:animal_market/modules/community/widgets/show_more_text.dart';
import 'package:animal_market/modules/market/providers/market_provider.dart';
import 'package:animal_market/modules/other_seller_profile/models/other_seller_arguments.dart';
import 'package:animal_market/modules/other_seller_profile/providers/other_seller_profile_provider.dart';
import 'package:animal_market/modules/sell/views/add_sell_products_view.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class CropMarketDetailsView extends StatefulWidget {
  final CropArgument argument;

  const CropMarketDetailsView({
    super.key,
    required this.argument,
  });

  @override
  State<CropMarketDetailsView> createState() => _CropMarketDetailsViewState();
}

class _CropMarketDetailsViewState extends State<CropMarketDetailsView> {
  late MarketProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<MarketProvider>();
      provider.initAudioServices();
      provider.cropDetail(context, widget.argument.id);
      provider.bannerList.add(BannersModel(image: ImageConstant.bannerImg));
      provider.bannerList.add(BannersModel(image: ImageConstant.bannerImg));
      provider.bannerList.add(BannersModel(image: ImageConstant.bannerImg));
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading3 = true;
    provider.resetPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(
                title: "cropMarketplace",
                action:state.noData1||state.isLoading3?SizedBox(): GestureDetector(
                  onTap: (){
                    final link = DeepLinkService().generateDeePLink(state.cropDetailModel!.subCategoryId.toString(), state.cropDetailModel!.id.toString(), "Crop");
                    final imageUrl = state.cropDetailModel?.cropImages != null && state.cropDetailModel!.cropImages!.isNotEmpty&&state.cropDetailModel!.cropImages![0].type=="Image"
                        ? state.cropDetailModel!.cropImages![0].image
                        : "";

                    if (link.isNotEmpty) {
                      ShareService.shareProduct(
                        title: state.cropDetailModel?.title ?? "",
                        imageUrl:"${ApiUrl.imageUrl}${imageUrl??" "}",
                        link: link,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(4.dm),
                      border: Border.all(color: ColorConstant.borderCl),
                    ),
                    child: Image.asset(
                      ImageConstant.shareLineIc,
                      height: 22.h,
                      width: 22.w,
                      color: ColorConstant.appCl,
                    ),
                  ),
                ),
              ),
            ),
            body: Builder(builder: (context) {
              if (state.isLoading3) {
                return LoaderClass(height: double.infinity);
              }
              if (state.noData1) {
                return NoDataClass(
                  height: double.infinity,
                  text: "noDataFound",
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 14.h),
                      Visibility(
                        visible: state.cropImages.isNotEmpty,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstant.white,
                            border: Border.all(color: ColorConstant.appCl, width: 1.w),
                            borderRadius: BorderRadius.circular(10.dm),
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
                                      autoPlay: false,
                                      enlargeCenterPage: false,
                                      viewportFraction: 1,
                                      padEnds: false,
                                      pauseAutoPlayOnTouch: true,
                                      enableInfiniteScroll: false,
                                      onPageChanged: (index, reason) {
                                        state.updateIndexBanner(index);
                                      },
                                    ),
                                    items: state.cropImages.map((image) {
                                      return GestureDetector(
                                        onTap: () {
                                          MediaPreviewUtil.showMediaPreviewDialog(
                                            context,
                                            image: image.image ?? "",
                                            isVideo: image.type == "Video",
                                          );
                                        },
                                        child:Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.dm),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child:  image.type == "Video"
                                              ? ClipRRect(
                                            borderRadius: BorderRadius.circular(10.dm),
                                            child: TikTokVideoPlayer(videoUrl:  "${ApiUrl.imageUrl}${image.image ?? " "}",),
                                          )
                                              : CustomImage(
                                            placeholderAsset: ImageConstant.bannerImg,
                                            errorAsset: ImageConstant.bannerImg,
                                            radius: 10.dm,
                                            imageUrl: image.image ?? "",
                                            baseUrl: ApiUrl.imageUrl,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 6.h,
                                left: 15.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.dm),
                                        color: ColorConstant.darkAppCl.withValues(alpha: 0.30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          state.cropImages.length,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TText(keyName:
                        state.cropDetailModel?.title ?? "",
                        style: TextStyle(
                          color: ColorConstant.textDarkCl,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          fontFamily: FontsStyle.semiBold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: ColorConstant.appCl,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14.sp,
                              color: ColorConstant.white,
                            ),
                            SizedBox(width: 3.w),
                            TText(
                              keyName: state.cropDetailModel?.postedAgo ?? "",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorConstant.white,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: ColorConstant.borderCl,
                              borderRadius: BorderRadius.circular(6.dm),
                              border: Border.all(color: ColorConstant.borderCl),
                            ),
                            child: TText(keyName:
                              "₹${state.cropDetailModel?.price ?? ""}",
                              style: TextStyle(
                                color: ColorConstant.darkAppCl,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          SizedBox(width: 7.w),
                          TText(keyName:
                            state.cropDetailModel?.isNegotiable == 1 ? priceNegotiable : "",
                            style: TextStyle(
                              color: ColorConstant.gray1Cl,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              fontFamily: FontsStyle.semiBold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImageConstant.locationFillIc,
                            height: 14.h,
                            width: 14.w,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: TText(keyName:
                              state.cropDetailModel?.address ?? "",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.textLightCl,
                                fontFamily: FontsStyle.regular,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      TText(keyName:
                        "moreInformation",
                        style: TextStyle(
                          color: ColorConstant.appCl,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          fontFamily: FontsStyle.semiBold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Column(
                        children: [
                          state.cropDetailModel?.farmingType != null && state.cropDetailModel?.farmingType != ""
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: TText(keyName:
                                        "farmingType",
                                        style: TextStyle(
                                          color: ColorConstant.textLightCl,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    TText(keyName:
                                      ":",
                                      style: TextStyle(
                                        color: ColorConstant.textDarkCl,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Expanded(
                                      child: TText(keyName:
                                        state.cropDetailModel?.farmingType ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: ColorConstant.textDarkCl,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          state.cropDetailModel?.farmingType != null && state.cropDetailModel?.farmingType != "" ? SizedBox(height: 14.h) : SizedBox(),
                          Row(
                            children: [
                              Expanded(
                                child: TText(keyName:
                                  "quantity",
                                  style: TextStyle(
                                    color: ColorConstant.textLightCl,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              TText(keyName:
                                ":",
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  fontFamily: FontsStyle.semiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Expanded(
                                child: TText(keyName:
                                  "${state.cropDetailModel?.quantity ?? ""} ${state.cropDetailModel?.quantityType ?? ""}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorConstant.textDarkCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: TText(keyName:
                                  "cropCondition",
                                  style: TextStyle(
                                    color: ColorConstant.textLightCl,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              TText(keyName:
                                ":",
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  fontFamily: FontsStyle.semiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Expanded(
                                child: TText(keyName:
                                  state.cropDetailModel?.cropCondition ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorConstant.textDarkCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: TText(keyName:
                                  "verifyStatus",
                                  style: TextStyle(
                                    color: ColorConstant.textLightCl,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              TText(keyName:
                                ":",
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  fontFamily: FontsStyle.semiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Expanded(
                                child: TText(keyName:
                                  state.cropDetailModel?.verifyStatus ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorConstant.textDarkCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: TText(keyName:
                                  "storageCondition",
                                  style: TextStyle(
                                    color: ColorConstant.textLightCl,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              TText(keyName:
                                ":",
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  fontFamily: FontsStyle.semiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Expanded(
                                child: TText(keyName:
                                  state.cropDetailModel?.storageCondition ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorConstant.textDarkCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          state.cropDetailModel?.isOrganic == 1
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: TText(keyName:
                                       "cropOrganic",
                                        style: TextStyle(
                                          color: ColorConstant.textLightCl,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    TText(keyName:
                                      ":",
                                      style: TextStyle(
                                        color: ColorConstant.textDarkCl,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Expanded(
                                      child: TText(keyName:
                                        "yes",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: ColorConstant.textDarkCl,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: TText(keyName:
                                        "cropOrganic",
                                        style: TextStyle(
                                          color: ColorConstant.textLightCl,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    TText(keyName:
                                      ":",
                                      style: TextStyle(
                                        color: ColorConstant.textDarkCl,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Expanded(
                                      child: TText(keyName:
                                        "no",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: ColorConstant.textDarkCl,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 14.h),
                          state.cropDetailModel?.cropQuality != null && state.cropDetailModel?.cropQuality != ""
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: TText(keyName:
                                        "qualityTested",
                                        style: TextStyle(
                                          color: ColorConstant.textLightCl,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    TText(keyName:
                                      ":",
                                      style: TextStyle(
                                        color: ColorConstant.textDarkCl,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Expanded(
                                      child: TText(keyName:
                                        state.cropDetailModel?.cropQuality ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: ColorConstant.textDarkCl,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          state.cropDetailModel?.cropQuality != null && state.cropDetailModel?.cropQuality != "" ? SizedBox(height: 14.h) : SizedBox(),
                          state.cropDetailModel?.dryorwet != null && state.cropDetailModel?.dryorwet != ""
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: TText(keyName:
                                        "dryOrWet",
                                        style: TextStyle(
                                          color: ColorConstant.textLightCl,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    TText(keyName:
                                      ":",
                                      style: TextStyle(
                                        color: ColorConstant.textDarkCl,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Expanded(
                                      child: TText(keyName:
                                        state.cropDetailModel?.dryorwet ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: ColorConstant.textDarkCl,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          state.cropDetailModel?.dryorwet != null && state.cropDetailModel?.dryorwet != "" ? SizedBox(height: 14.h) : SizedBox(),
                          Row(
                            children: [
                              Expanded(
                                child: TText(keyName:
                                  "remainingTime",
                                  style: TextStyle(
                                    color: ColorConstant.textLightCl,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              TText(keyName:
                                ":",
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  fontFamily: FontsStyle.semiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Expanded(
                                child: TText(keyName:
                                  "${state.cropDetailModel?.remainTimeToHarvest ?? ""} $years",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorConstant.textDarkCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TText(keyName:
                                      "remainingTimeLeftToHarvest",
                                      style: TextStyle(
                                        color: ColorConstant.textLightCl,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  TText(keyName:
                                    ":",
                                    style: TextStyle(
                                      color: ColorConstant.textDarkCl,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                      fontFamily: FontsStyle.semiBold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  Expanded(
                                    child: TText(keyName:
                                      "${state.cropDetailModel?.remainTimeToHarvest ?? ""}  $months",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorConstant.textDarkCl,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TText(keyName:
                                      "transportationFacility",
                                      style: TextStyle(
                                        color: ColorConstant.textLightCl,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  TText(keyName:
                                    ":",
                                    style: TextStyle(
                                      color: ColorConstant.textDarkCl,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                      fontFamily: FontsStyle.semiBold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  Expanded(
                                    child: TText(keyName:
                                      state.cropDetailModel?.transportationFacility.toString() == "0" ? no : yes,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorConstant.textDarkCl,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                            ],
                          ),
                          SizedBox(height: 14.h),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.white,
                          borderRadius: BorderRadius.circular(10.dm),
                          border: Border.all(color: ColorConstant.borderCl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.borderCl,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.dm),
                                  bottomRight: Radius.circular(10.dm),
                                ),
                                border: Border.all(color: ColorConstant.borderCl),
                              ),
                              child: TText(keyName:
                                "description",
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  fontFamily: FontsStyle.semiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ShowMoreText(
                              description: state.cropDetailModel?.description ?? "",
                              userName: '',
                              tagList: [],
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      state.audioFile!=""?
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.white,
                          borderRadius: BorderRadius.circular(10.dm),
                          border: Border.all(color: ColorConstant.borderCl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.borderCl,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.dm),
                                  bottomRight: Radius.circular(10.dm),
                                ),
                                border: Border.all(color: ColorConstant.borderCl),
                              ),
                              child: TText(keyName:
                              "voiceDescription",
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  fontFamily: FontsStyle.semiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              height: 49,
                              decoration: BoxDecoration(
                                color: ColorConstant.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: ColorConstant.borderCl, width: 1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: state.isPlaying ? WaveAnimation() : Image.asset(ImageConstant.wave, height: 24, fit: BoxFit.fill),),
                                  GestureDetector(
                                    onTap: () async {
                                      state.isPlaying ? state.stopAudio() : state.playAudio();
                                    },
                                    child: state.isPlaying ? const Icon(Icons.stop, size: 24, color: ColorConstant.redCl) : Image.asset(ImageConstant.play, height: 24, width: 24),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ):SizedBox(),
                      SizedBox(height: 20.h),
                      widget.argument.isUser
                          ? SizedBox()
                          : GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.otherSellerProfile,
                                  arguments: OtherSellerArguments(
                                    id: state.cropDetailModel!.seller!.id.toString(),
                                  ));
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: ColorConstant.white,
                                  borderRadius: BorderRadius.circular(10.dm),
                                  border: Border.all(color: ColorConstant.darkAppCl, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: ColorConstant.darkAppCl,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.dm),
                                          bottomRight: Radius.circular(10.dm),
                                        ),
                                      ),
                                      child: TText(keyName:
                                       "sellerInformation",
                                        style: TextStyle(
                                          color: ColorConstant.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.semiBold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 48.h,
                                          width: 48.w,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50.dm),
                                            child: CustomImage(
                                              placeholderAsset: ImageConstant.demoUserImg,
                                              errorAsset: ImageConstant.demoUserImg,
                                              radius: 50.dm,
                                              imageUrl: state.cropDetailModel?.seller?.profile ?? "",
                                              baseUrl: ApiUrl.imageUrl,
                                              height: 48.h,
                                              width: 48.w,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TText(keyName:
                                                state.cropDetailModel?.seller?.name ?? "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: ColorConstant.textDarkCl,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.sp,
                                                  fontFamily: FontsStyle.semiBold,
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
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12.sp,
                                                      fontFamily: FontsStyle.semiBold,
                                                      fontStyle: FontStyle.normal,
                                                    ),
                                                  ),
                                                  TText(keyName:
                                                    " : ${state.cropDetailModel?.seller?.memberId ?? ""}",
                                                    style: TextStyle(
                                                      color: ColorConstant.textLightCl,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12.sp,
                                                      fontFamily: FontsStyle.semiBold,
                                                      fontStyle: FontStyle.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h),
                                    Divider(color: ColorConstant.borderCl),
                                    SizedBox(height: 6.h),
                                    Row(
                                      children: [
                                        Image.asset(
                                          ImageConstant.locationFillIc,
                                          height: 16.h,
                                          width: 16.w,
                                        ),
                                        SizedBox(width: 6.w),
                                        TText(keyName:
                                         "address",
                                          style: TextStyle(
                                            color: ColorConstant.textLightCl,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            fontFamily: FontsStyle.regular,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    TText(keyName:
                                      state.cropDetailModel?.seller?.address ?? "",
                                      style: TextStyle(
                                        color: ColorConstant.textDarkCl,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                ),
                              ),
                          ),

                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              );
            }),
            bottomSheet: state.isLoading3
                ? SizedBox()
                : state.noData1
                    ? SizedBox()
                    : widget.argument.isUser
                        ? SizedBox()
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 17.h),
                            decoration: BoxDecoration(color: Color(0xFFC8DFB3)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24.h,
                                  width: 24.w,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.dm), border: Border.all(color: ColorConstant.darkAppCl, width: 1.w)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24.dm),
                                    child: CustomImage(
                                      placeholderAsset: ImageConstant.demoUserImg,
                                      errorAsset: ImageConstant.demoUserImg,
                                      radius: 24.dm,
                                      imageUrl: state.cropDetailModel?.seller?.profile ?? "",
                                      baseUrl: ApiUrl.imageUrl,
                                      height: 24.h,
                                      width: 24.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: TText(keyName:
                                    state.cropDetailModel?.seller?.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstant.textDarkCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: () async {
                                    var url = "tel:+91${state.cropDetailModel?.seller?.mobile ?? ""}";
                                    if (await launchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                      Provider.of<OtherSellerProvider>(context, listen: false).increaseCallCount("crop", state.cropDetailModel!.id.toString());
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                    margin: EdgeInsets.only(top: 5.h),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.darkAppCl,
                                      borderRadius: BorderRadius.circular(6.dm),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ImageConstant.callIc,
                                          height: 20.h,
                                          width: 20.w,
                                          color: ColorConstant.white,
                                        ),
                                        SizedBox(width: 6.w),
                                        TText(keyName:
                                          "call",
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
                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: () async {
                                    await launchUrl(
                                      Uri.parse("https://wa.me/+91${state.cropDetailModel?.seller?.whatsappNo ?? ""}/?text=Hii..."),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5.h),
                                    child: Image.asset(
                                      ImageConstant.whatsappIc,
                                      height: 28.h,
                                      width: 28.w,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
          ),
        );
      },
    );
  }
}

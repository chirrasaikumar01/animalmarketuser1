import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/media_preview_util.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/common_widgets/player_widget.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/helper/deep_link_service.dart';
import 'package:animal_market/helper/share_service.dart';
import 'package:animal_market/modules/buy/models/cattle_argument.dart';
import 'package:animal_market/modules/buy_crop/models/crop_argument.dart';
import 'package:animal_market/modules/buy_pet/models/pet_argument.dart';
import 'package:animal_market/modules/community/models/blog_details_argument.dart';
import 'package:animal_market/modules/community/widgets/show_more_text.dart';
import 'package:animal_market/modules/full_view_image/views/full_image_view.dart';
import 'package:animal_market/modules/other_seller_profile/models/other_seller_arguments.dart';
import 'package:animal_market/modules/other_seller_profile/providers/other_seller_profile_provider.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherSellerView extends StatefulWidget {
  final OtherSellerArguments arguments;

  const OtherSellerView({super.key, required this.arguments});

  @override
  State<OtherSellerView> createState() => _OtherSellerViewState();
}

class _OtherSellerViewState extends State<OtherSellerView> {
  late OtherSellerProvider provider;
  int index = 0;
  List<String> tabTitles = ["cattle", "crop", "pet", "community"];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<OtherSellerProvider>();
      provider.getOtherSellerDetail(context, widget.arguments.id, true);
    });
    super.initState();
  }
  @override
  dispose() {
    provider.isLoading = true;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<OtherSellerProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(
                title: "sellerInformation",
                action: state.noData || state.isLoading
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          final link = DeepLinkService().generateDeePLink(state.otherSellerProfileModel!.seller!.memberId.toString(), state.otherSellerProfileModel!.seller!.id.toString(), "Seller");
                          final imageUrl = state.otherSellerProfileModel!.seller!.profile != null && state.otherSellerProfileModel!.seller!.profile!.isNotEmpty
                              ? state.otherSellerProfileModel!.seller!.profile
                              : "";

                          if (link.isNotEmpty) {
                            ShareService.shareProduct(
                              title: state.otherSellerProfileModel!.seller!.name ?? "",
                              imageUrl: "${ApiUrl.imageUrl}${imageUrl ?? " "}",
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
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Builder(builder: (context) {
                if (state.isLoading) {
                  return LoaderClass(height: double.infinity);
                }
                if (state.noData) {
                  return NoDataClass(
                    height: double.infinity,
                    text: 'noDataFound',
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Container(
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
                                  child: TText(
                                    keyName: "sellerProfile",
                                    style: TextStyle(
                                      color: ColorConstant.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
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
                                      TText(
                                        keyName: state.otherSellerProfileModel?.seller?.name ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
                                          TText(
                                            keyName: "memberId",
                                            style: TextStyle(
                                              color: ColorConstant.textLightCl,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.sp,
                                              fontFamily: FontsStyle.medium,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          TText(
                                            keyName: " : ${state.otherSellerProfileModel?.seller?.memberId ?? ""}",
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
                                              ImageConstant.telephoneCallIc,
                                              height: 20.h,
                                              width: 20.w,
                                            ),
                                            SizedBox(width: 8.w),
                                            TText(keyName:
                                            "${state.otherSellerProfileModel?.seller?.totalCalls ?? "0"}",
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
                                            "${state.otherSellerProfileModel?.seller?.totalViews ?? "0"}",
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
                    ),
                    SizedBox(height: 10.h),
                    _buildTabBar(state),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: index == 0
                          ? Builder(
                            builder: (context) {
                              if (state.noData ||state.otherSellerProfileModel!.cattle!.isEmpty) {
                                return NoDataClass(
                                  height: double.infinity,
                                  text: 'noDataFound',
                                );
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.otherSellerProfileModel?.cattle?.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    var item = state.otherSellerProfileModel?.cattle?[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, Routes.marketDetails, arguments: CattleArgument(id: item.id.toString(), isUser: false, categoryId: item.categoryId));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.dm),
                                          border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              ColorConstant.white,
                                              ColorConstant.lightShadowAppCl,
                                            ],
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        TText(
                                                          keyName: item?.title ?? "",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w700,
                                                            color: ColorConstant.textDarkCl,
                                                            fontFamily: FontsStyle.medium,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.h),
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
                                                                keyName: item?.postedAgo ?? "",
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
                                                        TText(
                                                          keyName: item?.isNegotiable == 1 ? "negotiable" : "",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w700,
                                                            color: ColorConstant.textDarkCl,
                                                            fontFamily: FontsStyle.medium,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      state.addRemoveFavourite(context, item!.categoryId.toString(), item.id.toString());
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(2.w),
                                                      child: Image.asset(
                                                        ImageConstant.startIc,
                                                        height: 26.h,
                                                        width: 26.w,
                                                        color: item?.isFavourite == 1 ? ColorConstant.buttonCl : ColorConstant.borderCl,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: item!.cattleImages!.isNotEmpty,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    color: Colors.white,
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
                                                        items: item.cattleImages!.map((image) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              MediaPreviewUtil.showMediaPreviewDialog(
                                                                context,
                                                                image: image.image ?? "",
                                                                isVideo: image.type == "Video",
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10.dm),
                                                              ),
                                                              clipBehavior: Clip.hardEdge,
                                                              child: image.type == "Video"
                                                                  ? ClipRRect(
                                                                      borderRadius: BorderRadius.circular(10.dm),
                                                                      child: TikTokVideoPlayer(
                                                                        videoUrl: "${ApiUrl.imageUrl}${image.image ?? " "}",
                                                                      ),
                                                                    )
                                                                  : CustomImage(
                                                                      placeholderAsset: ImageConstant.bannerImg,
                                                                      errorAsset: ImageConstant.bannerImg,
                                                                      radius: 10.dm,
                                                                      imageUrl: image.image ?? "",
                                                                      baseUrl: ApiUrl.imageUrl,
                                                                      fit: BoxFit.contain,
                                                                      width: double.infinity,
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
                                                    right: 10,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                                              item.cattleImages!.length,
                                                              (ind) => Container(
                                                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                                                height: 6.h,
                                                                width: 6.w,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10.dm),
                                                                  color: ind == state.selectedIndex ? ColorConstant.white : Colors.transparent,
                                                                  border: Border.all(
                                                                    color: ColorConstant.white,
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            final link = DeepLinkService().generateDeePLink("0", item.id.toString(), "Cattle");
                                                            final imageUrl =
                                                                item.cattleImages != null && item.cattleImages!.isNotEmpty && item.cattleImages![0].type == "Image" ? item.cattleImages![0].image : "";

                                                            if (link.isNotEmpty) {
                                                              ShareService.shareProduct(
                                                                title: item.title ?? "",
                                                                imageUrl: "${ApiUrl.imageUrl}${imageUrl ?? " "}",
                                                                link: link,
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.all(4.h),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(4.dm),
                                                              color: ColorConstant.darkAppCl.withValues(alpha: 0.30),
                                                            ),
                                                            child: Image.asset(
                                                              ImageConstant.shareLineIc,
                                                              height: 20.h,
                                                              width: 20.w,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 12.h),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    ImageConstant.locationFillIc,
                                                    height: 14.h,
                                                    width: 14.w,
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  Expanded(
                                                    child: TText(
                                                      keyName: item.address ?? "",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
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
                                            ),
                                            SizedBox(height: 6.h),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12.dm),
                                                image: DecorationImage(
                                                  image: AssetImage(ImageConstant.bottomContImg),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
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
                                                        imageUrl: item.seller?.profile ?? "",
                                                        baseUrl: ApiUrl.imageUrl,
                                                        height: 24.h,
                                                        width: 24.w,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  Expanded(
                                                    child: TText(
                                                      keyName: item.seller?.name ?? "",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontWeight: FontWeight.w400,
                                                        color: ColorConstant.textLightCl,
                                                        fontFamily: FontsStyle.regular,
                                                        fontStyle: FontStyle.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      var url = "tel:+91${item.seller?.mobile ?? ""}";
                                                      if (await launchUrl(Uri.parse(url))) {
                                                        await launchUrl(Uri.parse(url));
                                                        state.increaseCallCount("cattle", item.id.toString());
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
                                                          TText(
                                                            keyName: "call",
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
                                                        Uri.parse("https://wa.me/+91${item.seller?.whatsappNo ?? ""}/?text=Hii..."),
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
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                            }
                          )
                          : index == 1
                              ? Builder(
                                builder: (context) {
                                  if (state.noData ||state.otherSellerProfileModel!.crop!.isEmpty) {
                                    return NoDataClass(
                                      height: double.infinity,
                                      text: 'noDataFound',
                                    );
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.otherSellerProfileModel?.crop?.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (BuildContext context, int index) {
                                        var item =  state.otherSellerProfileModel?.crop?[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context, Routes.marketCropDetails, arguments: CropArgument(id: item.id.toString(), isUser: false, categoryId:item.categoryId.toString()));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 10.h),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12.dm),
                                              border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  ColorConstant.white,
                                                  ColorConstant.lightShadowAppCl,
                                                ],
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            TText(
                                                              keyName: item?.title ?? "",
                                                              style: TextStyle(
                                                                fontSize: 14.sp,
                                                                fontWeight: FontWeight.w700,
                                                                color: ColorConstant.textDarkCl,
                                                                fontFamily: FontsStyle.medium,
                                                                fontStyle: FontStyle.normal,
                                                              ),
                                                            ),
                                                            SizedBox(height: 2.h),
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
                                                                    keyName: item?.postedAgo ?? "",
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
                                                            TText(
                                                              keyName: item?.isNegotiable == 1 ? negotiable : "",
                                                              style: TextStyle(
                                                                fontSize: 14.sp,
                                                                fontWeight: FontWeight.w700,
                                                                color: ColorConstant.textDarkCl,
                                                                fontFamily: FontsStyle.medium,
                                                                fontStyle: FontStyle.normal,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          state.addRemoveFavourite(context, item.categoryId, item.id.toString());
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(2.w),
                                                          child: Image.asset(
                                                            ImageConstant.startIc,
                                                            height: 26.h,
                                                            width: 26.w,
                                                            color: item!.isFavourite == 1 ? ColorConstant.buttonCl : ColorConstant.borderCl,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: item.cropImages!.isNotEmpty,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        color: Colors.white,
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
                                                            items: item.cropImages!.map((image) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  MediaPreviewUtil.showMediaPreviewDialog(
                                                                    context,
                                                                    image: image.image ?? "",
                                                                    isVideo: image.type == "Video",
                                                                  );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10.dm),
                                                                  ),
                                                                  clipBehavior: Clip.hardEdge,
                                                                  child: image.type == "Video"
                                                                      ? ClipRRect(
                                                                          borderRadius: BorderRadius.circular(10.dm),
                                                                          child: TikTokVideoPlayer(
                                                                            videoUrl: "${ApiUrl.imageUrl}${image.image ?? " "}",
                                                                          ),
                                                                        )
                                                                      : CustomImage(
                                                                          placeholderAsset: ImageConstant.bannerImg,
                                                                          errorAsset: ImageConstant.bannerImg,
                                                                          radius: 10.dm,
                                                                          imageUrl: image.image ?? "",
                                                                          baseUrl: ApiUrl.imageUrl,
                                                                          fit: BoxFit.contain,
                                                                          width: double.infinity,
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
                                                        right: 10,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                                                  item.cropImages!.length,
                                                                  (ind) => Container(
                                                                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                                                                    height: 6.h,
                                                                    width: 6.w,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10.dm),
                                                                      color: ind == state.selectedIndex ? ColorConstant.white : Colors.transparent,
                                                                      border: Border.all(
                                                                        color: ColorConstant.white,
                                                                        width: 1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                final link = DeepLinkService().generateDeePLink("0", item.id.toString(), "Crop");
                                                                final imageUrl =
                                                                    item.cropImages != null && item.cropImages!.isNotEmpty && item.cropImages![0].type == "Image" ? item.cropImages![0].image : "";

                                                                if (link.isNotEmpty) {
                                                                  ShareService.shareProduct(
                                                                    title: item.title ?? "",
                                                                    imageUrl: "${ApiUrl.imageUrl}${imageUrl ?? " "}",
                                                                    link: link,
                                                                  );
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.all(4.h),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(4.dm),
                                                                  color: ColorConstant.darkAppCl.withValues(alpha: 0.30),
                                                                ),
                                                                child: Image.asset(
                                                                  ImageConstant.shareLineIc,
                                                                  height: 20.h,
                                                                  width: 20.w,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 12.h),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        ImageConstant.locationFillIc,
                                                        height: 14.h,
                                                        width: 14.w,
                                                      ),
                                                      SizedBox(width: 6.w),
                                                      Expanded(
                                                        child: TText(
                                                          keyName: item.address ?? "",
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
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
                                                ),
                                                SizedBox(height: 6.h),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12.dm),
                                                    image: DecorationImage(
                                                      image: AssetImage(ImageConstant.bottomContImg),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
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
                                                            imageUrl: item.seller?.profile ?? "",
                                                            baseUrl: ApiUrl.imageUrl,
                                                            height: 24.h,
                                                            width: 24.w,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 6.w),
                                                      Expanded(
                                                        child: TText(
                                                          keyName: item.seller?.name ?? "",
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            fontWeight: FontWeight.w400,
                                                            color: ColorConstant.textLightCl,
                                                            fontFamily: FontsStyle.regular,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          var url = "tel:+91${item.seller?.mobile ?? ""}";
                                                          if (await launchUrl(Uri.parse(url))) {
                                                            await launchUrl(Uri.parse(url));
                                                            state.increaseCallCount("crop", item.id.toString());
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
                                                              TText(
                                                                keyName: "call",
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
                                                            Uri.parse("https://wa.me/+91${item.seller?.whatsappNo ?? ""}/?text=Hii..."),
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
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                }
                              )
                              : index == 2
                                  ? Builder(
                                    builder: (context) {
                                      if (state.noData ||state.otherSellerProfileModel!.pet!.isEmpty) {
                                        return NoDataClass(
                                          height: double.infinity,
                                          text: 'noDataFound',
                                        );
                                      }
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.otherSellerProfileModel?.pet?.length,
                                          physics: const BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            var item = state.otherSellerProfileModel?.pet?[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context, Routes.petMarketDetails,
                                                    arguments: PetArgument(id: item.id.toString(), isUser: false, categoryId: item.categoryId.toString()));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(bottom: 10.h),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12.dm),
                                                  border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      ColorConstant.white,
                                                      ColorConstant.lightShadowAppCl,
                                                    ],
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TText(
                                                                  keyName: item?.title ?? "",
                                                                  style: TextStyle(
                                                                    fontSize: 14.sp,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: ColorConstant.textDarkCl,
                                                                    fontFamily: FontsStyle.medium,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 2.h),
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
                                                                        keyName: item?.postedAgo ?? "",
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
                                                                TText(
                                                                  keyName: item?.isNegotiable == 1 ? "negotiable" : "",
                                                                  style: TextStyle(
                                                                    fontSize: 14.sp,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: ColorConstant.textDarkCl,
                                                                    fontFamily: FontsStyle.medium,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              state.addRemoveFavourite(context, item!.categoryId.toString(), item.id.toString());
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(2.w),
                                                              child: Image.asset(
                                                                ImageConstant.startIc,
                                                                height: 26.h,
                                                                width: 26.w,
                                                                color: item?.isFavourite == 1 ? ColorConstant.buttonCl : ColorConstant.borderCl,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: item!.petImages!.isNotEmpty,
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            color: Colors.white,
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
                                                                items: item.petImages!.map((image) {
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      MediaPreviewUtil.showMediaPreviewDialog(
                                                                        context,
                                                                        image: image.path ?? "",
                                                                        isVideo: image.type == "Video",
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(10.dm),
                                                                      ),
                                                                      clipBehavior: Clip.hardEdge,
                                                                      child: image.type == "Video"
                                                                          ? ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10.dm),
                                                                              child: TikTokVideoPlayer(
                                                                                videoUrl: "${ApiUrl.imageUrl}${image.path ?? " "}",
                                                                              ),
                                                                            )
                                                                          : CustomImage(
                                                                              placeholderAsset: ImageConstant.bannerImg,
                                                                              errorAsset: ImageConstant.bannerImg,
                                                                              radius: 10.dm,
                                                                              imageUrl: image.path ?? "",
                                                                              baseUrl: ApiUrl.imageUrl,
                                                                              fit: BoxFit.contain,
                                                                              width: double.infinity,
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
                                                            right: 10,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                                                      item.petImages!.length,
                                                                      (ind) => Container(
                                                                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                                                                        height: 6.h,
                                                                        width: 6.w,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10.dm),
                                                                          color: ind == state.selectedIndex ? ColorConstant.white : Colors.transparent,
                                                                          border: Border.all(
                                                                            color: ColorConstant.white,
                                                                            width: 1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    final link = DeepLinkService().generateDeePLink("0", item.id.toString(), "Pet");
                                                                    final imageUrl =
                                                                        item.petImages != null && item.petImages!.isNotEmpty && item.petImages![0].type == "Image" ? item.petImages![0].path : "";

                                                                    if (link.isNotEmpty) {
                                                                      ShareService.shareProduct(
                                                                        title: item.title ?? "",
                                                                        imageUrl: "${ApiUrl.imageUrl}${imageUrl ?? " "}",
                                                                        link: link,
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    padding: EdgeInsets.all(4.h),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(4.dm),
                                                                      color: ColorConstant.darkAppCl.withValues(alpha: 0.30),
                                                                    ),
                                                                    child: Image.asset(
                                                                      ImageConstant.shareLineIc,
                                                                      height: 20.h,
                                                                      width: 20.w,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 12.h),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Image.asset(
                                                            ImageConstant.locationFillIc,
                                                            height: 14.h,
                                                            width: 14.w,
                                                          ),
                                                          SizedBox(width: 6.w),
                                                          Expanded(
                                                            child: TText(
                                                              keyName: item.address ?? "",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
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
                                                    ),
                                                    SizedBox(height: 6.h),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12.dm),
                                                        image: DecorationImage(
                                                          image: AssetImage(ImageConstant.bottomContImg),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
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
                                                                imageUrl: item.seller?.profile ?? "",
                                                                baseUrl: ApiUrl.imageUrl,
                                                                height: 24.h,
                                                                width: 24.w,
                                                                fit: BoxFit.contain,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 6.w),
                                                          Expanded(
                                                            child: TText(
                                                              keyName: item.seller?.name ?? "",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 10.sp,
                                                                fontWeight: FontWeight.w400,
                                                                color: ColorConstant.textLightCl,
                                                                fontFamily: FontsStyle.regular,
                                                                fontStyle: FontStyle.normal,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.w),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              var url = "tel:+91${item.seller?.mobile ?? ""}";
                                                              if (await launchUrl(Uri.parse(url))) {
                                                                await launchUrl(Uri.parse(url));
                                                                state.increaseCallCount("pet", item.id.toString());
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
                                                                  TText(
                                                                    keyName: "call",
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
                                                                Uri.parse("https://wa.me/+91${item.seller?.whatsappNo ?? ""}/?text=Hii..."),
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
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                    }
                                  )
                                  : Builder(
                                    builder: (context) {
                                      if (state.noData ||state.otherSellerProfileModel!.community!.isEmpty) {
                                        return NoDataClass(
                                          height: double.infinity,
                                          text: 'noDataFound',
                                        );
                                      }
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.otherSellerProfileModel?.community?.length,
                                          itemBuilder: (_, index) {
                                            var item = state.otherSellerProfileModel?.community?[index];
                                            return InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context, Routes.communityDetails, arguments: BlogDetailsArgument(id: item.id.toString(), isEdit: false, categoryId: item.catId.toString()));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: ColorConstant.borderCl,
                                                      width: 1.w,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 30.h,
                                                          width: 30.w,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(30.dm),
                                                            child: CustomImage(
                                                              placeholderAsset: ImageConstant.demoUserImg,
                                                              errorAsset: ImageConstant.demoUserImg,
                                                              radius: 30.dm,
                                                              imageUrl: item?.userProfileImage ?? "",
                                                              baseUrl: ApiUrl.imageUrl,
                                                              height: 30.h,
                                                              width: 30.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 11.w),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              TText(
                                                                keyName: item!.userName ?? "",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 12.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: ColorConstant.textDarkCl,
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
                                                                      keyName: item.postedAgo ?? "",
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
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                      ],
                                                    ),
                                                    SizedBox(height: 19.h),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 50.w, right: 10.w),
                                                      child: ShowMoreText(
                                                        description: item.description ?? "",
                                                        userName: '',
                                                        tagList: [],
                                                      ),
                                                    ),
                                                    item.image != null && item.image!.isNotEmpty
                                                        ? Padding(
                                                            padding: EdgeInsets.only(left: 50.w, right: 10.w),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 10.h,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (item.image != null && item.image!.isNotEmpty) {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (_) => FullImageView(image: ApiUrl.imageUrl + item.image!, isDownload: true)));
                                                                    } else {
                                                                      errorToast(context, "No image found");
                                                                    }
                                                                  },
                                                                  child: SizedBox(
                                                                    width: double.infinity,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(10.dm),
                                                                      child: CustomImage(
                                                                        placeholderAsset: ImageConstant.demoPostImg,
                                                                        errorAsset: ImageConstant.demoPostImg,
                                                                        radius: 10.dm,
                                                                        imageUrl: item.image ?? "",
                                                                        baseUrl: ApiUrl.imageUrl,
                                                                        width: double.infinity,
                                                                        fit: BoxFit.contain,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                    SizedBox(height: 34.h),
                                                    Row(
                                                      children: [
                                                        item.latestCommentsProfile != null
                                                            ? SizedBox(
                                                                width: 22 + (3 - 1) * 15,
                                                                height: 22,
                                                                child: Stack(
                                                                  children: List.generate(
                                                                    item.latestCommentsProfile!.length,
                                                                    (index) {
                                                                      return Positioned(
                                                                        left: index * 15,
                                                                        child: CircleAvatar(
                                                                          backgroundColor: ColorConstant.white,
                                                                          radius: 11,
                                                                          child: Container(
                                                                            decoration: BoxDecoration(border: Border.all(color: ColorConstant.white, width: 1.w), shape: BoxShape.circle),
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10.dm),
                                                                              child: CustomImage(
                                                                                placeholderAsset: ImageConstant.demoPostImg,
                                                                                errorAsset: ImageConstant.demoPostImg,
                                                                                radius: 100.dm,
                                                                                imageUrl: item.latestCommentsProfile![index].profileImage ?? "",
                                                                                baseUrl: ApiUrl.imageUrl,
                                                                                width: double.infinity,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        SizedBox(width: 13.w),
                                                        Image.asset(
                                                          ImageConstant.commentIc,
                                                          height: 18.h,
                                                          width: 18.w,
                                                        ),
                                                        SizedBox(width: 5.w),
                                                        Expanded(
                                                          child: TText(
                                                            keyName: '${item.commentCount ?? ""} Comments',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 12,
                                                              color: Color(0XFF74AC42),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            state.blogpostLike(context, item.id.toString());
                                                          },
                                                          child: Icon(
                                                            item.isLiked.toString() == "1" ? Icons.favorite : Icons.favorite_border,
                                                            size: 20.h,
                                                            color: item.isLiked.toString() == "1" ? Colors.red : ColorConstant.textDarkCl,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        GestureDetector(
                                                          onTap: () {
                                                            final link = DeepLinkService().generateDeePLink("0", item.id.toString(), "Blog");
                                                            final imageUrl = item.image != null && item.image!.isNotEmpty ? item.image : "";

                                                            if (link.isNotEmpty) {
                                                              ShareService.shareProduct(
                                                                title: item.description ?? "",
                                                                imageUrl: "${ApiUrl.imageUrl}${imageUrl ?? " "}",
                                                                link: link,
                                                              );
                                                            }
                                                          },
                                                          child: Image.asset(
                                                            ImageConstant.sharePostIc,
                                                            height: 20.h,
                                                            width: 20.w,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                    }
                                  ),
                    )
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar(OtherSellerProvider state) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.w), // Optional padding
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabTitles.length, (i) {
            return InkWell(
              onTap: () {
                setState(() {
                  index = i;
                  //  state.sellerDashboard(tabTypes[i], true);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
                margin: EdgeInsets.only(right: 8.w), // Space between tabs
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: index == i ? ColorConstant.darkAppCl : Colors.transparent,
                      width: 2.w,
                    ),
                  ),
                ),
                child: TText(
                  keyName: tabTitles[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: index == i ? ColorConstant.darkAppCl : ColorConstant.gray1Cl,
                    fontStyle: FontStyle.normal,
                    fontFamily: FontsStyle.medium,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

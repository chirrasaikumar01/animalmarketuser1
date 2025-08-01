import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/media_preview_util.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/common_widgets/player_widget.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/helper/deep_link_service.dart';
import 'package:animal_market/helper/share_service.dart';
import 'package:animal_market/modules/buy_pet/models/pet_argument.dart';
import 'package:animal_market/modules/market_pet/providers/market_pet_provider.dart';
import 'package:animal_market/modules/market_pet/widgets/filter_pet_bottom_sheet.dart';
import 'package:animal_market/modules/other_seller_profile/providers/other_seller_profile_provider.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class PetMarketView extends StatefulWidget {
  final PetArgument argument;

  const PetMarketView({super.key, required this.argument});

  @override
  State<PetMarketView> createState() => _PetMarketViewState();
}

class _PetMarketViewState extends State<PetMarketView> {
  late MarketPetProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<MarketPetProvider>();
      provider.subCategoryId = widget.argument.id;
      provider.petListGet(context, false, true);
      provider.initAudioServices();
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading2 = true;
    provider.resetFilter();
    provider.resetPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPetProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 70.h),
            child: CommonAppBar(title: "petMarket"),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "searchPet",
                        borderCl: ColorConstant.borderCl,
                        fillColor: ColorConstant.white,
                        onChanged: (value) {
                          state.filterSearchResults(value);
                        },
                        leading1: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              ImageConstant.searchIc,
                              height: 22.h,
                              width: 22.w,
                            ),
                            SizedBox(width: 6.w),
                            SizedBox(
                              height: 22.h,
                              child: VerticalDivider(
                                color: ColorConstant.borderCl,
                                width: 1.w,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            /* Image.asset(
                              ImageConstant.micIc,
                              height: 22.h,
                              width: 22.w,
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 9.w),
                    GestureDetector(
                      onTap: () {
                        state.subCategory(context, widget.argument.categoryId);
                        FilterPetBottomSheet.show(context, () {
                          state.petListGet(context, true, false);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                        decoration: BoxDecoration(
                          color: ColorConstant.appCl,
                          borderRadius: BorderRadius.circular(10.dm),
                        ),
                        child: Image.asset(
                          ImageConstant.filterIc,
                          height: 36.h,
                          width: 36.w,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 14.h),
                Expanded(
                  child: Builder(builder: (context) {
                    if (state.isLoading2) {
                      return LoaderClass(height: double.infinity);
                    }
                    if (state.filteredList.isEmpty) {
                      return NoDataClass(
                        height: double.infinity,
                        text: "noDataFound",
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.filteredList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var item = state.filteredList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.petMarketDetails, arguments: PetArgument(id: item.id.toString(), isUser: false, categoryId: widget.argument.categoryId));
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
                                              keyName: item.title ?? "",
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
                                            TText(
                                              keyName: item.isNegotiable == 1 ? "negotiable" : "",
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
                                          state.addRemoveFavourite(context, widget.argument.categoryId, item.id.toString());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(2.w),
                                          child: Image.asset(
                                            ImageConstant.startIc,
                                            height: 26.h,
                                            width: 26.w,
                                            color: item.isFavourite == 1 ? ColorConstant.buttonCl : ColorConstant.borderCl,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: item.petImages!.isNotEmpty,
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
                                                final imageUrl = item.petImages != null && item.petImages!.isNotEmpty && item.petImages![0].type == "Image" ? item.petImages![0].path : "";

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
                                        onTap: () {
                                          state.initAudioServices();
                                          if (item.audioFiles != null && item.audioFiles!.isNotEmpty) {
                                            for (int i = 0; i < item.audioFiles!.length; i++) {
                                              if (item.audioFiles![i].type == "audio") {
                                                state.updateAudioFile(item.audioFiles![i].path ?? "");
                                                state.isPlaying ? state.stopAudio() : state.playAudio();
                                              } else {
                                                state.updateAudioFile("");
                                                errorToast(context, "No audio file found");
                                              }
                                            }
                                          } else {
                                            state.updateAudioFile("");
                                            errorToast(context, "No audio file found");
                                          }
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                            margin: EdgeInsets.only(top: 5.h),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.darkAppCl,
                                              borderRadius: BorderRadius.circular(6.dm),
                                            ),
                                            child: Image.asset(
                                              ImageConstant.speakerIc,
                                              height: 20.h,
                                              width: 20.w,
                                              color: ColorConstant.white,
                                            )),
                                      ),
                                      SizedBox(width: 10.w),
                                      GestureDetector(
                                        onTap: () async {
                                          var url = "tel:+91${item.seller?.mobile ?? ""}";
                                          if (await launchUrl(Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                            Provider.of<OtherSellerProvider>(context, listen: false).increaseCallCount("pet", item.id.toString());
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
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

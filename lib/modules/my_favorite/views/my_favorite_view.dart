import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/buy/models/cattle_argument.dart';
import 'package:animal_market/modules/buy_crop/models/crop_argument.dart';
import 'package:animal_market/modules/buy_pet/models/pet_argument.dart';
import 'package:animal_market/modules/community/models/blog_details_argument.dart';
import 'package:animal_market/modules/community/widgets/show_more_text.dart';
import 'package:animal_market/modules/full_view_image/views/full_image_view.dart';
import 'package:animal_market/modules/know_education/model/know_argument.dart';
import 'package:animal_market/modules/know_education/model/knowledge_list_model.dart';
import 'package:animal_market/modules/my_favorite/providers/my_favorite_provider.dart';
import 'package:animal_market/modules/other_seller_profile/providers/other_seller_profile_provider.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFavoriteView extends StatefulWidget {
  const MyFavoriteView({super.key});

  @override
  State<MyFavoriteView> createState() => _MyFavoriteViewState();
}

class _MyFavoriteViewState extends State<MyFavoriteView> {
  late MyFavoriteProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = context.read<MyFavoriteProvider>();
      provider.myFavouriteListGet(context, "");
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading1 = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyFavoriteProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(
                title: "myFavourite",
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  SizedBox(height: 14.h),
                  Expanded(
                    child: Builder(builder: (context) {
                      if (state.isLoading1) {
                        return LoaderClass(height: double.infinity);
                      }
                      if (state.myFavouriteList.isEmpty) {
                        return NoDataClass(
                          text: "noDataFound",
                          height: double.infinity,
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.myFavouriteList.length,
                        itemBuilder: (context, index) {
                          var item = state.myFavouriteList[index];
                          return item.type == "community"
                              ? InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.communityDetails, arguments: BlogDetailsArgument(id: item.id.toString(), isEdit: false, categoryId: item.catId.toString()));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.dm),
                                      border: Border.all(
                                        color: ColorConstant.borderCl,
                                        width: 1.w,
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
                                                  imageUrl: item.userProfileImage ?? "",
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
                                                  TText(keyName:
                                                    item.userName ?? "",
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
                                                  TText(keyName:
                                                    item.postTime ?? "",
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
                                            SizedBox(width: 10.w),
                                            GestureDetector(
                                              onTap: () {
                                                state.addRemoveFavourite(context, "4", item.id.toString());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(2.w),
                                                child: Image.asset(
                                                  ImageConstant.startIc,
                                                  height: 20.h,
                                                  width: 20.w,
                                                ),
                                              ),
                                            ),
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
                                      ],
                                    ),
                                  ),
                                )
                              : item.type == "knowledge"
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.knowEducationDetails,
                                          arguments: KnowArgument(
                                              knowledgeListData: KnowledgeListData(
                                            id: item.id,
                                            title: item.title,
                                            description: item.description,
                                            image: item.image,
                                            date: item.date,
                                            catId: item.catId,
                                            subCatId: item.subCatId,
                                            categoryName: item.categoryName,
                                            video: item.video,
                                            document: item.document,
                                            pdf: item.pdf,
                                            link: item.link,
                                            subcategoryName: item.subcategoryName,
                                          )),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2.h),
                                        margin: EdgeInsets.only(bottom: 10.h),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                                          borderRadius: BorderRadius.circular(10.dm),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                CustomImage(
                                                  placeholderAsset: ImageConstant.demoPostImg,
                                                  errorAsset: ImageConstant.demoPostImg,
                                                  radius: 6.dm,
                                                  imageUrl: item.image ?? "",
                                                  baseUrl: ApiUrl.imageUrl,
                                                  width: double.infinity,
                                                  fit: BoxFit.fill,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        state.addRemoveFavourite(context, "5", item.id.toString());
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(color: ColorConstant.black.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(20.dm)),
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Image.asset(
                                                          ImageConstant.fvtSelectedIc,
                                                          height: 20.h,
                                                          width: 20.w,
                                                          color: ColorConstant.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: ColorConstant.black.withAlpha(25),
                                                        borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(6),
                                                        ),
                                                      ),
                                                      child: TText(keyName:
                                                        item.date ?? "",
                                                        style: TextStyle(
                                                          color: ColorConstant.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TText(keyName:
                                                    item.title ?? "",
                                                    style: TextStyle(
                                                      color: ColorConstant.textDarkCl,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 9),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w400,
                                                        color: ColorConstant.appCl,
                                                      ),
                                                      children: [
                                                        TextSpan(text: item.categoryName),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 9),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        if (item.type == "crop") {
                                          Navigator.pushNamed(context, Routes.marketCropDetails,
                                              arguments: CropArgument(id: item.id.toString(), isUser: false, categoryId: item.categoryId.toString()));
                                        } else if (item.type == "pet") {
                                          Navigator.pushNamed(context, Routes.petMarketDetails, arguments: PetArgument(id: item.id.toString(), isUser: false, categoryId: item.categoryId.toString()));
                                        } else if (item.type == "cattle") {
                                          Navigator.pushNamed(context, Routes.marketDetails, arguments: CattleArgument(id: item.id.toString(), isUser: false, categoryId: item.catId.toString()));
                                        }
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
                                                        TText(keyName:
                                                          item.title ?? "",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w700,
                                                            color: ColorConstant.textDarkCl,
                                                            fontFamily: FontsStyle.medium,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                        TText(keyName:
                                                          '₹ ${item.price ?? ""}',
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
                                                      state.addRemoveFavourite(context, item.categoryId.toString(), item.id.toString());
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(2.w),
                                                      child: Image.asset(
                                                        ImageConstant.startIc,
                                                        height: 20.h,
                                                        width: 20.w,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: item.images!.isNotEmpty,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                      color: Colors.white,
                                                      width: MediaQuery.of(context).size.width,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: CustomImage(
                                                          placeholderAsset: ImageConstant.bannerImg,
                                                          errorAsset: ImageConstant.bannerImg,
                                                          radius: 10.dm,
                                                          imageUrl: item.images != null && item.images!.isNotEmpty ? item.images![0].path ?? "" : "",
                                                          baseUrl: ApiUrl.imageUrl,
                                                          fit: BoxFit.contain,
                                                          width: double.infinity,
                                                        ),
                                                      ))
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
                                                    child: TText(keyName:
                                                      item.address ?? "",
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
                                                    child: TText(keyName:
                                                      item.seller?.name ?? "",
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
                                                        Provider.of<OtherSellerProvider>(context, listen: false).increaseCallCount(item.type??"", item.id.toString());
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
      },
    );
  }
}

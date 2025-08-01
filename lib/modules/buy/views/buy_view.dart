import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/buy/models/cattle_argument.dart';
import 'package:animal_market/modules/buy/providers/buy_provider.dart';
import 'package:animal_market/modules/buy/widgets/search_location_view.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';

class BuyView extends StatefulWidget {
  final String categoryId;

  const BuyView({super.key, required this.categoryId});

  @override
  State<BuyView> createState() => _BuyViewState();
}

class _BuyViewState extends State<BuyView> {
  late BuyProvider buyProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      buyProvider = context.read<BuyProvider>();
      buyProvider.categoryId= widget.categoryId;
      buyProvider.buyCattleHome(context, widget.categoryId);
    });
    super.initState();
  }

  @override
  void dispose() {
    buyProvider.isLoading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BuyProvider>(builder: (context, state, child) {
      return Scaffold(
        backgroundColor: ColorConstant.white,
        body: Builder(builder: (context) {
          if (state.isLoading) {
            return LoaderClass(height: double.infinity);
          }
          if (state.noData) {
            return NoDataClass(
              height: double.infinity,
              text: noDataFound,
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorConstant.appBarClOne,
                        ColorConstant.appBarClThird,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RTTextSpan(
                            textAlign: TextAlign.start,
                            maxChildren: 2,
                            keyName: 'buy',
                            style: TextStyle(
                              color: ColorConstant.textDarkCl,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                            items: [
                              RTSpanItem(
                                key: ' ',
                                style: TextStyle(
                                  color: ColorConstant.appCl,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                  fontFamily: FontsStyle.regular,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              RTSpanItem(
                                key: "cattle",
                                style: TextStyle(
                                  color: ColorConstant.appCl,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                  fontFamily: FontsStyle.regular,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.cattleSubCategory, arguments: CattleArgument(id: widget.categoryId, isUser: false, categoryId: widget.categoryId));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.borderCl,
                                borderRadius: BorderRadius.circular(4.dm),
                              ),
                              child: Row(
                                children: [
                                  TText(
                                    keyName: "otherAnimal",
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
                      MediaQuery.removePadding(
                        context: context,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1.60,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 12,
                            crossAxisCount: 4,
                          ),
                          itemCount: state.buyCattleList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var item = state.buyCattleList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.market, arguments: CattleArgument(id: item.id.toString(), isUser: false, categoryId: widget.categoryId));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 65.h,
                                    width: 65.w,
                                    decoration: BoxDecoration(color: ColorConstant.white, borderRadius: BorderRadius.circular(10.dm), border: Border.all(color: ColorConstant.appCl, width: 1.w)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.dm),
                                      child: CustomImage(
                                        placeholderAsset: ImageConstant.cattleImg,
                                        errorAsset: ImageConstant.cattleImg,
                                        radius: 10.dm,
                                        imageUrl: item.image ?? "",
                                        baseUrl: ApiUrl.imageUrl,
                                        height: 65.h,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  TText(
                                    keyName: item.title ?? "",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
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
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Visibility(
                  visible: state.cattleNearYou.isEmpty ? false : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RTTextSpan(
                              textAlign: TextAlign.start,
                              maxChildren: 2,
                              keyName: 'cattle',
                              style: TextStyle(
                                color: ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                              items: [
                                RTSpanItem(
                                  key: ' ',
                                  style: TextStyle(
                                    color: ColorConstant.appCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                RTSpanItem(
                                  key: "nearYou",
                                  style: TextStyle(
                                    color: ColorConstant.appCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.market, arguments: CattleArgument(id: "", isUser: false, categoryId: widget.categoryId));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: ColorConstant.borderCl,
                                  borderRadius: BorderRadius.circular(4.dm),
                                ),
                                child: Row(
                                  children: [
                                    TText(
                                      keyName: "seeAll",
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
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        height: 200.h,
                        padding: EdgeInsets.only(left: 12.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ListView.builder(
                            itemCount: state.cattleNearYou.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              var item = state.cattleNearYou[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.marketDetails, arguments: CattleArgument(id: item.id.toString(), isUser: false, categoryId: widget.categoryId));
                                },
                                child: Container(
                                  width: 146.w,
                                  height: 200.h,
                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.dm),
                                    border: Border.all(
                                      color: ColorConstant.borderCl,
                                      width: 1.w,
                                    ),
                                    gradient: const LinearGradient(
                                      colors: [
                                        ColorConstant.white,
                                        ColorConstant.lightShadowAppCl,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.dm),
                                        child: CustomImage(
                                          placeholderAsset: ImageConstant.cattleImg,
                                          errorAsset: ImageConstant.cattleImg,
                                          radius: 10.dm,
                                          imageUrl: item.cattleImages != null
                                              ? item.cattleImages!.isNotEmpty
                                                  ? item.cattleImages![0].image ?? ""
                                                  : ""
                                              : "",
                                          baseUrl: ApiUrl.imageUrl,
                                          height: 105.h,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      TText(
                                        keyName: item.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: ColorConstant.textDarkCl,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          fontFamily: FontsStyle.medium,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Row(
                                        children: [
                                          Image.asset(
                                            ImageConstant.locationFillIc,
                                            height: 14.h,
                                            width: 14.w,
                                          ),
                                          SizedBox(width: 6.w),
                                          Expanded(
                                            child: TText(
                                              keyName: " ${item.city ?? ""},${item.state ?? ""}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: ColorConstant.textLightCl,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10.sp,
                                                fontFamily: FontsStyle.semiBold,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      TText(
                                        keyName: "₹${item.price ?? ""}",
                                        style: TextStyle(
                                          color: ColorConstant.textDarkCl,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.sp,
                                          fontFamily: FontsStyle.medium,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(10.dm),
                    border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: TText(
                          keyName: "searchCattle",
                          style: TextStyle(
                            color: ColorConstant.textDarkCl,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                            fontFamily: FontsStyle.semiBold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () async {
                          var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchLocationView()));
                          /* var result = await SearchLocationBottomSheet().show(
                            context,
                            state.searchController,
                          );*/
                          if (result != null) {
                            if (context.mounted) {
                              state.locationUpdate(context, result);
                            }
                          } else {
                            Log.console("No result received from location screen.");
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageConstant.myLocationIc,
                                height: 20.h,
                                width: 20.w,
                              ),
                              SizedBox(width: 10.w),
                              TText(
                                keyName: "selectLocationOnMap",
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
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Divider(color: ColorConstant.borderCl, height: 1.h),
                      SizedBox(height: 14.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.market, arguments: CattleArgument(id: "", isUser: false, categoryId: widget.categoryId));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageConstant.searchIc,
                                height: 20.h,
                                width: 20.w,
                              ),
                              SizedBox(width: 10.w),
                              TText(
                                keyName: "searchAnimals",
                                style: TextStyle(
                                  color: ColorConstant.hintTextCl,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  fontFamily: FontsStyle.regular,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          );
        }),
      );
    });
  }
}

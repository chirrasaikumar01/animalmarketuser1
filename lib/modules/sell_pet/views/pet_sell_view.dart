import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/buy/models/seller_model.dart';
import 'package:animal_market/modules/sell/widgets/benefits_of_selling_container.dart';
import 'package:animal_market/modules/sell/widgets/sell_profile_container.dart';
import 'package:animal_market/modules/sell_pet/models/add_pet_sell_products_arguments.dart';
import 'package:animal_market/modules/sell_pet/providers/pet_sell_products_provider.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PetSellView extends StatefulWidget {
  final String categoryId;

  const PetSellView({super.key, required this.categoryId});

  @override
  State<PetSellView> createState() => _PetSellViewState();
}

class _PetSellViewState extends State<PetSellView> {
  late PetSellProductsProvider sellProductsProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sellProductsProvider = context.read<PetSellProductsProvider>();
      sellProductsProvider.categoryId = widget.categoryId;
      sellProductsProvider.sellerHome( true);
    });
    super.initState();
  }

  @override
  void dispose() {
    sellProductsProvider.isLoading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetSellProductsProvider>(builder: (context, state, child) {
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
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.addPetSellProducts, arguments: AddPetSellProductsArguments(isEdit: false, categoryId: widget.categoryId, id: ''));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: ColorConstant.appCl,
                        borderRadius: BorderRadius.circular(10.dm),
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstant.black.withValues(alpha:0.15),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: TText(keyName:
                          "sellNow",
                          style: TextStyle(
                            color: ColorConstant.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const BenefitsOfSellingContainer(),
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
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.productsPetDashboard);
                    },
                    child: SellProfileContainer(
                      seller: state.seller ?? Seller(),
                      totalListed: state.totalListed,
                      totalCallsReceived: state.totalCallsReceived,
                      totalViewsReceived: state.totalViewsReceived,
                      listedName: "petListed",
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}

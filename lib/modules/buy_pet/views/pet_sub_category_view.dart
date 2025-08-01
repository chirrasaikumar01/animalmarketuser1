import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/buy_pet/models/pet_argument.dart';
import 'package:animal_market/modules/buy_pet/providers/buy_pet_provider.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';

class PetSubCategoryView extends StatefulWidget {
  final PetArgument argument;

  const PetSubCategoryView({super.key, required this.argument});

  @override
  State<PetSubCategoryView> createState() => _PetSubCategoryViewState();
}

class _PetSubCategoryViewState extends State<PetSubCategoryView> {
  late BuyPetProvider buyProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      buyProvider = context.read<BuyPetProvider>();
      buyProvider.subCategory(context, widget.argument.id);
    });
    super.initState();
  }

  @override
  void dispose() {
    buyProvider.isLoading1 = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BuyPetProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 70),
            child: CommonAppBar(title: "pet"),
          ),
          body: Builder(builder: (context) {
            if (state.isLoading1) {
              return LoaderClass(height: double.infinity);
            }
            if (state.subCategoryList.isEmpty) {
              Image.asset(
                ImageConstant.noDataFoundImg,
                height: double.infinity,
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14.h),
                    RTTextSpan(
                      textAlign: TextAlign.start,
                      maxChildren: 2,
                      keyName: 'buy',
                      style: TextStyle(
                        color: ColorConstant.textDarkCl,
                        fontWeight: FontWeight.w700,
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
                          key: "pet",
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
                    SizedBox(height: 24.h),
                    MediaQuery.removePadding(
                      context: context,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1 / 1.5,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 12,
                          crossAxisCount: 4,
                        ),
                        itemCount: state.subCategoryList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var item = state.subCategoryList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.petMarket, arguments: PetArgument(id: item.id.toString(),isUser: false, categoryId: widget.argument.categoryId));
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
                                      placeholderAsset: ImageConstant.cropDemoImg,
                                      errorAsset: ImageConstant.cropDemoImg,
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
                                TText(keyName:
                                  item.title ?? "",
                                  textAlign: TextAlign.center,
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
            );
          }),
        ),
      );
    });
  }
}

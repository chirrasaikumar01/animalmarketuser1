import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/helper/deep_link_service.dart';
import 'package:animal_market/helper/share_service.dart';
import 'package:animal_market/modules/know_education/model/know_argument.dart';
import 'package:animal_market/modules/know_education/providers/know_education_provider.dart';
import 'package:animal_market/modules/know_education/widgets/filter_know_bottom_sheet.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';

class KnowledgeView extends StatefulWidget {
  final String categoryId;

  const KnowledgeView({super.key, required this.categoryId});

  @override
  State<KnowledgeView> createState() => _KnowledgeViewState();
}

class _KnowledgeViewState extends State<KnowledgeView> {
  late KnowEducationProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = context.read<KnowEducationProvider>();
      provider.reset();
      provider.knowledgeListGet(context, "", "");
      provider.categoryListGet(context);
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
    return Consumer<KnowEducationProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "searchFor",
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
                          /*  Image.asset(
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
                        FilterKnowBottomSheet.show(context, () {
                          state.knowledgeListGet(context, state.categoryId, state.subCategoryId).then((v) {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          });
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
                Builder(
                  builder: (context) {
                    if (state.isLoading) {
                      return Expanded(
                        child: LoaderClass(
                          height: MediaQuery.of(context).size.height - 100,
                        ),
                      );
                    }
                    if (state.filteredList.isEmpty) {
                      return Expanded(
                        child: NoDataClass(
                          height: 500.h,
                          text: "noDataFound",
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.filteredList.length,
                        itemBuilder: (context, index) {
                          var item = state.filteredList[index];
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.knowEducationDetails, arguments: KnowArgument(knowledgeListData: item));
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
                                              state.addRemoveFavourite(context, widget.categoryId, item.id.toString());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(color: ColorConstant.black.withValues(alpha:0.25), borderRadius: BorderRadius.circular(20.dm)),
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                item.isFavourite == 1 ? ImageConstant.fvtSelectedIc : ImageConstant.fvtUnselectedIc,
                                                height: 24.h,
                                                width: 24.w,
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
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
                                        GestureDetector(
                                          onTap: (){
                                            final link = DeepLinkService().generateDeePLink(item.catId.toString(), item.id.toString(), "Knowledge");
                                            final imageUrl = item.image != null && item.image!.isNotEmpty
                                                ? item.image
                                                : "";

                                            if (link.isNotEmpty) {
                                              ShareService.shareProduct(
                                                title: item.title ?? "",
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

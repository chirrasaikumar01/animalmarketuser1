import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/buy_crop/models/crop_argument.dart';
import 'package:animal_market/modules/buy_crop/models/crop_details_model.dart';
import 'package:animal_market/modules/sell_crop/models/add_sell_crop_products_arguments.dart';
import 'package:animal_market/modules/sell_crop/providers/sell_crop_products_provider.dart';
import 'package:animal_market/modules/sell_pet/widgets/delete_product_bottom_sheet.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';

class AllCropProductListWidget extends StatefulWidget {
  final String type;
  final String categoryId;
  final List<CropDetailModel> cropList;

  const AllCropProductListWidget({super.key, required this.type, required this.cropList, required this.categoryId});

  @override
  State<AllCropProductListWidget> createState() => _AllCropProductListWidgetState();
}

class _AllCropProductListWidgetState extends State<AllCropProductListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.cropList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var item = widget.cropList[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.marketCropDetails, arguments: CropArgument(id: item.id.toString(), isUser: true, categoryId: widget.categoryId));
          },
          child: Container(
            padding: EdgeInsets.all(10.h),
            margin: EdgeInsets.only(top: 11.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.dm),
              border: Border.all(color: ColorConstant.borderCl, width: 1.w),
              gradient: LinearGradient(
                colors: [
                  ColorConstant.white,
                  Color(0xFFFAFFEB),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.dm),
                      child: CustomImage(
                        placeholderAsset: ImageConstant.cattleImg,
                        errorAsset: ImageConstant.cattleImg,
                        radius: 10.dm,
                        imageUrl: item.cropImages != null && item.cropImages!.isNotEmpty ? item.cropImages![0].image : "",
                        baseUrl: ApiUrl.imageUrl,
                        height: 70.h,
                        width: 82.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TText(
                                  keyName: "₹${item.price}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.darkAppCl,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    item.verifyStatus == "verified"
                                        ? ImageConstant.verifyIc
                                        : item.verifyStatus == "under_verification"
                                            ? ImageConstant.pendingIc
                                            : item.verifyStatus == "rejected"
                                                ? ImageConstant.cancelIc
                                                : ImageConstant.sellIc,
                                    height: 16.h,
                                    width: 16.w,
                                  ),
                                  SizedBox(width: 4.w),
                                  TText(
                                    keyName: item.verifyStatus == "verified"
                                        ? "verified"
                                        : item.verifyStatus == "under_verification"
                                            ? "underVerified"
                                            : item.verifyStatus == "rejected"
                                                ? "cancel"
                                                : "sold",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: item.verifyStatus == "verified"
                                          ? ColorConstant.appCl
                                          : item.verifyStatus == "under_verification"
                                              ? ColorConstant.pendingCl
                                              : item.verifyStatus == "rejected"
                                                  ? ColorConstant.redCl
                                                  : ColorConstant.blueCl,
                                      fontFamily: FontsStyle.regular,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 4.h),
                          TText(
                            keyName: item.title ?? "",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.textDarkCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: ColorConstant.darkAppCl,
                        borderRadius: BorderRadius.circular(10.dm),
                        border: Border.all(
                          color: ColorConstant.darkAppCl,
                          width: 1.w,
                        ),
                      ),
                      child: TText(
                        keyName: "ID : ${item.uniqueCode}",
                        style: TextStyle(
                          color: ColorConstant.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(
                            ImageConstant.weightIc,
                            height: 16.h,
                            width: 16.w,
                          ),
                          SizedBox(width: 4.w),
                          TText(
                            keyName: "${item.quantity} ${item.quantityType?.toUpperCase()}",
                            style: TextStyle(
                              color: ColorConstant.textLightCl,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.sp,
                              fontFamily: FontsStyle.regular,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                item.verifyStatus == "sold"
                    ? SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<SellCropProductsProvider>(context, listen: false).cropMarkToSold(context, item.id.toString());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.dm),
                                  border: Border.all(color: ColorConstant.blueCl, width: 1.w),
                                ),
                                child: Center(
                                  child: TText(
                                    keyName: "markToSell",
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: ColorConstant.blueCl,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.addCropSellProducts, arguments: AddSellCropProductsArguments(isEdit: true, categoryId: widget.categoryId, id: item.id.toString()));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.dm),
                                  border: Border.all(color: ColorConstant.appCl, width: 1.w),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      ImageConstant.editIc,
                                      height: 20.h,
                                      width: 20.w,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: TText(
                                        keyName: "editInfo",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: ColorConstant.appCl,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          fontFamily: FontsStyle.medium,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                DeleteProductBottomSheet.show(context, () {
                                  Provider.of<SellCropProductsProvider>(context, listen: false).deleteCrop(context, item.id.toString());
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.dm),
                                  border: Border.all(color: ColorConstant.redCl, width: 1.w),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      ImageConstant.deleteOutlineIc,
                                      height: 20.h,
                                      width: 20.w,
                                      color: ColorConstant.redCl,
                                    ),
                                    SizedBox(width: 10.w),
                                    TText(
                                      keyName: "delete",
                                      style: TextStyle(
                                        color: ColorConstant.redCl,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        fontFamily: FontsStyle.medium,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
}

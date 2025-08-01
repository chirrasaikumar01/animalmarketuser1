import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/helper/deep_link_service.dart';
import 'package:animal_market/helper/share_service.dart';
import 'package:animal_market/modules/sell/models/success_argument.dart';
import 'package:animal_market/modules/sell/widgets/benefits_of_selling_container.dart';
import 'package:animal_market/services/api_url.dart';

class SuccessfullyCreatedView extends StatefulWidget {
  final SuccessArgument argument;

  const SuccessfullyCreatedView({super.key, required this.argument});

  @override
  State<SuccessfullyCreatedView> createState() => _SuccessfullyCreatedViewState();
}

class _SuccessfullyCreatedViewState extends State<SuccessfullyCreatedView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 70.h),
          child: CommonAppBar(
            title: "cattleSuccessfullyCreated",
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80.h, width: MediaQuery.of(context).size.width),
              Image.asset(
                ImageConstant.doneIc,
                height: 126.h,
                width: 126.w,
              ),
              SizedBox(height: 27.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.dm),
                  border: Border.all(color: ColorConstant.borderCl),
                  color: ColorConstant.white,
                ),
                child: TText(keyName:
                  "thankYou",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.textDarkCl,
                    fontFamily: FontsStyle.medium,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TText(keyName:
                "yourAnimalIsRegistered",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.appCl,
                  fontFamily: FontsStyle.medium,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: 17.h),
              TText(keyName:
              "waitFor30Minutes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.textDarkCl,
                  fontFamily: FontsStyle.medium,
                  fontStyle: FontStyle.normal,
                ),
              ),
              TText(keyName:
                "waitAnimalIsUnderVerification",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.textDarkCl,
                  fontFamily: FontsStyle.medium,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: 17.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.dm),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFEDD0),
                      Color(0xFFFFEFD3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.dm),
                      child: CustomImage(
                        placeholderAsset: ImageConstant.cattleImg,
                        errorAsset: ImageConstant.cattleImg,
                        radius: 10.dm,
                        imageUrl: widget.argument.image,
                        baseUrl: ApiUrl.imageUrl,
                        height: 80.h,
                        width: 102.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TText(keyName:
                            widget.argument.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.textDarkCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TText(keyName:
                            "₹ ${widget.argument.price}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.darkAppCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 17.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: const BenefitsOfSellingContainer(),
              ),
              SizedBox(height: 150.h),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: ColorConstant.black.withValues(alpha:0.25),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 0),
            ),
          ], color: ColorConstant.white),
          child: Wrap(
            children: [
              CustomButtonWidget(
                style: CustomButtonStyle.style2,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                onPressed: () {
                  final link = DeepLinkService().generateDeePLink(widget.argument.subCategoryId, widget.argument.id.toString(), "Cattle");
                  final imageUrl =widget.argument.image;

                  if (link.isNotEmpty) {
                    ShareService.shareProduct(
                      title: widget.argument.title,
                      imageUrl:"${ApiUrl.imageUrl}$imageUrl",
                      link: link,
                    );
                  }
                },
                text: "",
                iconWidget: Row(
                  children: [
                    TText(keyName:
                      "shareYourAnimalToSellFast",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.textDarkCl,
                        fontFamily: FontsStyle.medium,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Image.asset(
                      ImageConstant.shareLineIc,
                      height: 20.h,
                      width: 20.w,
                      color: ColorConstant.textDarkCl,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/doctor_list/models/doctor_argument.dart';
import 'package:animal_market/modules/doctor_list/providers/doctor_list_provider.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailsView extends StatefulWidget {
  final DoctorArgument argument;

  const DoctorDetailsView({super.key, required this.argument});

  @override
  State<DoctorDetailsView> createState() => _DoctorDetailsViewState();
}

class _DoctorDetailsViewState extends State<DoctorDetailsView> {
  late DoctorListProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = Provider.of<DoctorListProvider>(context, listen: false);
      provider.doctorDetailGet(context, widget.argument.id);
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
    return Consumer<DoctorListProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: const CommonAppBar(
                title: "doctorDetails",
              ),
            ),
            body: Builder(builder: (context) {
              if (state.isLoading1) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorConstant.white,
                            Color(0xFFF8F8D3),
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60.h,
                            width: 60.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.dm),
                              child: CustomImage(
                                placeholderAsset: ImageConstant.demoUserImg,
                                errorAsset: ImageConstant.demoUserImg,
                                radius: 5.dm,
                                imageUrl: state.doctorDetailsModel?.profile,
                                baseUrl: ApiUrl.imageUrl,
                                height: 60.h,
                                width: 60.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TText(keyName:
                                      state.doctorDetailsModel?.clinicName ?? "",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorConstant.textDarkCl,
                                        fontFamily: FontsStyle.medium,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Image.asset(
                                      ImageConstant.verifyIc,
                                      height: 14.h,
                                      width: 14.w,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                TText(keyName:
                                  "Dr. ${state.doctorDetailsModel?.name ?? ""}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.textLightCl,
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                TText(keyName:
                                  "Exp. ${state.doctorDetailsModel?.experience ?? ""} Year",
                                  style: TextStyle(
                                    fontSize: 12.sp,
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
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: ColorConstant.darkAppCl,
                              borderRadius: BorderRadius.circular(4.dm),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageConstant.startIc,
                                  height: 12.h,
                                  width: 12.w,
                                ),
                                TText(keyName:
                                  "4.5",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.white,
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TText(keyName:
                            "aboutDoctor",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.darkAppCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TText(keyName:
                            "  ${state.doctorDetailsModel?.aboutDoctor ?? ""}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.textLightCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          TText(keyName:
                            "image",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.darkAppCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.doctorDetailsModel?.doctorImages?.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              var item = state.doctorDetailsModel?.doctorImages?[index];
                              return index + 1 == state.doctorDetailsModel?.doctorImages?.length
                                  ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.dm),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10.dm),
                                            child: CustomImage(
                                              placeholderAsset: ImageConstant.cattleImg,
                                              errorAsset: ImageConstant.cattleImg,
                                              radius: 10.dm,
                                              imageUrl: item?.image ?? "",
                                              baseUrl: ApiUrl.imageUrl,
                                              height: 115.h,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.dm),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha:0.60),
                                              borderRadius: BorderRadius.circular(10.dm),
                                            ),
                                            child: Center(
                                              child: TText(keyName:
                                                viewAll,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.sp,
                                                  fontFamily: FontsStyle.regular,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10.dm),
                                      child: CustomImage(
                                        placeholderAsset: ImageConstant.cattleImg,
                                        errorAsset: ImageConstant.cattleImg,
                                        radius: 10.dm,
                                        imageUrl: item?.image ?? "",
                                        baseUrl: ApiUrl.imageUrl,
                                        height: 115.h,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    );
                            },
                          ),
                          SizedBox(height: 18.h),
                          Visibility(
                            visible: false,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TText(keyName:
                                    "Reviews (262) ",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorConstant.darkAppCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                                TText(keyName:
                                  "viewAll",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.appCl,
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Visibility(
                            visible: false,
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: 10,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    padding: EdgeInsets.all(10.h),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.white,
                                      borderRadius: BorderRadius.circular(10.dm),
                                      border: Border.all(
                                        color: ColorConstant.borderCl,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 35.h,
                                              width: 35.w,
                                              decoration: BoxDecoration(
                                                color: ColorConstant.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: ColorConstant.appCl,
                                                  width: 1,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.dm),
                                                child: CustomImage(
                                                  placeholderAsset: ImageConstant.cattleImg,
                                                  errorAsset: ImageConstant.cattleImg,
                                                  radius: 35.dm,
                                                  imageUrl: "",
                                                  baseUrl: "",
                                                  height: 35.h,
                                                  width: double.infinity,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  TText(keyName:
                                                    "Rajkumar Sharma",
                                                    style: TextStyle(
                                                      color: ColorConstant.textDarkCl,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 14.sp,
                                                      fontFamily: FontsStyle.semiBold,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      RatingBar.builder(
                                                        initialRating: double.parse(4.toString()),
                                                        minRating: 1,
                                                        ignoreGestures: true,
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 12,
                                                        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                        itemBuilder: (context, _) => Image.asset(
                                                          ImageConstant.startIc,
                                                          height: 12,
                                                          width: 12,
                                                          color: ColorConstant.appCl,
                                                        ),
                                                        onRatingUpdate: (rating) {
                                                          Log.console(rating);
                                                        },
                                                      ),
                                                      SizedBox(width: 2.w),
                                                      TText(keyName:
                                                        "4.5",
                                                        style: TextStyle(
                                                          color: ColorConstant.textLightCl,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 12.sp,
                                                          fontFamily: FontsStyle.regular,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TText(keyName:
                                              "Today",
                                              style: TextStyle(
                                                color: ColorConstant.textLightCl,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.sp,
                                                fontFamily: FontsStyle.regular,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: TText(keyName:
                                            demoString + demoString,
                                            style: TextStyle(
                                              color: ColorConstant.textLightCl,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.sp,
                                              fontFamily: FontsStyle.regular,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 120.h)
                  ],
                ),
              );
            }),
            bottomSheet: state.isLoading1
                ? SizedBox()
                : state.noData
                    ? SizedBox()
                    : widget.argument.isUser
                        ? SizedBox()
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 18.h),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          await launchUrl(
                                            Uri.parse("https://wa.me/+91${state.doctorDetailsModel?.whatsappNo ?? ""}/?text=Hii..."),
                                            mode: LaunchMode.externalApplication,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 14.h),
                                          decoration: BoxDecoration(
                                            color: ColorConstant.white,
                                            borderRadius: BorderRadius.circular(10.dm),
                                            border: Border.all(color: ColorConstant.darkAppCl, width: 1.w),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                ImageConstant.whatsappIc,
                                                width: 16.w,
                                                height: 16.h,
                                              ),
                                              SizedBox(width: 10.w),
                                              TText(keyName:
                                                "chat",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorConstant.darkAppCl,
                                                  fontFamily: FontsStyle.medium,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: CustomButtonWidget(
                                        style: CustomButtonStyle.style2,
                                        padding: EdgeInsets.symmetric(vertical: 14.h),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.appointmentBooking,
                                            arguments: DoctorArgument(
                                              id: widget.argument.id,
                                              isUser: false,
                                              clinicName: widget.argument.clinicName,
                                              name: widget.argument.name,
                                              fees: widget.argument.fees,
                                            ),
                                          );
                                        },
                                        text: "",
                                        iconWidget: TText(keyName:
                                         "bookAppointment",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorConstant.darkAppCl,
                                            fontFamily: FontsStyle.medium,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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

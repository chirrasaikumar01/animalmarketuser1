import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/doctor/models/edit_doctor_argument.dart';
import 'package:animal_market/modules/doctor/providers/doctor_provider.dart';
import 'package:animal_market/modules/sell/widgets/benefits_of_selling_container.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class DoctorView extends StatefulWidget {
  const DoctorView({super.key});

  @override
  State<DoctorView> createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  late DoctorProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<DoctorProvider>();
      provider.doctorHome(context, true);
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
    return Consumer<DoctorProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Builder(builder: (context) {
              if (state.isLoading) {
                return LoaderClass(
                  height: MediaQuery.of(context).size.height - 50,
                );
              }
              return SingleChildScrollView(
                child: state.doctorHomeModel?.isDoctor == 1
                    ? Column(
                        children: [
                          SizedBox(height: 18.h),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: ColorConstant.white,
                              borderRadius: BorderRadius.circular(10.dm),
                              border: Border.all(color: ColorConstant.darkAppCl, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.darkAppCl,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.dm),
                                      bottomRight: Radius.circular(10.dm),
                                    ),
                                  ),
                                  child: TText(
                                    keyName: "drProfile",
                                    style: TextStyle(
                                      color: ColorConstant.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      fontFamily: FontsStyle.semiBold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 48.h,
                                      width: 48.w,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50.dm),
                                        child: CustomImage(
                                          placeholderAsset: ImageConstant.demoUserImg,
                                          errorAsset: ImageConstant.demoUserImg,
                                          radius: 50.dm,
                                          imageUrl: state.doctorHomeModel?.doctor?.profileImage ?? "",
                                          baseUrl: ApiUrl.imageUrl,
                                          height: 48.h,
                                          width: 48.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TText(
                                            keyName: state.doctorHomeModel?.doctor?.name ?? "",
                                            style: TextStyle(
                                              color: ColorConstant.textDarkCl,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.sp,
                                              fontFamily: FontsStyle.semiBold,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          TText(
                                            keyName: "$memberId :${state.doctorHomeModel?.doctor?.memberId}",
                                            style: TextStyle(
                                              color: ColorConstant.textLightCl,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              fontFamily: FontsStyle.semiBold,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.doctorAppointmentList);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.appCl,
                                borderRadius: BorderRadius.circular(10.dm),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TText(
                                    keyName: "myAppointment",
                                    style: TextStyle(
                                      color: ColorConstant.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  Image.asset(
                                    ImageConstant.arrowCircleIc,
                                    height: 24.h,
                                    width: 24.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.doctorAppointmentList);
                                  },
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
                                              ImageConstant.myAppointmentSelectedIc,
                                              height: 20.h,
                                              width: 20.w,
                                            ),
                                            SizedBox(width: 8.w),
                                            TText(
                                              keyName: "${state.doctorHomeModel?.totalAppointment ?? ""}",
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
                                        TText(
                                          keyName: "totalAppointment",
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
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    DateFormat formatter = DateFormat('yyyy-MM-dd');
                                    state.startDate.text = formatter.format(DateTime.now());
                                    state.endDate.text = formatter.format(DateTime.now());
                                    Navigator.pushNamed(context, Routes.doctorAppointmentList);
                                  },
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
                                              ImageConstant.myAppointmentSelectedIc,
                                              height: 20.h,
                                              width: 20.w,
                                            ),
                                            SizedBox(width: 8.w),
                                            TText(
                                              keyName: "${state.doctorHomeModel?.todayAppointment ?? ""}",
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
                                        TText(
                                          keyName: "todayAppointment",
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
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TText(
                               keyName:  "myAppointment",
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  fontFamily: FontsStyle.medium,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.doctorAppointmentList);
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
                          SizedBox(height: 14.h),
                          Builder(
                            builder: (context) {
                              if (state.doctorHomeModel?.myAppointments?.isEmpty ?? true) {
                                return NoDataClass(height: 500, text: noDataFound);
                              }
                              return MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                removeBottom: true,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.doctorHomeModel?.myAppointments?.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    var item = state.doctorHomeModel?.myAppointments?[index];
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 14.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.dm),
                                        border: Border.all(
                                          color: ColorConstant.borderCl,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10.h),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 60.h,
                                                width: 60.w,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(50.dm),
                                                  child: CustomImage(
                                                    placeholderAsset: ImageConstant.demoUserImg,
                                                    errorAsset: ImageConstant.demoUserImg,
                                                    radius: 50.dm,
                                                    imageUrl: item?.patient?.profile ?? "",
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
                                                        TText(
                                                          keyName: item?.patient?.name ?? "",
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
                                                    TText(
                                                      keyName: "Ap. ID: ${item?.appointmentId ?? ""}",
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w400,
                                                        color: ColorConstant.textLightCl,
                                                        fontFamily: FontsStyle.regular,
                                                        fontStyle: FontStyle.normal,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    TText(
                                                      keyName: "+91 ${item?.patient?.mobile ?? ""}",
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
                                            ],
                                          ),
                                          SizedBox(height: 14.h),
                                          Container(
                                            padding: EdgeInsets.all(10.h),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.dm),
                                              border: Border(
                                                left: BorderSide(color: ColorConstant.appCl),
                                              ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0XFFEBFFDA),
                                                  Color(0XFFFFFFFF),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          TText(
                                                            keyName: "appointmentDateAndTime",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: ColorConstant.textDarkCl,
                                                              fontFamily: FontsStyle.medium,
                                                              fontStyle: FontStyle.normal,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Row(
                                                        children: [
                                                          TText(
                                                            keyName: "${item?.date ?? ""} | ${item?.time ?? ""}",
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontWeight: FontWeight.w500,
                                                              color: ColorConstant.textLightCl,
                                                              fontFamily: FontsStyle.regular,
                                                              fontStyle: FontStyle.normal,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Image.asset(
                                                  ImageConstant.dateRangeIc,
                                                  height: 30.h,
                                                  width: 30.w,
                                                  color: ColorConstant.textLightCl,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          item?.status == "cancelled"
                                              ? TText(
                                                  keyName: "cancelled",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorConstant.redCl,
                                                    fontFamily: FontsStyle.regular,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                )
                                              : CustomButtonWidget(
                                                  style: CustomButtonStyle.style2,
                                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                                  onPressed: () {
                                                    state.cancelAppointment(context, item!.appointmentId.toString());
                                                  },
                                                  text: "",
                                                  iconWidget: TText(
                                                    keyName: "cancelAppointment",
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: ColorConstant.darkAppCl,
                                                      fontFamily: FontsStyle.regular,
                                                      fontStyle: FontStyle.normal,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(height: 21.h),
                          Container(
                            decoration: BoxDecoration(
                              color: ColorConstant.white,
                              borderRadius: BorderRadius.circular(10.dm),
                              border: Border.all(color: ColorConstant.borderCl),
                            ),
                            padding: EdgeInsets.all(12.h),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: ColorConstant.white,
                                    border: Border.all(color: ColorConstant.appCl, width: 1.w),
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
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.dm), border: Border.all(color: ColorConstant.textDarkCl)),
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
                                                    fit: BoxFit.fill,
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
                                                color: ColorConstant.darkAppCl.withValues(alpha: 0.30),
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
                                SizedBox(height: 30.h),
                                RTTextSpan(
                                  textAlign: TextAlign.start,
                                  maxChildren: 2,
                                  keyName: 'youAreNotRegisteredAs',
                                  style: TextStyle(
                                    color: ColorConstant.textDarkCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    fontFamily: FontsStyle.semiBold,
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
                                      key: "doctors",
                                      style: TextStyle(
                                        color: ColorConstant.appCl,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                        fontFamily: FontsStyle.semiBold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 9.h),
                                TText(
                                  keyName: "createY",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorConstant.textLightCl,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                TText(
                                  keyName: "withAnimalMarket",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorConstant.textLightCl,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                CustomButtonWidget(
                                  style: CustomButtonStyle.style2,
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  onPressed: () {
                                    Navigator.pushNamed(context, Routes.createAccountDoctor, arguments: EditDoctorArgument(id: '', isEdit: false));
                                  },
                                  text: "",
                                  iconWidget: TText(
                                    keyName: "createDoctorAccount",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.textDarkCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          BenefitsOfSellingContainer(),
                        ],
                      ),
              );
            }),
          ),
        ),
      );
    });
  }
}

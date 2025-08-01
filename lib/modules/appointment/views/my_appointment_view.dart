import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/appointment/providers/appointment_provider.dart';
import 'package:animal_market/modules/dashboard/providers/dashboard_provider.dart';
import 'package:animal_market/services/api_url.dart';

class MyAppointmentView extends StatefulWidget {
  const MyAppointmentView({super.key});

  @override
  State<MyAppointmentView> createState() => _MyAppointmentViewState();
}

class _MyAppointmentViewState extends State<MyAppointmentView> {
  late AppointmentProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = context.read<AppointmentProvider>();
      provider.myAppointmentGet(context, true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(builder: (context, state, child) {
      return Scaffold(
        backgroundColor: ColorConstant.white,
        body: Column(
          children: [
            SizedBox(height: 16.h),
            Builder(builder: (context) {
              if (state.isLoading1) {
                return LoaderClass(height: double.infinity);
              }
              if (state.myAppointmentList.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 100.h, width: MediaQuery.of(context).size.width),
                    Image.asset(
                      ImageConstant.noAppointmentImg,
                      height: 158.h,
                      width: 214.w,
                    ),
                    SizedBox(height: 30.h),
                    TText(keyName:
                      "noAppointmentYet",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.textDarkCl,
                        fontFamily: FontsStyle.medium,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TText(keyName:
                        "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.textLightCl,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: CustomButtonWidget(
                        style: CustomButtonStyle.style2,
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        onPressed: () {
                          Provider.of<DashboardProvider>(context, listen: false).onChangeBaseBottomIndex(context, 3, false, false, true, false);
                        },
                        text: "",
                        iconWidget: TText(keyName:
                          "bookAppointment",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.darkAppCl,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.myAppointmentList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (_, index) {
                    var item = state.myAppointmentList[index];
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
                                  borderRadius: BorderRadius.circular(5.dm),
                                  child: CustomImage(
                                    placeholderAsset: ImageConstant.demoUserImg,
                                    errorAsset: ImageConstant.demoUserImg,
                                    radius: 5.dm,
                                    imageUrl: item.doctor?.profileImage,
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
                                          item.doctor?.clinicName ?? "",
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
                                      "Dr. ${item.doctor?.name ?? ""}",
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
                                      "Exp. ${item.doctor?.experience ?? ""} Year",
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
                                          TText(keyName:
                                            "appointmentDateAndTime",
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
                                          TText(keyName:
                                            "${item.date ?? ""} | ${item.time ?? ""}",
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
                          item.status == "cancelled"
                              ? TText(keyName:
                            cancelled,
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
                                    state.cancelAppointment(context, item.appointmentId.toString());
                                  },
                                  text: "",
                                  iconWidget: TText(keyName:
                                    "cancelAppointment",
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
            }),
          ],
        ),
      );
    });
  }
}

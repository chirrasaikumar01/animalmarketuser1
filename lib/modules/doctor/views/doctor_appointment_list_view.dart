import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/doctor/providers/doctor_provider.dart';
import 'package:animal_market/modules/doctor/widgets/filter_appointment_bottom_sheet.dart';
import 'package:animal_market/services/api_url.dart';

class DoctorAppointmentListView extends StatefulWidget {
  final bool isBottom;

  const DoctorAppointmentListView({super.key, required this.isBottom});

  @override
  State<DoctorAppointmentListView> createState() => _DoctorAppointmentListViewState();
}

class _DoctorAppointmentListViewState extends State<DoctorAppointmentListView> {
  late DoctorProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<DoctorProvider>();
      provider.myAppointmentGet(context, true);
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
    return Consumer<DoctorProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          resizeToAvoidBottomInset: false,
          appBar: widget.isBottom
              ? null
              : PreferredSize(
                  preferredSize: Size(double.infinity, 70.h),
                  child: CommonAppBar(title: "myAppointment"),
                ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: "searchForNameID",
                              borderCl: ColorConstant.borderCl,
                              controller: state.searchKey,
                              fillColor: ColorConstant.white,
                              onChanged: (v) {
                                if (v.isEmpty) {
                                  state.myAppointmentGet(context, false);
                                } else if (v.length > 3) {
                                  state.myAppointmentGet(context, false);
                                }
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
                                 /* Image.asset(
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
                              FilterAppointmentBottomSheet.show(context, () {
                                state.myAppointmentGet(context, false);
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
                      Expanded(
                        child: Builder(builder: (context) {
                          if (state.isLoading1) {
                            return LoaderClass(height: double.infinity);
                          }
                          if (state.myAppointmentList.isEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
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
                                   "demoString",textAlign: TextAlign.center,
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
                              ],
                            );
                          }
                          return ListView.builder(
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
                                            borderRadius: BorderRadius.circular(50.dm),
                                            child: CustomImage(
                                              placeholderAsset: ImageConstant.demoUserImg,
                                              errorAsset: ImageConstant.demoUserImg,
                                              radius: 50.dm,
                                              imageUrl: item.patient?.profile ?? "",
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
                                                    item.patient?.name ?? "",
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
                                                "Ap. ID: ${item.appointmentId ?? ""}",
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
                                                "+91 ${item.patient?.mobile ?? ""}",
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
                                      "cancelled",
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
                          );
                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/doctor/providers/doctor_provider.dart';

class FilterAppointmentBottomSheet {
  static show(BuildContext context, Function() function) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return Consumer<DoctorProvider>(builder: (context, state, child) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  bottom: 20.h + MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  color: ColorConstant.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.dm),
                    topLeft: Radius.circular(16.dm),
                  ),
                ),
                child: Wrap(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 13.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.dm),
                              topLeft: Radius.circular(16.dm),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TText(
                                keyName: "filter",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.regular,
                                  fontSize: 16.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Provider.of<DoctorProvider>(context, listen: false).resetFilter(context);
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  ImageConstant.closeIc,
                                  height: 24.h,
                                  width: 24.w,
                                  color: ColorConstant.textDarkCl,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TText(
                                keyName: "customDateFilter",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.regular,
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TText(
                                          keyName: "startDate",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.regular,
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        CustomTextField(
                                          borderCl: ColorConstant.borderCl,
                                          paddingCustom: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 10.h,
                                          ),
                                          leading1: Image.asset(
                                            ImageConstant.dateRangeIc,
                                            height: 18.h,
                                          ),
                                          onTap: () {
                                            state.dateOfBirthSelect(context, "start");
                                          },
                                          hintText: "DD/MM/YY",
                                          isEnabled: true,
                                          readOnly: true,
                                          controller: state.startDate,
                                          validator: (v) {
                                            if (v!.isEmpty) {
                                              return "Enter Start Date";
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.h),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TText(
                                          keyName: "endDate",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.regular,
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        CustomTextField(
                                          borderCl: ColorConstant.borderCl,
                                          paddingCustom: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 10.h,
                                          ),
                                          leading1: Image.asset(
                                            ImageConstant.dateRangeIc,
                                            height: 18.h,
                                          ),
                                          onTap: () {
                                            state.dateOfBirthSelect(context, "end");
                                          },
                                          hintText: "DD/MM/YY",
                                          isEnabled: true,
                                          readOnly: true,
                                          controller: state.endDate,
                                          validator: (v) {
                                            if (v!.isEmpty) {
                                              return "Enter End Date";
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 60.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButtonWidget(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  style: CustomButtonStyle.style3,
                                  onPressed: () {
                                    Provider.of<DoctorProvider>(context, listen: false).resetFilter(context);
                                    Navigator.pop(context);
                                  },
                                  text: "",
                                  iconWidget: TText(
                                    keyName: "clear",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.appCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.h),
                              Expanded(
                                child: CustomButtonWidget(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  style: CustomButtonStyle.style2,
                                  onPressed: function,
                                  text: "",
                                  iconWidget: TText(
                                    keyName: "apply",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.textDarkCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }
}

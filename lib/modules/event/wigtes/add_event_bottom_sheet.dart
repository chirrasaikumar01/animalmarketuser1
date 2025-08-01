import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/event/providers/event_provider.dart';
import 'package:flutter/cupertino.dart';

class AddEventBottomSheet {
  static show(BuildContext context, Function() function) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return Consumer<EventProvider>(builder: (context, state, child) {
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
                              TText(keyName:
                                "addEvent",
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
                          padding: EdgeInsets.symmetric(horizontal: 13.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 19.h),
                              CustomTextField(
                                borderCl: ColorConstant.borderCl,
                                controller: state.title,
                                paddingCustom: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                hintText: "eventName",
                              ),
                              SizedBox(height: 14.h),
                              CustomTextField(
                                borderCl: ColorConstant.borderCl,
                                controller: state.description,
                                paddingCustom: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                hintText: "typeTheNoteHere",
                                maxCheck: 3,
                              ),
                              SizedBox(height: 14.h),
                              CustomTextField(
                                borderCl: ColorConstant.borderCl,
                                paddingCustom: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                leading1: Image.asset(
                                  ImageConstant.dateRangeIc,
                                  height: 18.h,
                                  color: ColorConstant.gray1Cl,
                                ),
                                hintText: "date",
                                onTap: () {
                                  state.dateSelect(context);
                                },
                                isEnabled: true,
                                readOnly: true,
                                controller: state.eventDate,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return enterEventDate;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 14.h),
                              CustomTextField(
                                borderCl: ColorConstant.borderCl,
                                paddingCustom: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                leading1: Image.asset(
                                  ImageConstant.timeIc,
                                  height: 18.h,
                                  color: ColorConstant.gray1Cl,
                                ),
                                hintText: "startTime",
                                onTap: () {
                                  state.timeSelect(context);
                                },
                                isEnabled: true,
                                readOnly: true,
                                controller: state.startTime,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return enterStartTime;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 14.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TText(keyName:
                                    "remindsMe",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ColorConstant.textLightCl,
                                      fontFamily: FontsStyle.regular,
                                      fontSize: 14.sp,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.9,
                                    child: CupertinoSwitch(
                                      value: state.isRemind,
                                      onChanged: (value) {
                                        state.isRemindChange(value);
                                      },
                                      activeTrackColor: Colors.green,
                                      inactiveTrackColor: Colors.grey.shade300,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 60.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: CustomButtonWidget(
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                            style: CustomButtonStyle.style2,
                            onPressed: function,
                            text: "",
                            iconWidget: TText(keyName:
                              "createEvent",
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

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/appointment/providers/appointment_provider.dart';
import 'package:animal_market/modules/doctor_list/models/doctor_argument.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:intl/intl.dart';

class AppointmentBookingView extends StatefulWidget {
  final DoctorArgument arguments;

  const AppointmentBookingView({super.key, required this.arguments});

  @override
  State<AppointmentBookingView> createState() => _AppointmentBookingViewState();
}

class _AppointmentBookingViewState extends State<AppointmentBookingView> {
  late AppointmentProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = Provider.of<AppointmentProvider>(context, listen: false);
      provider.resetData();
      provider.doctorId = widget.arguments.id.toString();
      provider.fees = widget.arguments.fees.toString();
      provider.initRazorPay();
      provider.userDetails(context);
      provider.selectedDateValue = DateFormat('yyyy-MM-dd').format(DateTime.now());
      provider.timeSlotsList(context, widget.arguments.id.toString(), DateFormat('EEE').format(DateTime.now()).toLowerCase());
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
    return Consumer<AppointmentProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: const CommonAppBar(
                title: appointment,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      TText(keyName:
                        widget.arguments.clinicName,
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
                    "Dr. ${widget.arguments.name}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.textLightCl,
                      fontFamily: FontsStyle.regular,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Divider(color: ColorConstant.borderCl, height: 1.h),
                  SizedBox(height: 14.h),
                  TText(keyName:
                    "bookAppointmentDate",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.textDarkCl,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  DatePicker(
                    DateTime.now(),
                    calendarType: CalendarType.gregorianDate,
                    initialSelectedDate: DateTime.now(),
                    selectionColor: ColorConstant.appCl,
                    deactivatedColor: Colors.white,
                    selectedTextColor: Colors.white,
                    monthTextStyle: TextStyle(
                      color: ColorConstant.appCl,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontsStyle.regular,
                    ),
                    dateTextStyle: TextStyle(
                      color: ColorConstant.appCl,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontsStyle.regular,
                    ),
                    height: 73.h,
                    width: 60.w,
                    dayTextStyle: const TextStyle(
                      color: Colors.transparent,
                      fontSize: 0,
                    ),
                    onDateChange: (date) {
                      state.dateChange(context, date);
                    },
                  ),
                  SizedBox(height: 14.h),
                  TText(keyName:
                    "availableTimeSlots",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.textDarkCl,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state.isLoading) {
                          return LoaderClass(height: 300.h);
                        }
                        if (state.timeSlotList.isEmpty) {
                          return NoDataClass(
                            height: 300.h,
                            text: "noTimeSlots",
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(right: 30.w),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 14.0,
                            childAspectRatio: 4,
                          ),
                          itemCount: state.timeSlotList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                state.timeSlotIdUpdate(state.timeSlotList[index], state.timeSlotList[index].id.toString());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
                                decoration: BoxDecoration(
                                  color: state.selectedTimeSlotId == state.timeSlotList[index].id.toString() ? ColorConstant.appCl : ColorConstant.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: state.selectedTimeSlotId == state.timeSlotList[index].id.toString() ? ColorConstant.appCl : ColorConstant.borderCl,
                                  ),
                                ),
                                child: Center(
                                  child: TText(keyName:
                                    state.timeSlotList[index].timeSlots.toString(),
                                    style: TextStyle(
                                        color: state.selectedTimeSlotId == state.timeSlotList[index].id.toString() ? ColorConstant.white : const Color(0xFF807E7E),
                                        fontFamily: FontsStyle.regular,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
            bottomSheet: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 18.h),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: ColorConstant.black.withValues(alpha: 0.25),
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
                      if (state.selectedTimeSlotId == "0") {
                        errorToast(context, pleaseSelectTimeSlot);
                        return;
                      } else {
                        if (state.fees == "0") {
                          state.appointmentCreate(context);
                        } else {
                          state.sendOrderRazor(context);
                        }
                      }
                    },
                    text: "",
                    iconWidget: TText(keyName:
                      "conti",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.darkAppCl,
                        fontFamily: FontsStyle.medium,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
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

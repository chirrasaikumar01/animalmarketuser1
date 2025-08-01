import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/doctor/providers/time_slot_provider.dart';

class TimeSlotView extends StatefulWidget {
  const TimeSlotView({super.key});

  @override
  State<TimeSlotView> createState() => _TimeSlotViewState();
}

class _TimeSlotViewState extends State<TimeSlotView> {
  late TimeSlotProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<TimeSlotProvider>();
      provider.timeSlotsList(context, "mon");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeSlotProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    TText(keyName:
                      "dayAvailableTimeSlots",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.darkAppCl,
                        fontFamily: FontsStyle.medium,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.dayList.length,
                        itemBuilder: (context, index) {
                          String dayType = state.dayList[index]["type"].toString();
                          bool isSelected = state.selectedDays.contains(dayType);

                          return Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => state.updateSelected(context, dayType),
                                    child: Container(
                                      height: 20.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(
                                        color: isSelected ? ColorConstant.darkAppCl : Colors.white,
                                        border: Border.all(color: ColorConstant.darkAppCl),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: isSelected ? Icon(Icons.done, size: 18, color: Colors.white) : SizedBox(),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  TText(keyName:
                                    state.dayList[index]["name"].toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.darkAppCl,
                                      fontFamily: FontsStyle.medium,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              if (isSelected)
                                state.isDayLoading(dayType) // Check loading for this specific day
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20.h),
                                        child: Center(
                                          child: CircularProgressIndicator(color: ColorConstant.darkAppCl),
                                        ),
                                      )
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.only(right: 30.w),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10.0,
                                          crossAxisSpacing: 14.0,
                                          childAspectRatio: 4,
                                        ),
                                        itemCount: state.timeSlots[dayType]?.length ?? 0,
                                        itemBuilder: (context, timeIndex) {
                                          var timeSlot = state.timeSlots[dayType]![timeIndex];
                                          bool isTimeSelected = state.selectedTimeSlots[dayType]!.contains(timeSlot);
                                          return GestureDetector(
                                            onTap: () => state.updateTimeSlots(dayType, timeSlot),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
                                              decoration: BoxDecoration(
                                                color: isTimeSelected ? ColorConstant.appCl : ColorConstant.white,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: isTimeSelected ? ColorConstant.appCl : ColorConstant.borderCl,
                                                ),
                                              ),
                                              child: Center(
                                                child: TText(keyName:
                                                  timeSlot.timeSlots.toString(),
                                                  style: TextStyle(
                                                    color: isTimeSelected ? Colors.white : const Color(0xFF807E7E),
                                                    fontFamily: FontsStyle.regular,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              SizedBox(height: 12.h),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomButtonWidget(
                      style: CustomButtonStyle.style2,
                      onPressed: () {
                        for (var day in state.selectedDays) {
                          state.addDoctorTimeSlots(context, day);
                        }
                      },
                      text: save,
                    ),
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/doctor/providers/doctor_profile_dashboard_provider.dart';
import 'package:animal_market/modules/doctor/widgets/fab_doctor_bottom_appbar_item.dart';
import 'package:animal_market/routes/routes.dart';

class DoctorProfileDashboardView extends StatefulWidget {
  const DoctorProfileDashboardView({super.key});

  @override
  State<DoctorProfileDashboardView> createState() => _DoctorProfileDashboardViewState();
}

class _DoctorProfileDashboardViewState extends State<DoctorProfileDashboardView> {
  late final DoctorProfileDashboardProvider provider;

  @override
  void initState() {
    provider = context.read<DoctorProfileDashboardProvider>();
    provider.baseActiveBottomIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProfileDashboardProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 75.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: ColorConstant.white,
                  border: Border(
                    bottom: BorderSide(
                      color: ColorConstant.borderCl,
                      width: 1.w,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TText(keyName:
                                "drProfile",
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                  fontFamily: FontsStyle.semiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.event);
                      },
                      child: Image.asset(
                        ImageConstant.calendarIc,
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.notifications);
                      },
                      child: Image.asset(
                        ImageConstant.notificationIc,
                        height: 40.h,
                        width: 40.w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.doctorAccount);
                      },
                      child: Image.asset(
                        ImageConstant.userIc,
                        height: 32.h,
                        width: 32.w,
                      ),
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: ColorConstant.white,
            body: state.baseWidgets[state.baseActiveBottomIndex],
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.transparent),
              height: 70.h,
              child: FABDoctorBottomAppBar(
                backgroundColor: Colors.white,
                color: ColorConstant.textLightCl,
                selectedColor: ColorConstant.appCl,
                iconSize: 24,
                height: 70,
                items: [
                  FabDoctorBottomAppbarItem(
                    iconData: ImageConstant.homeIc,
                    text: "home",
                    selectedIconData: ImageConstant.homeSelectedIc,
                  ),
                  FabDoctorBottomAppbarItem(
                    iconData: ImageConstant.myAppointmentIc,
                    text: "myAppointment",
                    selectedIconData: ImageConstant.myAppointmentSelectedIc,
                  ),
                  FabDoctorBottomAppbarItem(
                    iconData: ImageConstant.slotUnselectedIc,
                    text: "slots",
                    selectedIconData: ImageConstant.slotSelectedIc,
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

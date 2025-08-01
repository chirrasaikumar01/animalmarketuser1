
import 'package:animal_market/common_model/dashboard_arguments.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/dashboard/providers/dashboard_provider.dart';
import 'package:animal_market/modules/dashboard/widgets/dashboard_app_bar.dart';
import 'package:animal_market/modules/dashboard/widgets/fab_bottom_appbar_item.dart';

class DoctorDashboardView extends StatefulWidget {
  final DashboardArguments arguments;

  const DoctorDashboardView({super.key, required this.arguments});

  @override
  State<DoctorDashboardView> createState() => _DoctorDashboardViewState();
}

class _DoctorDashboardViewState extends State<DoctorDashboardView> {
  late final DashboardProvider dashboardProvider;

  @override
  void initState() {
    dashboardProvider = context.read<DashboardProvider>();
    dashboardProvider.baseActiveBottomIndex = 1;
    super.initState();
  }

  @override
  void dispose() {
    dashboardProvider.baseActiveBottomIndex = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 75.h),
              child: const DashboardAppBar(),
            ),
            backgroundColor: ColorConstant.white,
            body: state.doctorWidgets[state.baseActiveBottomIndex],
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.transparent),
              height: 70.h,
              child: FABBottomAppBar(
                backgroundColor: Colors.white,
                color: ColorConstant.textLightCl,
                selectedColor: ColorConstant.appCl,
                iconSize: 24,
                height: 70,
                items: [
                  FABBottomAppBarItem(
                    iconData: ImageConstant.homeIc,
                    text: "home",
                    selectedIconData: ImageConstant.homeIc,
                    isCommunity: false,
                    isFast: widget.arguments.isFast,
                    isDoctor: true,
                    isCattle: false,
                  ),
                  FABBottomAppBarItem(
                    iconData: ImageConstant.myAppointmentIc,
                    text:"myAppointment",
                    selectedIconData: ImageConstant.myAppointmentSelectedIc,
                    isCommunity: false,
                    isFast: widget.arguments.isFast,
                    isDoctor: true, isCattle: false,
                  ),
                  FABBottomAppBarItem(
                    iconData: ImageConstant.communityIc,
                    text: "community",
                    selectedIconData: ImageConstant.communityIc,
                    isCommunity: false,
                    isFast: widget.arguments.isFast,
                    isDoctor: true,
                    isCattle: false,
                  ),
                  FABBottomAppBarItem(
                    iconData: ImageConstant.doctorsIc,
                    text: "doctors",
                    selectedIconData: ImageConstant.doctorsSelectedIc,
                    isCommunity: false,
                    isFast: widget.arguments.isFast,
                    isDoctor: true,
                    isCattle: false,
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

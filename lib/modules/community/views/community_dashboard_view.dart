
import 'package:animal_market/common_model/dashboard_arguments.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/dashboard/providers/dashboard_provider.dart';
import 'package:animal_market/modules/dashboard/widgets/dashboard_app_bar.dart';
import 'package:animal_market/modules/dashboard/widgets/fab_bottom_appbar_item.dart';

class CommunityDashboardView extends StatefulWidget {
  final DashboardArguments arguments;

  const CommunityDashboardView({super.key, required this.arguments});

  @override
  State<CommunityDashboardView> createState() => _CommunityDashboardViewState();
}

class _CommunityDashboardViewState extends State<CommunityDashboardView> {
  late final DashboardProvider dashboardProvider;

  @override
  void initState() {
    dashboardProvider = context.read<DashboardProvider>();
    dashboardProvider.baseActiveBottomIndex = 1;
    dashboardProvider.categoryId = widget.arguments.categoryId;
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
            body: state.communityWidgets[state.baseActiveBottomIndex],
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.transparent),
              height: 70.h,
              child: FABBottomAppBar(
                backgroundColor: Colors.white,
                color: ColorConstant.textLightCl,
                selectedColor: ColorConstant.appCl,
                iconSize: 24.h,
                height: 70.h,
                items: [
                  FABBottomAppBarItem(
                    iconData: ImageConstant.homeIc,
                    text: "home",
                    selectedIconData: ImageConstant.homeIc,
                    isCommunity: true,
                    isFast: widget.arguments.isFast,
                    isDoctor: false,
                    isCattle: false,
                  ),
                  FABBottomAppBarItem(
                    iconData: ImageConstant.allPostUnselectedIc,
                    text: "allPost",
                    selectedIconData: ImageConstant.allPostSelectedIc,
                    isCommunity: true,
                    isFast: widget.arguments.isFast,
                    isDoctor: false,
                    isCattle: false,
                  ),
                  FABBottomAppBarItem(
                    iconData: ImageConstant.myPostUnselectedIc,
                    text: "myPost",
                    selectedIconData: ImageConstant.myPostSelectedIc,
                    isCommunity: true,
                    isFast: widget.arguments.isFast,
                    isDoctor: false,
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

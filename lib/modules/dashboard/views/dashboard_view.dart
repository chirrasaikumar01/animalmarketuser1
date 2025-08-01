
import 'package:animal_market/common_model/dashboard_arguments.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/dashboard/providers/dashboard_provider.dart';
import 'package:animal_market/modules/dashboard/widgets/dashboard_app_bar.dart';
import 'package:animal_market/modules/dashboard/widgets/fab_bottom_appbar_item.dart';

class DashboardView extends StatefulWidget {
  final DashboardArguments arguments;

  const DashboardView({super.key, required this.arguments});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late final DashboardProvider dashboardProvider;

  @override
  void initState() {
    dashboardProvider = context.read<DashboardProvider>();
    dashboardProvider.baseActiveBottomIndex = 1;
    dashboardProvider.categoryId = widget.arguments.categoryId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 85.h),
              child: const DashboardAppBar(),
            ),
            backgroundColor: ColorConstant.white,
            body: widget.arguments.categoryId == "1"
                ? state.baseCattleWidgets[state.baseActiveBottomIndex]
                : widget.arguments.categoryId == "2"
                    ? state.baseCropWidgets[state.baseActiveBottomIndex]
                    : widget.arguments.categoryId == "3"
                        ? state.basePetWidgets[state.baseActiveBottomIndex]
                        : state.baseWidgets[state.baseActiveBottomIndex],
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.transparent),
              height: 75.h,
              child: FABBottomAppBar(
                backgroundColor: Colors.white,
                color: ColorConstant.textLightCl,
                selectedColor: ColorConstant.appCl,
                iconSize: 24,
                height: 75,
                items: [
                  FABBottomAppBarItem(
                    iconData: ImageConstant.homeIc,
                    text: "home",
                    selectedIconData: ImageConstant.homeIc,
                    isCommunity: false,
                    isFast: true,
                    isDoctor: false,
                    isCattle: widget.arguments.categoryId == "1" ? true : false,
                  ),
                  FABBottomAppBarItem(
                    iconData: widget.arguments.categoryId == "1"
                        ? ImageConstant.buyIc
                        : widget.arguments.categoryId == "2"
                            ? ImageConstant.inactiveBuyCropIc
                            : ImageConstant.inactiveBuyPetIc,
                    text: "buy",
                    selectedIconData: widget.arguments.categoryId == "1"
                        ? ImageConstant.buyActiveIc
                        : widget.arguments.categoryId == "2"
                            ? ImageConstant.activeBuyCropIc
                            : ImageConstant.activeBuyPertIc,
                    isCommunity: false,
                    isDoctor: false,
                    isFast: true,
                    isCattle: widget.arguments.categoryId == "1" ? true : false,
                  ),
                  FABBottomAppBarItem(
                    iconData: widget.arguments.categoryId == "1"
                        ? ImageConstant.sellIc
                        : widget.arguments.categoryId == "2"
                            ? ImageConstant.inactiveSellCropIc
                            : ImageConstant.inactiveSellPetIc,
                    text: "sell",
                    selectedIconData: widget.arguments.categoryId == "1"
                        ? ImageConstant.sellActiveIc
                        : widget.arguments.categoryId == "2"
                            ? ImageConstant.activeSellCropIc
                            : ImageConstant.activeSellPetIc,
                    isCommunity: false,
                    isFast: true,
                    isDoctor: false,
                    isCattle: widget.arguments.categoryId == "1",
                  ),
                  FABBottomAppBarItem(
                    iconData: ImageConstant.communityIc,
                    text: "community",
                    selectedIconData: ImageConstant.communitySelectedIc,
                    isCommunity: false,
                    isDoctor: false,
                    isFast: true,
                    isCattle: widget.arguments.categoryId == "1" ? true : false,
                  ),
                  FABBottomAppBarItem(
                    iconData: ImageConstant.doctorsIc,
                    text: "doctors",
                    selectedIconData: ImageConstant.doctorsSelectedIc,
                    isCommunity: false,
                    isFast: true,
                    isDoctor: false,
                    isCattle: widget.arguments.categoryId == "1" ? true : false,
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

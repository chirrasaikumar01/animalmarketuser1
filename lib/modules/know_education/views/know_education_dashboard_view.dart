
import 'package:animal_market/common_model/dashboard_arguments.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/dashboard/providers/dashboard_provider.dart';
import 'package:animal_market/modules/dashboard/widgets/dashboard_app_bar.dart';
import 'package:animal_market/modules/dashboard/widgets/fab_bottom_appbar_item.dart';

class KnowEducationDashboardView extends StatefulWidget {
  final DashboardArguments arguments;

  const KnowEducationDashboardView({super.key, required this.arguments});

  @override
  State<KnowEducationDashboardView> createState() => _KnowEducationDashboardViewState();
}

class _KnowEducationDashboardViewState extends State<KnowEducationDashboardView> {
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
        return
        /*  PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return;
            }
            final navigator = Navigator.of(context);
            bool willLeave = false;

            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: ColorConstant.white,
                title: TText(keyName:
                  'Are you sure you want to exit?',
                  style: TextStyle(
                    color: ColorConstant.textDarkCl,
                    fontFamily: FontsStyle.medium,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.sp,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      willLeave = true;
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.appCl,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: TText(keyName:
                      'Yes',
                      style: TextStyle(
                        color: ColorConstant.white,
                        fontFamily: FontsStyle.medium,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: TText(keyName:
                      'No',
                      style: TextStyle(
                        color: ColorConstant.appCl,
                        fontFamily: FontsStyle.medium,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
            if (willLeave) {
              navigator.pop();
            }
          },
          child:*/
          SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(double.infinity, 75.h),
                child: const DashboardAppBar(),
              ),
              backgroundColor: ColorConstant.white,
              body: state.knowEducationWidgets[state.baseActiveBottomIndex],
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
                      text: "knowledge",
                      selectedIconData: ImageConstant.allPostSelectedIc,
                      isCommunity: true,
                      isFast: widget.arguments.isFast,
                      isDoctor: false,
                      isCattle: false,
                    ),
                    FABBottomAppBarItem(
                      iconData: ImageConstant.fvtUnselectedIc,
                      text: "favorite",
                      selectedIconData: ImageConstant.fvtSelectedIc,
                      isCommunity: true,
                      isFast: widget.arguments.isFast,
                      isDoctor: false,
                      isCattle: false,
                    ),
                  ],
                ),
              ),
            ),
        //  ),
        );
      },
    );
  }
}

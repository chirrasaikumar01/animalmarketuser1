import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/auth/models/location_argument.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/category/providers/category_provider.dart';
import 'package:animal_market/modules/sell/providers/sell_products_provider.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:animal_market/routes/routes.dart';

class DashboardAppBar extends StatefulWidget {
  const DashboardAppBar({super.key});

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  late AccountProvider accountProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountProvider = context.read<AccountProvider>();
      accountProvider.getProfile(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<SellProductsProvider,TranslationsProvider,CategoryProvider>(builder: (context, state,state2,state3, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                      Consumer<AccountProvider>(builder: (context, state, child) {
                        return Expanded(
                          child: TText(keyName:
                            "${state2.tr("namaste")},${state.user?.name ?? ""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ColorConstant.textDarkCl,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                              fontFamily: FontsStyle.semiBold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  InkWell(
                    onTap: () async {
                      var result = await Navigator.pushNamed(
                        context,
                        Routes.location,
                        arguments: LocationArgument(isEdit: true),
                      );
                      if (result != null && result is LocationModel) {
                        state.locationUpdate(result);
                      }
                      if (result == "200") {
                        state.getLocationStatus();
                      } else {
                        Log.console("No result received from location screen.");
                      }
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          ImageConstant.locationArrow,
                          height: 20.h,
                          width: 20.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              var result = await Navigator.pushNamed(
                                context,
                                Routes.location,
                                arguments: LocationArgument(isEdit: true),
                              );
                              if (result != null && result is LocationModel) {
                                state.locationUpdate(result);
                              }
                              if (result == "200") {
                                state.getLocationStatus();
                              } else {
                                Log.console("No result received from location screen.");
                              }
                            },
                            child: TText(keyName:
                              state.addressLocation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorConstant.textLightCl,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                fontFamily: FontsStyle.semiBold,
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
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.event);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    ImageConstant.calendarIc,
                    height: 24.h,
                    width: 24.w,
                  ),
                  state3.todayEventCount=="0"?SizedBox(): Positioned(
                    top: -7,
                    right: -5,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.redCl,
                        shape: BoxShape.circle,
                      ),
                      child: TText(
                        keyName: state3.todayEventCount,
                        style: TextStyle(
                          color: ColorConstant.white,
                          fontSize: 10.sp,
                          fontFamily: FontsStyle.semiBold,
                          fontWeight: FontWeight.w600,
                        ),),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.notifications);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    ImageConstant.notificationIc,
                    height: 40.h,
                    width: 40.w,
                  ),
                  state3.unreadNotiCount=="0"?SizedBox():  Positioned(
                    top: 1,
                    right: 5,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.redCl,
                        shape: BoxShape.circle,
                      ),
                      child: TText(
                        keyName: state3.unreadNotiCount,
                        style: TextStyle(
                          color: ColorConstant.white,
                          fontSize: 10.sp,
                          fontFamily: FontsStyle.semiBold,
                          fontWeight: FontWeight.w600,
                        ),),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.account);
              },
              child: Image.asset(
                ImageConstant.userIc,
                height: 32.h,
                width: 32.w,
              ),
            )
          ],
        ),
      );
    });
  }
}

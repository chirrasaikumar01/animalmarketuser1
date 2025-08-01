import 'package:animal_market/common_model/dashboard_arguments.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/community/views/community_view.dart';
import 'package:animal_market/modules/dashboard/widgets/dashboard_app_bar.dart';

class CommunityHomeView extends StatefulWidget {
  final DashboardArguments arguments;

  const CommunityHomeView({super.key, required this.arguments});

  @override
  State<CommunityHomeView> createState() => _CommunityHomeViewState();
}

class _CommunityHomeViewState extends State<CommunityHomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 75.h),
          child: const DashboardAppBar(),
        ),
        backgroundColor: ColorConstant.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Row(
                children: [
                  TText(keyName:
                    "select",
                    style: TextStyle(
                      color: ColorConstant.textDarkCl,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      fontFamily: FontsStyle.semiBold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TText(keyName:
                  " ",
                    style: TextStyle(
                      color: ColorConstant.appCl,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      fontFamily: FontsStyle.semiBold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TText(keyName:
                    "community",
                    style: TextStyle(
                      color: ColorConstant.appCl,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      fontFamily: FontsStyle.semiBold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CommunityView(
                                categoryId: "1",
                                isBottom: false,
                              )));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(9.w),
                  decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(10.dm),
                    boxShadow: [
                      BoxShadow(
                        color: ColorConstant.lightShadowCl.withValues(alpha:0.38),
                        offset: const Offset(0, 0),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TText(keyName:
                              "cattle",
                              style: TextStyle(
                                color: ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            TText(keyName:
                              "community",
                              style: TextStyle(
                                color: ColorConstant.appCl,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(height: 34.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.appCl,
                                borderRadius: BorderRadius.circular(20.dm),
                              ),
                              child: Image.asset(
                                ImageConstant.arrowRightIc,
                                color: ColorConstant.white,
                                height: 18.w,
                                width: 18.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 11.w),
                      Image.asset(
                        ImageConstant.cattleImg,
                        width: 147.w,
                        height: 119.h,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CommunityView(
                                categoryId: "3",
                                isBottom: false,
                              )));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(9.w),
                  decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(10.dm),
                    boxShadow: [
                      BoxShadow(
                        color: ColorConstant.lightShadowCl.withValues(alpha:0.38),
                        offset: const Offset(0, 0),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        ImageConstant.carePetImg,
                        width: 147.w,
                        height: 119.h,
                      ),
                      SizedBox(width: 11.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TText(keyName:
                              "pet",
                              style: TextStyle(
                                color: ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            TText(keyName:
                              "community",
                              style: TextStyle(
                                color: ColorConstant.appCl,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(height: 34.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.appCl,
                                borderRadius: BorderRadius.circular(20.dm),
                              ),
                              child: Image.asset(
                                ImageConstant.arrowRightIc,
                                color: ColorConstant.white,
                                height: 18.w,
                                width: 18.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CommunityView(
                                categoryId: "2",
                                isBottom: false,
                              )));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(9.w),
                  decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(10.dm),
                    boxShadow: [
                      BoxShadow(
                        color: ColorConstant.lightShadowCl.withValues(alpha:0.38),
                        offset: const Offset(0, 0),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TText(keyName:
                             "crop",
                              style: TextStyle(
                                color: ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            TText(keyName:
                            "community",
                              style: TextStyle(
                                color: ColorConstant.appCl,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(height: 34.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.appCl,
                                borderRadius: BorderRadius.circular(20.dm),
                              ),
                              child: Image.asset(
                                ImageConstant.arrowRightIc,
                                color: ColorConstant.white,
                                height: 18.w,
                                width: 18.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 11.w),
                      Image.asset(
                        ImageConstant.cropImg,
                        width: 147.w,
                        height: 119.h,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

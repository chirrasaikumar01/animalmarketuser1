import 'package:animal_market/common_model/dashboard_arguments.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/helper/deep_link_service.dart';
import 'package:animal_market/helper/push_notification_service.dart';
import 'package:animal_market/modules/app_update_provider/app_update_provider.dart';
import 'package:animal_market/modules/category/providers/category_provider.dart';
import 'package:animal_market/modules/dashboard/widgets/dashboard_app_bar.dart';
import 'package:animal_market/modules/sell/providers/sell_products_provider.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late CategoryProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<CategoryProvider>();
      provider.categoryListGet(context,true);
     // Provider.of<AppUpdateProvider>(context, listen: false).appDownload(context);
      Provider.of<AppUpdateProvider>(context, listen: false).checkForUpdate(context);
      Provider.of<SellProductsProvider>(context, listen: false).getLocationStatus();
      PushNotificationService.init(context);
      DeepLinkService().init();
      fcmToken();
    });
    super.initState();
  }

  void fcmToken() async {
    var fcm = await PushNotificationService.getFCMToken();
    Log.console("fcm $fcm");
    if (mounted) {
      provider.fcmUpdate(context, fcm ?? "");
    }
  }

  @override
  void dispose() {
    provider.isLoading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CategoryProvider, TranslationsProvider>(
      builder: (context, state, state1, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(preferredSize: Size(double.infinity, 75.h), child: DashboardAppBar()),
            body: Builder(
              builder: (context) {
                if (state.isLoading) {
                  return LoaderClass(height: MediaQuery.of(context).size.height - 200.h);
                }
                if (state.categoryList.isEmpty) {
                  return NoDataClass(
                    height: MediaQuery.of(context).size.height - 200.h,
                    text: noDataFound,
                  );
                }
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            TText(
                              keyName: state1.tr("select"),
                              style: TextStyle(
                                color: ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            TText(
                              keyName: state1.tr("service"),
                              textAlign: TextAlign.start,
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
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                final Map<String, String> categoryRoutes = {
                                  "1": Routes.dashboard,
                                  "2": Routes.dashboard,
                                  "3": Routes.dashboard,
                                  "4": Routes.communityHome,
                                  "5": Routes.knowEducationDashboard,
                                };
                                String? route = categoryRoutes[state.categoryList.first.id.toString()];
                                if (route != null) {
                                  Navigator.pushNamed(
                                    context,
                                    route,
                                    arguments: DashboardArguments(isFast: true, categoryId: state.categoryList.first.id.toString()),
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ColorConstant.darkAppCl,
                                  borderRadius: BorderRadius.circular(10.dm),
                                  border: Border.all(color: ColorConstant.borderCl),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEFFFE5),
                                      ColorConstant.white,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(height: 12.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                                            child: TText(
                                              keyName: state.categoryList.first.title ?? "",
                                              style: TextStyle(
                                                color: ColorConstant.textDarkCl,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                                fontFamily: FontsStyle.semiBold,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                                            child: TText(
                                              keyName: state.categoryList.first.subHeading ?? "",
                                              style: TextStyle(
                                                color: ColorConstant.textLightCl,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10.sp,
                                                fontFamily: FontsStyle.semiBold,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 65.h),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                                              decoration: BoxDecoration(
                                                color: ColorConstant.appCl,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(10.dm),
                                                  topRight: Radius.circular(10.dm),
                                                ),
                                              ),
                                              child: Image.asset(
                                                ImageConstant.arrowRightIc,
                                                color: ColorConstant.white,
                                                height: 22.w,
                                                width: 22.w,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 8.h),
                                        CustomImage(
                                          placeholderAsset: ImageConstant.demoCategory,
                                          errorAsset: ImageConstant.demoCategory,
                                          radius: 10.dm,
                                          imageUrl: state.categoryList.first.image,
                                          baseUrl: ApiUrl.imageUrl,
                                          height: 117.h,
                                          width: 164.w,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(height: 14.h),
                                      ],
                                    ),
                                    SizedBox(width: 12.w),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 8.h,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: state.categoryList.length - 1,
                              itemBuilder: (context, index) {
                                var e = state.categoryList[index + 1];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(20.dm),
                                  splashColor: ColorConstant.appCl.withValues(alpha: 0.2),
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    final Map<String, String> categoryRoutes = {
                                      "1": Routes.dashboard,
                                      "2": Routes.dashboard,
                                      "3": Routes.dashboard,
                                      "4": Routes.communityHome,
                                      "5": Routes.knowEducationDashboard,
                                    };
                                    String? route = categoryRoutes[e.id.toString()];
                                    if (route != null) {
                                      Navigator.pushNamed(
                                        context,
                                        route,
                                        arguments: DashboardArguments(isFast: true, categoryId: e.id.toString()),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.darkAppCl,
                                      borderRadius: BorderRadius.circular(10.dm),
                                      border: Border.all(color: ColorConstant.borderCl),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFEFFFE5),
                                          ColorConstant.white,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 11.h),
                                            TText(
                                              keyName: e.title ?? "",
                                              style: TextStyle(
                                                color: ColorConstant.textDarkCl,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                                fontFamily: FontsStyle.semiBold,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                            TText(
                                              keyName: e.subHeading ?? "",
                                              style: TextStyle(
                                                color: ColorConstant.textLightCl,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10.sp,
                                                fontFamily: FontsStyle.semiBold,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: CustomImage(
                                            placeholderAsset: ImageConstant.demoCategory,
                                            radius: 10.dm,
                                            imageUrl: e.image,
                                            baseUrl: ApiUrl.imageUrl,
                                            height: 117.h,
                                            width: 170.w,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: false,
                          child: MediaQuery.removePadding(
                            context: context,
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1 / 1.15,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                crossAxisCount: 2,
                              ),
                              itemCount: state.categoryList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (state.categoryList[index].id.toString() == "1") {
                                      Navigator.pushNamed(context, Routes.dashboard, arguments: DashboardArguments(isFast: true, categoryId: state.categoryList[index].id.toString()));
                                    } else if (state.categoryList[index].id.toString() == "2") {
                                      Navigator.pushNamed(context, Routes.dashboard, arguments: DashboardArguments(isFast: true, categoryId: state.categoryList[index].id.toString()));
                                    } else if (state.categoryList[index].id.toString() == "3") {
                                      Navigator.pushNamed(context, Routes.dashboard, arguments: DashboardArguments(isFast: true, categoryId: state.categoryList[index].id.toString()));
                                    } else if (state.categoryList[index].id.toString() == "4") {
                                      Navigator.pushNamed(context, Routes.communityHome, arguments: DashboardArguments(isFast: true, categoryId: state.categoryList[index].id.toString()));
                                    } else if (state.categoryList[index].id.toString() == "5") {
                                      Navigator.pushNamed(context, Routes.knowEducationDashboard, arguments: DashboardArguments(isFast: true, categoryId: state.categoryList[index].id.toString()));
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.white,
                                      borderRadius: BorderRadius.circular(20.dm),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorConstant.lightShadowCl.withValues(alpha: 0.38),
                                          offset: const Offset(0, 0),
                                          blurRadius: 8,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10.h),
                                        Expanded(
                                          child: CustomImage(
                                            placeholderAsset: ImageConstant.demoCategory,
                                            radius: 10.dm,
                                            imageUrl: state.categoryList[index].image,
                                            baseUrl: ApiUrl.imageUrl,
                                            height: 115.h,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

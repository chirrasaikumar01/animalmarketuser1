import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/notifications/providers/notifications_providers.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late NotificationsProviders provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<NotificationsProviders>();
      provider.notificationListGet(context);
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
    return Consumer<NotificationsProviders>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(title: "notification"),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                children: [
                  SizedBox(height: 14.h),
                  Builder(
                    builder: (context) {
                      if (state.isLoading) {
                        return Expanded(
                          child: LoaderClass(
                            height: MediaQuery.of(context).size.height - 100,
                          ),
                        );
                      }
                      if (state.notificationList.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: 150.h, width: MediaQuery.of(context).size.width),
                            Image.asset(
                              ImageConstant.mailboxIc,
                              height: 111.h,
                              width: 111.w,
                            ),
                            SizedBox(height: 20.h),
                            TText(keyName:
                              "noNotificationYet",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.textDarkCl,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60.w),
                              child: TText(keyName:
                                "yourNotificationWill",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.textLightCl,
                                  fontFamily: FontsStyle.medium,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: 50.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60.w),
                              child: CustomButtonWidget(
                                style: CustomButtonStyle.style2,
                                padding: EdgeInsets.symmetric(vertical: 13.h),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: "",
                                iconWidget: TText(keyName:
                                  "backToHome",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.darkAppCl,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.notificationList.length,
                          itemBuilder: (context, index) {
                            var item = state.notificationList[index];
                            return GestureDetector(
                              onTap: (){
                                if (item.url != null) {
                                  final uri = Uri.tryParse(item.url??"");
                                  if (uri != null) {
                                   state.handleLink(uri);
                                  } else {
                                    Log.console("Invalid URL format: $item.url");
                                  }
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 14.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.dm),
                                  border: Border.all(
                                    color: ColorConstant.borderCl,
                                    width: 1.w,
                                  ),
                                  color: ColorConstant.white,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color: ColorConstant.borderCl,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10.dm),
                                              topRight: Radius.circular(10.dm),
                                            ),
                                          ),
                                          child: TText(keyName:
                                            state.formatDate(item.createdAt ?? ""),
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: ColorConstant.textDarkCl,
                                              fontFamily: FontsStyle.medium,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.w, right: 15.w, bottom: 24.h),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        item.image!=""?  SizedBox(
                                            height: 70.h,
                                            width: 70.w,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.dm),
                                              child: CustomImage(
                                                placeholderAsset: ImageConstant.cattleImg,
                                                errorAsset: ImageConstant.cattleImg,
                                                radius: 10.dm,
                                                imageUrl: "",
                                                baseUrl: "",
                                                height: 70.h,
                                                width: 70.w,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ):SizedBox.shrink(),
                                          SizedBox(width: 11.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TText(keyName:
                                                        item.title ?? "",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w700,
                                                          color: ColorConstant.textDarkCl,
                                                          fontFamily: FontsStyle.semiBold,
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 7.h),
                                                TText(keyName:
                                                  item.message ?? "",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorConstant.textLightCl,
                                                    fontFamily: FontsStyle.regular,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
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

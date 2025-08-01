import 'dart:io';

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/account/widgets/delete_account_bottom_sheet.dart';
import 'package:animal_market/modules/account/widgets/delete_reason_bottom_sheet.dart';
import 'package:animal_market/modules/account/widgets/logout_bottom_sheet.dart';
import 'package:animal_market/modules/account/widgets/menu_item_container.dart';
import 'package:animal_market/modules/app_update_provider/app_update_provider.dart';
import 'package:animal_market/modules/cms/models/cms_arguments.dart';
import 'package:animal_market/modules/doctor/models/edit_doctor_argument.dart';
import 'package:animal_market/modules/doctor/providers/doctor_provider.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorAccountView extends StatefulWidget {
  const DoctorAccountView({super.key});

  @override
  State<DoctorAccountView> createState() => _DoctorAccountViewState();
}

class _DoctorAccountViewState extends State<DoctorAccountView> {
  late DoctorProvider doctorProvider;
  late AccountProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<AccountProvider>();
      provider.reasonsList(context);
      provider.getProfile(context);
      doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
      doctorProvider.doctorHome(context, true);
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
    return Consumer3<DoctorProvider, AccountProvider,TranslationsProvider>(builder: (context, dState, state,state2, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 70.h),
            child: CommonAppBar(
              title: "account",
              action: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                ],
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorConstant.appBarClOne,
                      ColorConstant.appBarClSecond,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.h,
                          width: 60.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.dm),
                            child: CustomImage(
                              placeholderAsset: ImageConstant.demoUserImg,
                              errorAsset: ImageConstant.demoUserImg,
                              radius: 120.dm,
                              imageUrl: state.imageUrl,
                              baseUrl: ApiUrl.imageUrl,
                              height: 60.h,
                              width: 60.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TText(keyName:
                                state.name.text,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.medium,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    ImageConstant.locationFillIc,
                                    height: 20.h,
                                    width: 20.w,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Expanded(
                                    child: TText(keyName:
                                      state.address.text,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.textLightCl,
                                        fontFamily: FontsStyle.regular,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.createAccountDoctor, arguments: EditDoctorArgument(id: dState.doctorHomeModel!.doctor!.id!.toString(), isEdit: true));
                          },
                          child: Container(
                            padding: EdgeInsets.all(3.h),
                            decoration: BoxDecoration(
                              color: ColorConstant.white,
                              borderRadius: BorderRadius.circular(4.dm),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorConstant.black.withValues(alpha:0.25),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 1),
                                )
                              ],
                            ),
                            child: Image.asset(
                              ImageConstant.editIc,
                              height: 24.h,
                              width: 24.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Divider(
                      color: ColorConstant.borderCl,
                      thickness: 1.w,
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Image.asset(
                          ImageConstant.callIc,
                          height: 24.h,
                          width: 24.w,
                        ),
                        SizedBox(width: 10.w),
                        TText(keyName:
                          "+91 ${state.mobile.text}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.textDarkCl,
                            fontFamily: FontsStyle.regular,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(width: 34.w),
                        Image.asset(
                          ImageConstant.whatsappFillIc,
                          height: 24.h,
                          width: 24.w,
                        ),
                        SizedBox(width: 10.w),
                        TText(keyName:
                          "+91 ${state.whatsAppNo.text}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.textDarkCl,
                            fontFamily: FontsStyle.regular,
                            fontStyle: FontStyle.normal,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 6.h),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.faq);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  margin: EdgeInsets.symmetric(
                    horizontal: 13.w,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(109, 109, 53, 0.18),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 0),
                      ),
                    ],
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(10.dm),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        ImageConstant.fqIc,
                        height: 24.h,
                        width: 24.w,
                        color: ColorConstant.appCl,
                      ),
                      const SizedBox(width: 9),
                      TText(keyName:
                        "faq",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: FontsStyle.semiBold,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.sp,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        ImageConstant.arrowForwardIc,
                        height: 18.h,
                        width: 18.w,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MenuItemContainer(
                            icon: ImageConstant.asiUserIc,
                            tb: () {
                              Navigator.pushNamed(context, Routes.category);
                            },
                            name:  "${state2.tr("asUser")}\n",
                          ),
                        ),
                        SizedBox(width: 11.w),
                        Expanded(
                          child: MenuItemContainer(
                            icon: ImageConstant.chatIc,
                            tb: () {
                              Navigator.pushNamed(context, Routes.helpAndSupport, arguments: CmsArguments(title: helpAndSupport, type: "help_and_support"));
                            },
                            name: "${state2.tr("helpAndSupport")}\n${state2.tr("helpAndSupport1")}" ,
                          ),
                        ),
                        SizedBox(width: 11.w),
                        Expanded(
                          child: MenuItemContainer(
                            icon: ImageConstant.shareIc,
                            tb: () async {
                              await shareApp1();
                            },
                            name: "${state2.tr("shareApp")}\n${state2.tr("app")}"
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9.h),
                    Row(
                      children: [
                        SizedBox(width: 11.w),
                        Expanded(
                            child: MenuItemContainer(
                          icon: ImageConstant.termsIc,
                          tb: () {
                            Navigator.pushNamed(context, Routes.cms, arguments: CmsArguments(title:"termConditions1", type: "terms_and_conditions"));
                          },
                          name: "${state2.tr("termConditions")}\n${state2.tr("conditions")}",
                        )),
                        SizedBox(width: 11.w),
                        Expanded(
                            child: MenuItemContainer(
                          icon: ImageConstant.feedbackIc,
                          tb: () async {
                            await openStore();
                          },
                          name: "${state2.tr("rateApp")}\n${state2.tr("app")}",
                        )),
                        SizedBox(width: 11.w),
                        Expanded(
                            child: MenuItemContainer(
                          icon: ImageConstant.infoIc,
                          tb: () {
                            Navigator.pushNamed(context, Routes.cms, arguments: CmsArguments(title: "aboutUs1", type: "about_us"));
                          },
                          name: "${state2.tr("aboutUs")}\n${state2.tr("us")}",
                        )),
                      ],
                    ),
                    SizedBox(height: 9.h),
                    Row(
                      children: [
                        Expanded(
                          child: MenuItemContainer(
                            icon: ImageConstant.deleteIc,
                            tb: () {
                              DeleteReasonBottomSheet.show(context, () {
                                Navigator.pop(context);
                                DeleteAccountBottomSheet.show(context, () {});
                              });
                            },
                            name:"${state2.tr("delete")}\n${state2.tr("account")}",
                          ),
                        ),
                        SizedBox(width: 11.w),
                        Expanded(
                          child: MenuItemContainer(
                            icon: ImageConstant.logoutIc,
                            tb: () {
                              LogoutBottomSheet.show(context, () {});
                            },
                            name:"${state2.tr("logout")}\n",
                          ),
                        ),
                        SizedBox(width: 11.w),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TText(keyName:
                        state2.tr("appVersion"),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.gray1Cl,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),

                        ),
                        TText(keyName:
                        state2.tr(" :${Provider.of<AppUpdateProvider>(context, listen: false).version}"),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.gray1Cl,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> openStore() async {
    String packageName = 'com.animal_market';
    String appStoreUrl = 'https://apps.apple.com/app/$packageName';
    String playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';
    if (await canLaunchUrl(Uri.parse(appStoreUrl)) && !Platform.isAndroid) {
      await launchUrl(Uri.parse(appStoreUrl));
    } else if (await canLaunchUrl(Uri.parse(playStoreUrl)) && Platform.isAndroid) {
      await launchUrl(Uri.parse(playStoreUrl));
    } else {
      throw 'Could not launch store';
    }
  }

  Future<void> shareApp1() async {
    String packageName = 'com.animal_market';
    String appStoreUrl = 'https://apps.apple.com/app/$packageName';
    String playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';
    String msg = 'Download the Animal Market App from Play Store Now'
        'A trusted platform to buy & sell livestock, crops, and pets easily. Get farming and animal care tips to stay ahead in the market.';
    if (!Platform.isAndroid) {
      await Share.share('$msg\n $appStoreUrl');
    } else if (Platform.isAndroid) {
      await Share.share('$msg\n $playStoreUrl"');
    } else {
      throw 'Could not launch store';
    }
  }
}

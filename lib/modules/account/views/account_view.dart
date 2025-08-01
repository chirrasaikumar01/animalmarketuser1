import 'dart:io';

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/account/widgets/delete_account_bottom_sheet.dart';
import 'package:animal_market/modules/account/widgets/delete_reason_bottom_sheet.dart';
import 'package:animal_market/modules/account/widgets/logout_bottom_sheet.dart';
import 'package:animal_market/modules/account/widgets/menu_item_container.dart';
import 'package:animal_market/modules/app_update_provider/app_update_provider.dart';
import 'package:animal_market/modules/auth/models/language_argument.dart';
import 'package:animal_market/modules/cms/models/cms_arguments.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late AccountProvider provider;
  var selectedLanguage = "";

  @override
  void initState() {
    selectedLanguageCode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<AccountProvider>();
      provider.reasonsList(context);
      provider.getProfile(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading = true;
    super.dispose();
  }

  Future<String?> selectedLanguageCode() async {
    var pref = await SharedPreferences.getInstance();
    var lang = pref.getString('lang');
    selectedLanguage = lang ?? "";
    return lang;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountProvider,TranslationsProvider>(
      builder: (context, state,state2, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(
                title:state2.tr("account"),
                action: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.selectLanguage, arguments: LanguageArgument(isEdit: true));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.dm),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.dm),
                          color: ColorConstant.appCl,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: ColorConstant.white,
                              size: 18.sp,
                            ),
                            SizedBox(width: 4.w),
                            TText(keyName:
                              "${state2.tr("language")}  $selectedLanguage",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: ColorConstant.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: FontsStyle.medium,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Image.asset(
                              ImageConstant.arrowDropDownIc,
                              color: ColorConstant.white,
                              height: 20.h,
                              width: 20.w,
                            )
                          ],
                        ),
                      ),
                    ),
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
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: TText(keyName:
                                        state.address.text,
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
                              Navigator.pushNamed(context, Routes.editProfile);
                            },
                            child: Container(
                              padding: EdgeInsets.all(3.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.white,
                                borderRadius: BorderRadius.circular(4.dm),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorConstant.black.withValues(alpha: 0.25),
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
                        Expanded(
                          child: TText(keyName:
                            state2.tr("faq"),
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
                              icon: ImageConstant.startIc,
                              tb: () {
                                Navigator.pushNamed(context, Routes.myFavourite);
                              },
                              name: "${state2.tr("myFavourites")}\n${state2.tr("myFavourites1")}" ,
                            ),
                          ),
                          SizedBox(width: 11.w),
                          Expanded(
                            child: MenuItemContainer(
                              icon: ImageConstant.chatIc,
                              tb: () {
                                Navigator.pushNamed(context, Routes.helpAndSupport, arguments: CmsArguments(title: "Help And Support", type: "contact_us"));
                              },
                              name:"${state2.tr("helpAndSupport")}\n${state2.tr("helpAndSupport1")}" ,
                            ),
                          ),
                          SizedBox(width: 11.w),
                          Expanded(
                            child: MenuItemContainer(
                              icon: ImageConstant.shareIc,
                              tb: () async {
                                Provider.of<AccountProvider>(context, listen: false).shareApp();
                              },
                              name: "${state2.tr("shareApp")}\n${state2.tr("app")}"
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 9.h),
                      Row(
                        children: [
                          Expanded(
                              child: MenuItemContainer(
                            icon: ImageConstant.healthIc,
                            tb: () {
                              Navigator.pushNamed(context, Routes.doctorProfileDashboard);
                            },
                            name: "${state2.tr("asDoctor")}\n",
                          )),
                          SizedBox(width: 11.w),
                          Expanded(
                              child: MenuItemContainer(
                            icon: ImageConstant.termsIc,
                            tb: () {
                              Navigator.pushNamed(context, Routes.cms, arguments: CmsArguments(title: state2.tr("termConditions1"), type: "terms_and_conditions"));
                            },
                            name:"${state2.tr("termConditions")}\n${state2.tr("conditions")}",
                          )),
                          SizedBox(width: 11.w),
                          Expanded(
                              child: MenuItemContainer(
                            icon: ImageConstant.feedbackIc,
                            tb: () async {
                              await openStore();
                            },
                            name:"${state2.tr("rateApp")}\n${state2.tr("app")}",
                          )),
                        ],
                      ),
                      SizedBox(height: 9.h),
                      Row(
                        children: [
                          Expanded(
                              child: MenuItemContainer(
                            icon: ImageConstant.infoIc,
                            tb: () {
                              Navigator.pushNamed(context, Routes.cms, arguments: CmsArguments(title:state2.tr("aboutUs1"), type: "about_us"));
                            },
                            name:"${state2.tr("aboutUs")}\n${state2.tr("us")}",
                          )),
                          SizedBox(width: 11.w),
                          Expanded(
                            child: MenuItemContainer(
                              icon: ImageConstant.deleteIc,
                              tb: () {
                                DeleteReasonBottomSheet.show(context, () {
                                  if (state.selectedReasonId.isEmpty) {
                                    errorToast(context,selectedReason);
                                    return;
                                  } else {
                                    Navigator.pop(context);
                                    DeleteAccountBottomSheet.show(context, () {
                                      state.deactivateAccount(context);
                                    });
                                  }
                                });
                              },
                              name: "${state2.tr("delete")}\n${state2.tr("account")}",
                            ),
                          ),
                          SizedBox(width: 11.w),
                          Expanded(
                            child: MenuItemContainer(
                              icon: ImageConstant.logoutIc,
                              tb: () {
                                LogoutBottomSheet.show(context, () {
                                  state.logoutRoute(context);
                                });
                              },
                              name: "${state2.tr("logout")}\n",
                            ),
                          ),
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
      },
    );
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
}

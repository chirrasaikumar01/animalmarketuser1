import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/auth/models/language_argument.dart';
import 'package:animal_market/modules/auth/providers/auth_provider.dart';
import 'package:animal_market/modules/cms/models/cms_arguments.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var formKey = GlobalKey<FormState>();
  var selectedLanguage = "";

  @override
  void initState() {
    selectedLanguageCode();
    super.initState();
  }

  Future<String?> selectedLanguageCode() async {
    var pref = await SharedPreferences.getInstance();
    var lang = pref.getString('lang');
    selectedLanguage = lang ?? "";
    return lang;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, TranslationsProvider>(builder: (context, state, state2, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 80.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 17.h, vertical: 12.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorConstant.appBarClOne,
                    ColorConstant.appBarClSecond,
                  ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    ImageConstant.logoIc,
                    height: 65.h,
                    width: 70.w,
                    fit: BoxFit.cover,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.selectLanguage, arguments: LanguageArgument(isEdit: false));
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
                          TText(
                            keyName: "${state2.tr("language")}  $selectedLanguage",
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 26.h),
                  RichText(
                    text: TextSpan(
                      text: state2.tr("indiaTrusted"),
                      style: TextStyle(color: ColorConstant.textDarkCl, fontWeight: FontWeight.w600, fontSize: 20.sp, fontFamily: FontsStyle.medium, fontStyle: FontStyle.normal, height: 1.4),
                      children: [
                        TextSpan(
                          text: "\n ",
                          style: TextStyle(
                            color: ColorConstant.textDarkCl,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        TextSpan(
                          text: state2.tr("onlineMarket"),
                          style: TextStyle(color: ColorConstant.textDarkCl, fontWeight: FontWeight.w600, fontSize: 20.sp, fontFamily: FontsStyle.medium, fontStyle: FontStyle.normal, height: 1.4),
                        ),
                        TextSpan(
                          text: "\n ",
                          style: TextStyle(
                            color: ColorConstant.textDarkCl,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        WidgetSpan(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6.dm),
                            ),
                            child: TText(
                              keyName: state2.tr("buyingSelling"),
                              style: TextStyle(
                                color: ColorConstant.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: " ${state2.tr("animals")}",
                          style: TextStyle(
                            color: ColorConstant.textDarkCl,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Row(
                    children: [
                      Expanded(child: Divider(color: ColorConstant.borderCl, height: 1.h)),
                      SizedBox(width: 2.w),
                      TText(
                        keyName: state2.tr("loginOrSignUp"),
                        style: TextStyle(
                          color: ColorConstant.textLightCl,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          fontFamily: FontsStyle.regular,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(child: Divider(color: ColorConstant.borderCl, height: 1.h)),
                    ],
                  ),
                  SizedBox(height: 48.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        decoration: BoxDecoration(color: ColorConstant.white, borderRadius: BorderRadius.circular(10.dm), border: Border.all(color: ColorConstant.borderCl)),
                        child: Row(
                          children: [
                            Image.asset(
                              ImageConstant.indiaFlag,
                              height: 30.h,
                              width: 30.w,
                            ),
                            Image.asset(
                              ImageConstant.arrowDropDownIc,
                              height: 22.h,
                              width: 22.w,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomTextField(
                          borderCl: ColorConstant.borderCl,
                          hintText: state2.tr("enterMobileNo"),
                          txKeyboardType: TextInputType.number,
                          maxLength: 10,
                          controller: state.mobile,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return enterMobileNo;
                            } else if (v.length < 10) {
                              return enterValidMobile;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 48.h),
                  CustomButtonWidget(
                    style: CustomButtonStyle.style2,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        state.registerApi(context, true);
                      }
                    },
                    text: state2.tr("conti"),
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            padding: EdgeInsets.symmetric(horizontal: 63.w, vertical: 40.h),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "${state2.tr("byContinuing")}\n",
                style: TextStyle(
                  color: ColorConstant.textLightCl,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  fontFamily: FontsStyle.regular,
                  fontStyle: FontStyle.normal,
                ),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.cms, arguments: CmsArguments(title: termsOfUse, type: "terms_and_conditions"));
                      },
                      child: TText(
                        keyName: state2.tr("termsOfUse"),
                        style: TextStyle(
                          color: ColorConstant.textLightCl,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: " & ",
                    style: TextStyle(
                      color: ColorConstant.textLightCl,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      fontFamily: FontsStyle.regular,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.cms, arguments: CmsArguments(title: privacyPolicy, type: "privacy_policy"));
                      },
                      child: TText(
                        keyName: state2.tr("privacyPolicy"),
                        style: TextStyle(
                          color: ColorConstant.textLightCl,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

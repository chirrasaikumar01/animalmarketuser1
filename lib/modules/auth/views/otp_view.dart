import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/auth/providers/auth_provider.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  late AuthProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<AuthProvider>();
      provider.startCountdown();
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider,TranslationsProvider>(builder: (context, state,state2, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 70.h),
            child:  CommonAppBar(title: state2.tr("otpVerification"),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 45.h),
                TText(keyName:
                  state2.tr("weHaveSentVerificationCode") ,
                  style: TextStyle(
                    color: ColorConstant.textDarkCl,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    fontFamily: FontsStyle.medium,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 6.h),
                TText(keyName:
                  "+91-${state.mobile.text}",
                  style: TextStyle(
                    color: ColorConstant.textDarkCl,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    fontFamily: FontsStyle.semiBold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: PinCodeTextField(
                    cursorColor: ColorConstant.appCl,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    obscuringCharacter: "*",
                    textStyle: const TextStyle(
                      color: ColorConstant.appCl,
                      fontSize: 14,
                      fontFamily: FontsStyle.regular,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.dm),
                      fieldHeight: 50.h,
                      fieldWidth: 50.w,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      selectedColor: ColorConstant.darkAppCl,
                      disabledColor: ColorConstant.borderCl,
                      inactiveColor: ColorConstant.borderCl,
                      fieldOuterPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      activeColor: ColorConstant.darkAppCl,
                      errorBorderColor: Colors.transparent,
                      borderWidth: 1.h,
                      activeBorderWidth: 1.h,
                      inactiveBorderWidth: 1.h,
                      disabledBorderWidth: 1.h,
                      errorBorderWidth: 1.h,
                      selectedBorderWidth: 1.h,
                    ),
                    enableActiveFill: true,
                    boxShadows: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ],
                    appContext: context,
                    length: 4,
                    onChanged: (String value) {
                      state.updateOtp(value);
                    },
                  ),
                ),
                SizedBox(height: 15.h),
                TText(keyName:
                  state2.tr("checkTextMessages"),
                  style: TextStyle(
                    color: ColorConstant.appCl,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    fontFamily: FontsStyle.medium,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 40.h),
                GestureDetector(
                  onTap: () {
                    if (state.remainingSeconds == 0) {
                      state.startCountdown();
                      state.registerApi(context, false);
                    }
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:  state2.tr("didntGetOTP"),
                      style: TextStyle(
                        color: ColorConstant.textDarkCl,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        fontFamily: FontsStyle.medium,
                        fontStyle: FontStyle.normal,
                      ),
                      children: [
                        TextSpan(
                          text: state.remainingSeconds == 0 ? state2.tr("resendOtp") : "${state2.tr("resendSmsIn")} ${state.remainingSeconds}s",
                          style: TextStyle(
                            color: state.remainingSeconds == 0 ? ColorConstant.appCl : ColorConstant.hintTextCl,
                            fontWeight: FontWeight.w400,
                            fontSize: state.remainingSeconds == 0 ? 16.sp : 14.sp,
                            fontFamily: FontsStyle.regular,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                CustomButtonWidget(
                  style: CustomButtonStyle.style2,
                  onPressed: () {
                    state.verifyOtpApi(context);
                    // Navigator.pushNamed(context, Routes.location);
                  },
                  text:  state2.tr("conti"),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

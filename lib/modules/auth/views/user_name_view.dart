import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:flutter/services.dart';

class UserNameView extends StatefulWidget {
  const UserNameView({super.key});

  @override
  State<UserNameView> createState() => _UserNameViewState();
}

class _UserNameViewState extends State<UserNameView> {
  var formKey = GlobalKey<FormState>();
  late AccountProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<AccountProvider>();
      provider.getProfile(context);
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
    return Consumer2<AccountProvider, TranslationsProvider>(
      builder: (context, state, state2, child) {
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
                      ImageConstant.appIcon,
                      height: 65.h,
                      width: 70.w,
                      fit: BoxFit.cover,
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
                  children: [
                    SizedBox(height: 30.h),
                    Image.asset(
                      ImageConstant.welcomeIc,
                      height: 82.h,
                      width: 82.w,
                    ),
                    SizedBox(height: 30.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: state2.tr("welcomeTo"),
                        style: TextStyle(color: ColorConstant.textDarkCl, fontWeight: FontWeight.w600, fontSize: 20.sp, fontFamily: FontsStyle.medium, fontStyle: FontStyle.normal, height: 1.3),
                        children: [
                          TextSpan(text: "\n"),
                          WidgetSpan(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(6.dm),
                              ),
                              child: TText(keyName:
                                state2.tr("appName"),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),
                    SizedBox(height: 32.h),
                    CustomTextField(
                      borderCl: ColorConstant.borderCl,
                      controller: state.name,
                      hintText:  state2.tr("enterName"),
                      labelText:state2.tr("yourName"),
                      txKeyboardType: TextInputType.name,
                      leading1: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          ImageConstant.userNewIc,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]*$')),
                      ],
                      validator: (v) {
                        if (v!.isEmpty) {
                          return enterName;
                        } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(v)) {
                          return onlyAlphabets;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 48.h),
                    CustomButtonWidget(
                      style: CustomButtonStyle.style2,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          state.updateProfile(context, true, false, false);
                        }
                      },
                      text:state2.tr("conti"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

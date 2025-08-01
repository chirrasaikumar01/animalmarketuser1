import 'dart:io';

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/auth/models/language_list_model.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late AccountProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<AccountProvider>();
      provider.languageListGet(context);
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
    return Consumer2<AccountProvider,TranslationsProvider>(builder: (context, state,state2, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 70.h),
            child: CommonAppBar(title:state2.tr("editProfile")),
          ),
          body: Padding(
            padding: EdgeInsets.all(17.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        state.onUploadImage(context);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorConstant.appCl),
                              borderRadius: BorderRadius.circular(100.dm),
                            ),
                            height: 90.h,
                            width: 90.w,
                            child: state.image != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100.dm),
                                    child: Image.file(
                                      File(state.image),
                                      height: 90.h,
                                      width: 90.w,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : CustomImage(
                                    placeholderAsset: ImageConstant.placeHolderIc,
                                    errorAsset: ImageConstant.placeHolderIc,
                                    radius: 90.dm,
                                    height: 90.h,
                                    width: 90.w,
                                    imageUrl: state.imageUrl,
                                    baseUrl: ApiUrl.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(2.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.white,
                                borderRadius: BorderRadius.circular(24.dm),
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
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  CustomTextField(
                    borderCl: ColorConstant.borderCl,
                    hintText:state2.tr("enterName") ,
                    txKeyboardType: TextInputType.name,
                    controller: state.name,
                    labelText:state2.tr("yourName"),
                    leading1: Image.asset(
                      ImageConstant.userIc,
                      height: 24.h,
                      width: 24.w,
                      color: ColorConstant.appCl,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    borderCl: ColorConstant.borderCl,
                    hintText:state2.tr("enterEmail") ,
                    txKeyboardType: TextInputType.emailAddress,
                    labelText:state2.tr("emailAddress") ,
                    controller: state.emailController,
                    leading1: Image.asset(
                      ImageConstant.emailNewIc,
                      height: 24.h,
                      width: 24.w,
                      color: ColorConstant.appCl,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    borderCl: ColorConstant.borderCl,
                    hintText:state2.tr("enterMobileNo") ,
                    txKeyboardType: TextInputType.number,
                    controller: state.mobile,
                    readOnly: true,
                    isEnabled: false,
                    maxLength: 10,
                    labelText: state2.tr("number"),
                    leading1: Image.asset(
                      ImageConstant.callIc,
                      height: 24.h,
                      width: 24.w,
                      color: ColorConstant.appCl,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    borderCl: ColorConstant.borderCl,
                    hintText:state2.tr("enterMobileNo"),
                    controller: state.whatsAppNo,
                    txKeyboardType: TextInputType.number,
                    maxLength: 10,
                    labelText:state2.tr("whatsAppNumber"),
                    leading1: Image.asset(
                      ImageConstant.whatsappFillIc,
                      height: 24.h,
                      width: 24.w,
                      color: ColorConstant.appCl,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      value: state.gender,
                      hint: const TText(
                        keyName: select,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "male",
                          child: TText(
                            keyName: "male",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "female",
                          child: TText(
                            keyName: "female",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "other",
                          child: TText(
                            keyName: "other",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value != null) {
                          state.updateGender(value);
                        }
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 45,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ColorConstant.borderCl),
                          color: ColorConstant.white,
                        ),
                      ),
                      iconStyleData: IconStyleData(
                        icon: Image.asset(
                          ImageConstant.arrowDropDownIc,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        maxHeight: 200,
                        width: MediaQuery.of(context).size.width * 0.90,
                        useSafeArea: true,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TText(keyName:
                    state2.tr("language"),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.textLightCl,
                      fontFamily: FontsStyle.medium,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<LanguageListModel?>(
                      buttonStyleData: ButtonStyleData(
                        height: 45,
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorConstant.borderCl,
                          ),
                          color: ColorConstant.white,
                        ),
                      ),
                      iconStyleData: IconStyleData(
                        icon: Image.asset(
                          ImageConstant.arrowDropDownIc,
                          height: 24.h,
                          width: 24.w,
                        ),
                        iconSize: 14,
                        iconEnabledColor: Colors.black,
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        maxHeight: 200,
                        width: MediaQuery.of(context).size.width * 0.90,
                        useSafeArea: true,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: WidgetStateProperty.all(6),
                          thumbVisibility: WidgetStateProperty.all(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 45,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                      isDense: true,
                      value: state.languageModel,
                      hint: const TText(keyName:
                        select,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.bold),
                      isExpanded: true,
                      items: state.languageList
                          .map((s) => DropdownMenuItem<LanguageListModel>(
                                value: s,
                                child: TText(keyName:
                                  " ${s.title}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (LanguageListModel? value) {
                        if (value != null) {
                          state.updateLanguageCode(value, value.languageCode ?? "");
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    borderCl: ColorConstant.borderCl,
                    hintText: "DD-MM-YYYY",
                    txKeyboardType: TextInputType.number,
                    maxLength: 10,
                    labelText:  state2.tr("dateBirth"),
                    onTap: () {
                      state.dateOfBirthSelect(context);
                    },
                    controller: state.dateOfBirth,
                    isEnabled: true,
                    readOnly: true,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return enterDateBirth;
                      }
                      return null;
                    },
                    leading1: Image.asset(
                      ImageConstant.dateRangeIc,
                      height: 24.h,
                      width: 24.w,
                      color: ColorConstant.appCl,
                    ),
                  ),
                  SizedBox(height: 120.h)
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorConstant.black.withValues(alpha: 0.25),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
              color: ColorConstant.white,
            ),
            child: Wrap(
              children: [
                CustomButtonWidget(
                  style: CustomButtonStyle.style2,
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  onPressed: () {
                    state.updateProfile(context, false, false, false);
                  },
                  text: "",
                  iconWidget: TText(keyName:
                    state2.tr("update"),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.textDarkCl,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

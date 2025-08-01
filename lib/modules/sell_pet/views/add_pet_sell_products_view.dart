import 'dart:io';

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_date_picker.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/auth/models/location_argument.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/sell/models/breed_list_model.dart';
import 'package:animal_market/modules/sell/views/add_sell_products_view.dart';
import 'package:animal_market/modules/sell_pet/models/add_pet_sell_products_arguments.dart';
import 'package:animal_market/modules/sell_pet/models/pet_purpose_model.dart';
import 'package:animal_market/modules/sell_pet/providers/pet_sell_products_provider.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class AddPetSellProductsView extends StatefulWidget {
  final AddPetSellProductsArguments arguments;

  const AddPetSellProductsView({super.key, required this.arguments});

  @override
  State<AddPetSellProductsView> createState() => _AddPetSellProductsViewState();
}

class _AddPetSellProductsViewState extends State<AddPetSellProductsView> {
  late PetSellProductsProvider provider;
  final formKey = GlobalKey<FormState>();
  DateTime? minPickupDateTime;

  @override
  void initState() {
    minPickupDateTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<PetSellProductsProvider>();
      provider.initAudioServices();
      if (widget.arguments.isEdit) {
        provider.petDetail(context, widget.arguments.id).then((v) {
          if (mounted) {
            provider.subCategory(context, provider.categoryId);
          }
        });
      } else {
        provider.getLocationStatus();
        provider.resetData();
        provider.stateListGet(context);
        provider.subCategory(context, provider.categoryId);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.resetPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetSellProductsProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(title: widget.arguments.isEdit ? "edit" : "sellYourPet"),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      RTTextSpan(
                        textAlign: TextAlign.start,
                        maxChildren: 2,
                        keyName: 'listingPurpose',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                        items: [
                          RTSpanItem(
                            key: ' ',
                            style: TextStyle(
                              color: ColorConstant.appCl,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              fontFamily: FontsStyle.regular,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          RTSpanItem(
                            key: " *",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<PetPurposeModel?>(
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
                          value: state.selectedPurpose,
                          hint: const TText(
                            keyName: "selectPurposeListing",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          isExpanded: true,
                          items: state.purposeList
                              .map((s) => DropdownMenuItem<PetPurposeModel>(
                                    value: s,
                                    child: TText(
                                      keyName: s.title,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (PetPurposeModel? value) {
                            if (value != null) {
                              state.updatePurpose(value);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 14.h),
                      RTTextSpan(
                        textAlign: TextAlign.start,
                        maxChildren: 2,
                        keyName: 'petCategory',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                        items: [
                          RTSpanItem(
                            key: ' ',
                            style: TextStyle(
                              color: ColorConstant.appCl,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              fontFamily: FontsStyle.regular,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          RTSpanItem(
                            key: " *",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<SubCategoryListModel?>(
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
                          value: state.subCategoryModel,
                          hint: const TText(
                            keyName: "selectPetCategory",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          isExpanded: true,
                          items: state.subCategoryList
                              .map((s) => DropdownMenuItem<SubCategoryListModel>(
                                    value: s,
                                    child: TText(
                                      keyName: " ${s.title}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (SubCategoryListModel? value) {
                            if (value != null) {
                              state.updateSubCategory(context, value);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 14.h),
                      if (state.subCategoryModel != null && !state.subCategoryModel!.title!.toLowerCase().contains("other"))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RTTextSpan(
                              textAlign: TextAlign.start,
                              maxChildren: 2,
                              keyName: 'petBreed',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.textDarkCl,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                              items: [
                                RTSpanItem(
                                  key: ' ',
                                  style: TextStyle(
                                    color: ColorConstant.appCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                RTSpanItem(
                                  key: " *",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<BreedListModel?>(
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
                                value: state.breedListModel,
                                hint: const TText(
                                  keyName: "selectPetBreed",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                isExpanded: true,
                                items: state.breedList
                                    .map((s) => DropdownMenuItem<BreedListModel>(
                                          value: s,
                                          child: TText(
                                            keyName: " ${s.title}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (BreedListModel? value) {
                                  if (value != null) {
                                    state.updateBreed(context, value);
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 14.h),
                          ],
                        ),
                      state.breedListModel != null && state.breedListModel!.title!.toString().toLowerCase() == "Other".toLowerCase()
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RTTextSpan(
                                  textAlign: TextAlign.start,
                                  maxChildren: 3,
                                  keyName: 'breed',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.textDarkCl,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  items: [
                                    RTSpanItem(
                                      key: ' ',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorConstant.textDarkCl,
                                        fontFamily: FontsStyle.medium,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    RTSpanItem(
                                      key: 'name',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorConstant.textDarkCl,
                                        fontFamily: FontsStyle.medium,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    RTSpanItem(
                                      key: " *",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                CustomTextField(
                                  hintText: "enterBreedName",
                                  borderCl: ColorConstant.borderCl,
                                  controller: state.breedName,
                                ),
                                SizedBox(height: 14.h),
                              ],
                            )
                          : SizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: "enterAge",
                              borderCl: ColorConstant.borderCl,
                              txKeyboardType: TextInputType.number,
                              labelText: "age",
                              controller: state.age,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TText(
                                  keyName: "ageType",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.textDarkCl,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<String?>(
                                    buttonStyleData: ButtonStyleData(
                                      height: 45,
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(left: 10, right: 10),
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
                                      width: MediaQuery.of(context).size.width * 0.45,
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
                                    value: state.selectedAgeType,
                                    hint: const TText(
                                      keyName: "select",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    isExpanded: true,
                                    items: state.ageTypeList
                                        .map((s) => DropdownMenuItem<String>(
                                              value: s["type"],
                                              child: TText(
                                                keyName: "${s["title"]}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        state.updateAgeType(value);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      TText(
                        keyName: "gender",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String?>(
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
                          value: state.selectedGender,
                          hint: const TText(
                            keyName: "select",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          isExpanded: true,
                          items: state.genderList
                              .map((s) => DropdownMenuItem<String>(
                                    value: s["type"],
                                    child: TText(
                                      keyName: "${s["title"]}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              state.updateGender(value);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 14.h),
                      RTTextSpan(
                        textAlign: TextAlign.start,
                        maxChildren: 2,
                        keyName: 'vaccination',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                        items: [
                          RTSpanItem(
                            key: ' ',
                            style: TextStyle(
                              color: ColorConstant.appCl,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              fontFamily: FontsStyle.regular,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          RTSpanItem(
                            key: " *",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String?>(
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
                          value: state.selectedVaccine,
                          hint: const TText(
                            keyName: "selectVaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          isExpanded: true,
                          items: state.vaccineList
                              .map((s) => DropdownMenuItem<String>(
                                    value: s["type"],
                                    child: TText(
                                      keyName: "${s["title"]}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              state.updateIsVaccinated(value);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 14.h),
                      state.isVaccinated == "1"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TText(
                                  keyName: "vaccineName",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.textDarkCl,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                CustomTextField(
                                  hintText: "enterVaccineName",
                                  borderCl: ColorConstant.borderCl,
                                  controller: state.vaccineName,
                                ),
                                SizedBox(height: 14.h),
                                TText(
                                  keyName: "vaccineDate",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.textDarkCl,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                CustomDatePicker(
                                  selectedDate: state.selectedVaccineDate,
                                  time: state.formattedVaccineDate,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: ColorConstant.white,
                                              onPrimary: ColorConstant.darkAppCl,
                                              surface: ColorConstant.darkAppCl,
                                              onSurface: ColorConstant.white,
                                            ),
                                            textButtonTheme: TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                backgroundColor: ColorConstant.appCl,
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      context: context,
                                      initialDate: minPickupDateTime,
                                      firstDate: minPickupDateTime!,
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      state.setPickerDate(pickedDate);
                                    }
                                  },
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 10.h),
                      TText(
                        keyName: "sellerType",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String?>(
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
                          value: state.selectedSellerType,
                          hint: const TText(
                            keyName: "selectSellerType",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          isExpanded: true,
                          items: state.sellerTypeList
                              .map((s) => DropdownMenuItem<String>(
                                    value: s["type"],
                                    child: TText(
                                      keyName: "${s["title"]}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              state.updateSellerType(value);
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14.h),
                            TText(
                              keyName: "sellerName",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.textDarkCl,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: "enterSellerName",
                              borderCl: ColorConstant.borderCl,
                              controller: state.sellerName,
                              txKeyboardType: TextInputType.name,
                            ),
                            SizedBox(height: 14.h),
                            TText(
                              keyName: "sellerMobileNumber",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.textDarkCl,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: "enterSellerMobileNumber",
                              borderCl: ColorConstant.borderCl,
                              controller: state.sellerMobile,
                              txKeyboardType: TextInputType.phone,
                              maxLength: 10,
                            ),
                            SizedBox(height: 14.h),
                            TText(
                              keyName: "sellerValidWhatsAppNumber",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.textDarkCl,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: "enterSellerValidWhatsAppNumber",
                              borderCl: ColorConstant.borderCl,
                              controller: state.sellerWhatsappMobile,
                              txKeyboardType: TextInputType.phone,
                              maxLength: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RTTextSpan(
                            textAlign: TextAlign.start,
                            maxChildren: 2,
                            keyName: 'sellPrice',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.textDarkCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                            items: [
                              RTSpanItem(
                                key: ' ',
                                style: TextStyle(
                                  color: ColorConstant.appCl,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                  fontFamily: FontsStyle.regular,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              RTSpanItem(
                                key: " *",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          TText(
                            keyName: "negotiable",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.textDarkCl,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: "₹ 60,000 etc",
                              borderCl: ColorConstant.borderCl,
                              controller: state.price,
                              txKeyboardType: TextInputType.number,
                              leading1: Image.asset(
                                ImageConstant.rupeeCircleIc,
                                height: 20.h,
                                width: 20.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Transform.scale(
                            scale: 0.9,
                            child: CupertinoSwitch(
                              value: state.isNegotiable == "1" ? true : false,
                              onChanged: (bool value) {
                                state.updateIsNegotiable(value == true ? "yes" : "no");
                              },
                              activeTrackColor: Colors.green,
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 13.h),
                        decoration: BoxDecoration(color: Color(0xFFF9F9EC), borderRadius: BorderRadius.circular(10.dm)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RTTextSpan(
                              textAlign: TextAlign.start,
                              maxChildren: 2,
                              keyName: 'photoAtLeastOne',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.textDarkCl,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                              items: [
                                RTSpanItem(
                                  key: ' ',
                                  style: TextStyle(
                                    color: ColorConstant.appCl,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                RTSpanItem(
                                  key: " *",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            TText(
                              keyName: "itSellsFastIf",
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.gray1Cl,
                                fontFamily: FontsStyle.regular,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(height: 18.h),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      state.onUploadImage(context, "image");
                                    },
                                    child: state.image != ""
                                        ? Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.dm)),
                                            margin: EdgeInsets.only(right: 2),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.dm),
                                              child: Stack(
                                                children: [
                                                  Image.file(
                                                    File(state.image),
                                                    height: 124.h,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Positioned(
                                                    right: 3,
                                                    top: 3,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        state.removeImage("image");
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(4.h),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.red,
                                                            width: 2.w,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 10.sp,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.white,
                                              borderRadius: BorderRadius.circular(10.dm),
                                            ),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  ImageConstant.uploadPetImg1,
                                                  height: 70.h,
                                                ),
                                                SizedBox(height: 5.h),
                                                TText(
                                                  keyName: "uploadImage",
                                                  style: TextStyle(
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorConstant.textDarkCl,
                                                    fontFamily: FontsStyle.semiBold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                                SizedBox(height: 5.h),
                                                TText(
                                                  keyName: "PNG, JPG, Format",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorConstant.gray1Cl,
                                                    fontFamily: FontsStyle.semiBold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      state.onUploadImage(context, "image1");
                                    },
                                    child: state.image1 != ""
                                        ? Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.dm)),
                                            margin: EdgeInsets.only(right: 2),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.dm),
                                              child: Stack(
                                                children: [
                                                  Image.file(
                                                    File(state.image1),
                                                    height: 124.h,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Positioned(
                                                    right: 3,
                                                    top: 3,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        state.removeImage("image1");
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(4.h),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.red,
                                                            width: 2.w,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 10.sp,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.white,
                                              borderRadius: BorderRadius.circular(10.dm),
                                            ),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  ImageConstant.uploadPetImg2,
                                                  height: 70.h,
                                                ),
                                                SizedBox(height: 5.h),
                                                TText(
                                                  keyName: "uploadImage",
                                                  style: TextStyle(
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorConstant.textDarkCl,
                                                    fontFamily: FontsStyle.semiBold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                                SizedBox(height: 5.h),
                                                TText(
                                                  keyName: "PNG, JPG, Format",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorConstant.gray1Cl,
                                                    fontFamily: FontsStyle.semiBold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      state.onUploadImage(context, "image2");
                                    },
                                    child: state.image2 != ""
                                        ? Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.dm)),
                                            margin: EdgeInsets.only(right: 2),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.dm),
                                              child: Stack(
                                                children: [
                                                  Image.file(
                                                    File(state.image2),
                                                    height: 124.h,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Positioned(
                                                    right: 3,
                                                    top: 3,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        state.removeImage("image2");
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(4.h),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.red,
                                                            width: 2.w,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 10.sp,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.white,
                                              borderRadius: BorderRadius.circular(10.dm),
                                            ),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  ImageConstant.uploadPetImg3,
                                                  height: 70.h,
                                                ),
                                                SizedBox(height: 5.h),
                                                TText(
                                                  keyName: "uploadImage",
                                                  style: TextStyle(
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorConstant.textDarkCl,
                                                    fontFamily: FontsStyle.semiBold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                                SizedBox(height: 5.h),
                                                TText(
                                                  keyName: "PNG, JPG, Format",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorConstant.gray1Cl,
                                                    fontFamily: FontsStyle.semiBold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Container(
                                    height: 124.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: ColorConstant.white,
                                      borderRadius: BorderRadius.circular(10.dm),
                                    ),
                                    child: state.isCompress
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: ColorConstant.appCl,
                                            ),
                                          )
                                        : state.videoFile != ""
                                            ? Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10.dm),
                                                    child: SizedBox.expand(
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: SizedBox(
                                                          width: state.videoPlayerController!.value.size.width,
                                                          height: state.videoPlayerController!.value.size.height,
                                                          child: VideoPlayer(state.videoPlayerController!),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 3,
                                                    top: 3,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        state.removeImage("video");
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(4.h),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.red,
                                                            width: 2.w,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 10.sp,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0.h,
                                                    right: 0.w,
                                                    top: 0.h,
                                                    left: 0.w,
                                                    child: Center(
                                                      child: IconButton(
                                                        icon: Icon(
                                                          state.videoPlayerController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                                                          color: Colors.white,
                                                          size: 30.sp,
                                                        ),
                                                        onPressed: () {
                                                          if (state.videoPlayerController!.value.isPlaying) {
                                                            state.playAndPause(true);
                                                          } else {
                                                            state.playAndPause(false);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  state.pickMedia(context: context, isVideo: true);
                                                  state.isVideoUpdate(true);
                                                },
                                                child: Center(
                                                  child: Image.asset(
                                                    ImageConstant.videoUploadIc,
                                                    height: 70.h,
                                                  ),
                                                ),
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (state.showPlayer)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 49,
                          decoration: BoxDecoration(
                            color: ColorConstant.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: ColorConstant.borderCl, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: state.reset,
                                child: Image.asset(ImageConstant.deleteIcNew, height: 24, width: 24),
                              ),
                              const SizedBox(width: 26),
                              state.isPlaying ? const Expanded(child: WaveAnimation()) : Image.asset(ImageConstant.wave, height: 24, fit: BoxFit.fill),
                              const SizedBox(width: 26),
                              GestureDetector(
                                onTap: () async {
                                  state.isPlaying ? state.stopAudio() : state.playAudio();
                                },
                                child: state.isPlaying ? const Icon(Icons.stop, size: 24, color: ColorConstant.redCl) : Image.asset(ImageConstant.play, height: 24, width: 24),
                              ),
                            ],
                          ),
                        )
                      else
                        CustomTextField(
                          hintText: "addYourVoiceMessage",
                          validator: (v) => (v == null || v.isEmpty) ? "addYourVoiceMessage" : null,
                          obscureText: false,
                          readOnly: true,
                          txKeyboardType: TextInputType.name,
                          borderCl: ColorConstant.borderCl,
                          fillColor: ColorConstant.white,
                          leading1: GestureDetector(
                            onTap: () async {
                              if (state.isRecording) {
                                state.stopRecording();
                              } else {
                                state.startRecording();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Material(
                                child: Image.asset(
                                  ImageConstant.voiceIc,
                                  height: 18,
                                  width: 18,
                                  color: state.isRecording ? ColorConstant.redCl : ColorConstant.appCl,
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 16.h),
                      Visibility(
                        visible: false,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10.dm),
                          decoration: BoxDecoration(
                            color: ColorConstant.white,
                            borderRadius: BorderRadius.circular(9.dm),
                            border: Border.all(color: ColorConstant.borderCl),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    ImageConstant.videoIc,
                                    height: 20.h,
                                    width: 20.w,
                                  ),
                                  SizedBox(width: 6.w),
                                  TText(
                                    keyName: "video",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.textDarkCl,
                                      fontFamily: FontsStyle.semiBold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              TText(
                                keyName: "record",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.textLightCl,
                                  fontFamily: FontsStyle.medium,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              SizedBox(height: 18.h),
                              if (state.videoFile != "")
                                state.isVideo && state.videoPlayerController!.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio: state.videoPlayerController!.value.aspectRatio,
                                        child: VideoPlayer(state.videoPlayerController!),
                                      )
                                    : Container()
                              else
                                GestureDetector(
                                  onTap: () {
                                    state.pickMedia(context: context, isVideo: true);
                                    state.isVideoUpdate(true);
                                  },
                                  child: Image.asset(
                                    ImageConstant.videoUploadIc,
                                    height: 70.h,
                                    width: 115.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      /* TText(keyName:
                        "Title",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.medium,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CustomTextField(
                        hintText: "Enter Title",
                        borderCl: ColorConstant.borderCl,
                        controller: state.title,
                        txKeyboardType: TextInputType.name,
                      ),*/

                      SizedBox(height: 14.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorConstant.white,
                          borderRadius: BorderRadius.circular(10.dm),
                          border: Border.all(
                            color: ColorConstant.grayCl,
                            width: 1.w,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                state.isFull(!state.isShow);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: !state.isShow
                                      ? BorderRadius.circular(10.dm)
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(10.dm),
                                          topRight: Radius.circular(10.dm),
                                        ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TText(
                                      keyName: "addMoreInfo",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorConstant.white,
                                        fontFamily: FontsStyle.medium,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    AnimatedRotation(
                                      turns: state.isShow ? 0.5 : 0.0,
                                      duration: Duration(milliseconds: 300),
                                      child: Image.asset(
                                        ImageConstant.arrowDropDownIc,
                                        height: 24,
                                        width: 24,
                                        color: ColorConstant.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            state.isShow
                                ? Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 14.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TText(
                                                  keyName: "microChipped",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: ColorConstant.textLightCl,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  if (state.microChippedSelected == "0") {
                                                    state.selectMicroChippedSelection("1");
                                                  } else {
                                                    state.selectMicroChippedSelection("0");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: state.microChippedSelected == "1" ? ColorConstant.appCl : Colors.transparent,
                                                    border: Border.all(
                                                      color: state.microChippedSelected == "1" ? ColorConstant.appCl : Colors.grey.shade400,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  width: 25,
                                                  height: 25,
                                                  child: state.microChippedSelected == "1"
                                                      ? const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TText(
                                                  keyName: "deformed",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: ColorConstant.textLightCl,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  if (state.dewormedSelected == "0") {
                                                    state.selectDewormedSelection("1");
                                                  } else {
                                                    state.selectDewormedSelection("0");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: state.dewormedSelected == "1" ? ColorConstant.appCl : Colors.transparent,
                                                    border: Border.all(
                                                      color: state.dewormedSelected == "1" ? ColorConstant.appCl : Colors.grey.shade400,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  width: 25,
                                                  height: 25,
                                                  child: state.dewormedSelected == "1"
                                                      ? const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TText(
                                                  keyName: "neuteredSpayed",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: ColorConstant.textLightCl,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  if (state.neuteredSelected == "0") {
                                                    state.selectNeuteredSelection("1");
                                                  } else {
                                                    state.selectNeuteredSelection("0");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: state.neuteredSelected == "1" ? ColorConstant.appCl : Colors.transparent,
                                                    border: Border.all(
                                                      color: state.neuteredSelected == "1" ? ColorConstant.appCl : Colors.grey.shade400,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  width: 25,
                                                  height: 25,
                                                  child: state.neuteredSelected == "1"
                                                      ? const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TText(
                                                  keyName: "requiresSpecialCare",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: ColorConstant.textLightCl,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  if (state.careSelected == "0") {
                                                    state.selectSpecialCareSelection("1");
                                                  } else {
                                                    state.selectSpecialCareSelection("0");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: state.careSelected == "1" ? ColorConstant.appCl : Colors.transparent,
                                                    border: Border.all(
                                                      color: state.careSelected == "1" ? ColorConstant.appCl : Colors.grey.shade400,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  width: 25,
                                                  height: 25,
                                                  child: state.careSelected == "1"
                                                      ? const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TText(
                                                  keyName: "goodWithOtherPets",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: ColorConstant.textLightCl,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  if (state.petsSelected == "0") {
                                                    state.selectPetsSelection("1");
                                                  } else {
                                                    state.selectPetsSelection("0");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: state.petsSelected == "1" ? ColorConstant.appCl : Colors.transparent,
                                                    border: Border.all(
                                                      color: state.petsSelected == "1" ? ColorConstant.appCl : Colors.grey.shade400,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  width: 25,
                                                  height: 25,
                                                  child: state.petsSelected == "1"
                                                      ? const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TText(
                                                  keyName: "trained",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: ColorConstant.textLightCl,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  if (state.trainedSelected == "0") {
                                                    state.selectTrainedSelection("1");
                                                  } else {
                                                    state.selectTrainedSelection("0");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: state.trainedSelected == "1" ? ColorConstant.appCl : Colors.transparent,
                                                    border: Border.all(
                                                      color: state.trainedSelected == "1" ? ColorConstant.appCl : Colors.grey.shade400,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  width: 25,
                                                  height: 25,
                                                  child: state.trainedSelected == "1"
                                                      ? const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        state.trainedSelected == "1"
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TText(
                                                    keyName: "trainingType",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: ColorConstant.textDarkCl,
                                                      fontFamily: FontsStyle.medium,
                                                      fontStyle: FontStyle.normal,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  DropdownButtonHideUnderline(
                                                    child: DropdownButton2<String?>(
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
                                                      value: state.selectedTrainingType,
                                                      hint: const TText(
                                                        keyName: "selectTrainingType",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 13.sp,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      isExpanded: true,
                                                      items: state.trainingTypeList
                                                          .map((s) => DropdownMenuItem<String>(
                                                                value: s["type"],
                                                                child: TText(
                                                                  keyName: "${s["title"]}",
                                                                  style: const TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ))
                                                          .toList(),
                                                      onChanged: (String? value) {
                                                        if (value != null) {
                                                          state.updateTrainingType(value);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                        SizedBox(height: 14.h),
                                        TText(
                                          keyName: "locationDelivery",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.medium,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton2<String?>(
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
                                            value: state.selectedDeliveryType,
                                            hint: const TText(
                                              keyName: "selectDeliveryType",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            isExpanded: true,
                                            items: state.deliveryTypeList
                                                .map((s) => DropdownMenuItem<String>(
                                                      value: s["type"],
                                                      child: TText(
                                                        keyName: "${s["title"]}",
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            onChanged: (String? value) {
                                              if (value != null) {
                                                state.updateDeliveryType(value);
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        TText(
                                          keyName: "shippingOtherCharges",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.medium,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        CustomTextField(
                                          paddingCustom: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                          hintText: "enterShippingCharges",
                                          controller: state.shipping,
                                          borderCl: ColorConstant.borderCl,
                                          txKeyboardType: TextInputType.phone,
                                        ),
                                        SizedBox(height: 14.h),
                                        TText(
                                          keyName: "packingCharges",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.medium,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        CustomTextField(
                                          paddingCustom: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                          hintText: "enterPackingCharges",
                                          controller: state.packing,
                                          borderCl: ColorConstant.borderCl,
                                          txKeyboardType: TextInputType.phone,
                                        ),
                                        SizedBox(height: 5.h),
                                        TText(
                                          keyName: "noteThis",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.red,
                                            fontFamily: FontsStyle.medium,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        TText(
                                          keyName: "descriptionOptional",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.medium,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        CustomTextField(
                                          hintText: "enterDescription",
                                          borderCl: ColorConstant.borderCl,
                                          controller: state.description,
                                          maxCheck: 6,
                                          counterText: "Max 400 Words",
                                        ),
                                        SizedBox(height: 10.h),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          ImageConstant.location2dIc,
                          height: 36.h,
                          width: 36.w,
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              TText(
                                keyName: state.addressLocation,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.darkAppCl,
                                  fontFamily: FontsStyle.medium,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              GestureDetector(
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
                                child: TText(
                                  keyName: "changeLocation",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.blueCl,
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 140.h),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: ColorConstant.black.withValues(alpha: 0.25),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ], color: ColorConstant.white),
              child: Wrap(
                children: [
                  CustomButtonWidget(
                    style: CustomButtonStyle.style2,
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    onPressed: () {
                      state.createEditPet(context, widget.arguments.id, widget.arguments.isEdit);
                      // Navigator.pushNamed(context, Routes.successfullyCreatedPet);
                    },
                    text: "",
                    iconWidget: TText(
                      keyName: "submit",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.darkAppCl,
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
      },
    );
  }
}

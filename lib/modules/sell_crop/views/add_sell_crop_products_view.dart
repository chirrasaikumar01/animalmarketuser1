import 'dart:io';

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/auth/models/location_argument.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/sell/views/add_sell_products_view.dart';
import 'package:animal_market/modules/sell_crop/models/add_sell_crop_products_arguments.dart';
import 'package:animal_market/modules/sell_crop/models/crop_quantities_model.dart';
import 'package:animal_market/modules/sell_crop/models/crop_type_model.dart';
import 'package:animal_market/modules/sell_crop/models/crop_variety_model.dart';
import 'package:animal_market/modules/sell_crop/providers/sell_crop_products_provider.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class AddSellCropProductsView extends StatefulWidget {
  final AddSellCropProductsArguments arguments;

  const AddSellCropProductsView({super.key, required this.arguments});

  @override
  State<AddSellCropProductsView> createState() => _AddSellCropProductsViewState();
}

class _AddSellCropProductsViewState extends State<AddSellCropProductsView> {
  late SellCropProductsProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<SellCropProductsProvider>();
      provider.categoryId = widget.arguments.categoryId;
      provider.getLocationStatus();
      provider.initAudioServices();
      if (widget.arguments.isEdit) {
        provider.cropDetail(context, widget.arguments.id).then((v) {
          if (mounted) {
            provider.subCategory(context, widget.arguments.categoryId);
            provider.cropQualities(context);
          }
        });
      } else {
        provider.resetData();
        provider.subCategory(context, widget.arguments.categoryId);
        provider.cropQualities(context);
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
    return Consumer<SellCropProductsProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(title: widget.arguments.isEdit ? "edit" : "sellYourCrop"),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    RTTextSpan(
                      textAlign: TextAlign.start,
                      maxChildren: 2,
                      keyName: 'cropCategory',
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
                    RTTextSpan(
                      textAlign: TextAlign.start,
                      maxChildren: 2,
                      keyName: 'cropName',
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
                    if (state.isOtherSelected)
                      CustomTextField(
                        hintText: "enterCropName",
                        controller: state.cropNameController,
                        borderCl: ColorConstant.borderCl,
                        txKeyboardType: TextInputType.text,
                      )
                    else
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<CropTypeModel?>(
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
                          value: state.cropTypeModel,
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
                          items: state.cropTypeList
                              .map((s) => DropdownMenuItem<CropTypeModel>(
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
                          onChanged: (CropTypeModel? value) {
                            if (value != null) {
                              state.updateCropType(context, value);
                            }
                          },
                        ),
                      ),
                    SizedBox(height: 14.h),
                    if (!state.isOtherSelected && state.cropTypeModel?.slug != "other")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RTTextSpan(
                            textAlign: TextAlign.start,
                            maxChildren: 2,
                            keyName: 'cropVariety',
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
                            child: DropdownButton2<CropVarietyModel?>(
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
                              value: state.cropVarietyModel,
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
                              items: state.cropVarietyList
                                  .map((s) => DropdownMenuItem<CropVarietyModel>(
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
                              onChanged: (CropVarietyModel? value) {
                                if (value != null) {
                                  state.updateCropVariety(context, value);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 14.h),
                        ],
                      ),
                    /*  TText(keyName:
                      "Is Crop Harvested",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.textDarkCl,
                        fontFamily: FontsStyle.medium,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                state.updateIsHarvested("1");
                              },
                              child: Container(
                                padding: EdgeInsets.all(3.h),
                                height: 18.h,
                                width: 18.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: ColorConstant.appCl, width: 1),
                                ),
                                child: Container(
                                  height: 18.h,
                                  width: 18.w,
                                  decoration: BoxDecoration(
                                    color: state.isHarvested == "1" ? ColorConstant.appCl : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 13.w),
                            TText(keyName:
                              "Yes",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.textLightCl,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 28.h),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                state.updateIsHarvested("0");
                              },
                              child: Container(
                                padding: EdgeInsets.all(3.h),
                                height: 18.h,
                                width: 18.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: ColorConstant.appCl, width: 1),
                                ),
                                child: Container(
                                  height: 18.h,
                                  width: 18.w,
                                  decoration: BoxDecoration(
                                    color: state.isHarvested == "0" ? ColorConstant.appCl : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 13.w),
                            TText(keyName:
                              "No",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.textLightCl,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),*/
                    RTTextSpan(
                      textAlign: TextAlign.start,
                      maxChildren: 2,
                      keyName: 'quantityType',
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
                      child: DropdownButton2<CropQuantitiesModel?>(
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
                        value: state.cropQuantitiesModel,
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
                        items: state.cropQuantitiesList
                            .map((s) => DropdownMenuItem<CropQuantitiesModel>(
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
                        onChanged: (CropQuantitiesModel? value) {
                          if (value != null) {
                            state.updateCropQuantities(context, value);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 14.h),
                    RTTextSpan(
                      textAlign: TextAlign.start,
                      maxChildren: 2,
                      keyName: 'quantity',
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
                    CustomTextField(
                        hintText: "enterQuantity",
                        controller: state.quantity,
                        borderCl: ColorConstant.borderCl,
                        txKeyboardType: TextInputType.number,
                        leading1: TText(
                          keyName: (state.cropQuantitiesModel?.slug ?? "").isNotEmpty
                              ? state.cropQuantitiesModel?.slug == "no_of_plants"
                                  ? "Plant(s)"
                                  : '${state.cropQuantitiesModel!.slug![0].toUpperCase()}${state.cropQuantitiesModel!.slug!.substring(1, state.cropQuantitiesModel!.slug!.length - 1)}(s)'
                              : "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.textDarkCl,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        )),
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
                              leading1: TText(
                                keyName: (state.cropQuantitiesModel?.slug ?? "").isNotEmpty
                                    ? state.cropQuantitiesModel?.slug == "no_of_plants"
                                        ? "per Plant"
                                        : 'per ${state.cropQuantitiesModel!.slug![0].toUpperCase()}${state.cropQuantitiesModel!.slug!.substring(1, state.cropQuantitiesModel!.slug!.length - 1)}'
                                    : "",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.medium,
                                  fontStyle: FontStyle.normal,
                                ),
                              )
                              /*  Image.asset(
                              ImageConstant.rupeeCircleIc,
                              height: 20.h,
                              width: 20.h,
                            ),*/
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
                    SizedBox(height: 16.h),
                    RTTextSpan(
                      textAlign: TextAlign.start,
                      maxChildren: 2,
                      keyName: 'sellerType',
                      style:TextStyle(
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
                        value: state.selectedSellerType,
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
                    SizedBox(height: 16.h),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 14.h),
                                      TText(
                                        keyName: "cropOrganic",
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
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          value: state.isOrganicController,
                                          hint: const TText(
                                            keyName: "isOrganic",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: "yes",
                                              child: TText(
                                                keyName: "yes",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: "no",
                                              child: TText(
                                                keyName: "no",
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
                                              state.updateIsOrganic(value);
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
                                      SizedBox(height: 14.h),
                                      TText(
                                        keyName: "qualityTested",
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
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          value: state.isQualityTestedController,
                                          hint: const TText(
                                            keyName: "isQualityTested",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: "yes",
                                              child: TText(
                                                keyName: "yes",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: "no",
                                              child: TText(
                                                keyName: "no",
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
                                              state.updateIsQualityTested(value);
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
                                      SizedBox(height: 14.h),
                                      TText(
                                        keyName: "storageCondition",
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
                                          value: state.storageCondition,
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
                                          items: state.storageList
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
                                              state.updateStorageCondition(value);
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 14.h),
                                      TText(
                                        keyName: "cropCondition",
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
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          value: state.cropCondition,
                                          hint: const TText(
                                            keyName: "select",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: "fresh",
                                              child: TText(
                                                keyName: "fresh",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: "dry",
                                              child: TText(
                                                keyName: "dry",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: "processed",
                                              child: TText(
                                                keyName: processed,
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
                                              state.updateCropCondition(value);
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
                                      SizedBox(height: 14.h),
                                      TText(
                                        keyName: "cropAge",
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
                                          value: state.age,
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
                                          items: state.ageList
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
                                              state.updateAge(value);
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
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
                                      SizedBox(height: 14.h),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
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
                            style:TextStyle(
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
                                      : Image.asset(
                                          ImageConstant.uploadImg,
                                          height: 124.h,
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
                                      : Image.asset(
                                          ImageConstant.uploadImg,
                                          height: 124.h,
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
                                      : Image.asset(
                                          ImageConstant.uploadImg,
                                          height: 124.h,
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
                        hintText:"addYourVoiceMessage",
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
                      state.createEditCattle(context, widget.arguments.id, widget.arguments.isEdit);
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

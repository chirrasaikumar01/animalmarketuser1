import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/buy/providers/buy_provider.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/sell/models/breed_list_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class FilterCattleBottomSheet {
  static show(BuildContext context, Function() function) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return Consumer<BuyProvider>(builder: (context, state, child) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  bottom: 20.h + MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  color: ColorConstant.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.dm),
                    topLeft: Radius.circular(16.dm),
                  ),
                ),
                child: Wrap(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 13.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.dm),
                              topLeft: Radius.circular(16.dm),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TText(keyName:
                                filter,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.regular,
                                  fontSize: 16.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  ImageConstant.closeIc,
                                  height: 24.h,
                                  width: 24.w,
                                  color: ColorConstant.textDarkCl,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12.h),
                              RichText(
                                text: TextSpan(
                                  text: animalCategory,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.textDarkCl,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
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
                                  hint: const TText(keyName:
                                    select,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
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
                                  onChanged: (SubCategoryListModel? value) {
                                    if (value != null) {
                                      state.updateSubCategory(context, value);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 14.h),
                              RichText(
                                text: TextSpan(
                                  text: breed,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.textDarkCl,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " *",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
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
                                  hint: const TText(keyName:
                                   select,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
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
                                  onChanged: (BreedListModel? value) {
                                    if (value != null) {
                                      state.updateBreed(context, value);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TText(keyName:
                                          minMilkCapacity,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.regular,
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomTextField(
                                          controller: state.minMilkCapacity,
                                          borderRadius: 10,
                                          hintText:enter,
                                          borderCl: ColorConstant.borderCl,
                                          txKeyboardType: TextInputType.number,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.h),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TText(keyName:
                                          maxMilkCapacity,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.regular,
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomTextField(
                                          controller: state.maxMilkCapacity,
                                          borderRadius: 10,
                                          hintText: enter,
                                          borderCl: ColorConstant.borderCl,
                                          txKeyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TText(keyName:
                                          minPrice,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.regular,
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomTextField(
                                          controller: state.minPrice,
                                          borderRadius: 10,
                                          hintText: enter,
                                          borderCl: ColorConstant.borderCl,
                                          txKeyboardType: TextInputType.number,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.h),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TText(keyName:
                                          maxPrice,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.regular,
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomTextField(
                                          controller: state.maxPrice,
                                          borderRadius: 10,
                                          hintText:enter,
                                          borderCl: ColorConstant.borderCl,
                                          txKeyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButtonWidget(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  style: CustomButtonStyle.style3,
                                  onPressed: () {
                                    state.resetFilter();
                                    function();
                                  },
                                  text: "",
                                  iconWidget: TText(keyName:
                                    clear,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.appCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.h),
                              Expanded(
                                child: CustomButtonWidget(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  style: CustomButtonStyle.style2,
                                  onPressed: function,
                                  text: "",
                                  iconWidget: TText(keyName:
                                    apply,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.textDarkCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }
}

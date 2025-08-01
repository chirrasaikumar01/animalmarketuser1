import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/category/models/category_list_model.dart';
import 'package:animal_market/modules/category/models/sub_category_list_model.dart';
import 'package:animal_market/modules/know_education/providers/know_education_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class FilterKnowBottomSheet {
  static show(BuildContext context, Function() function) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return Consumer<KnowEducationProvider>(builder: (context, state, child) {
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
                              TText(
                                keyName: "filter",
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
                              TText(
                                keyName: "category",
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
                                child: DropdownButton2<CategoryListModel?>(
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
                                  value: state.categoryListModel,
                                  hint: const TText(
                                    keyName: select,
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
                                  items: state.categoryList
                                      .map((s) => DropdownMenuItem<CategoryListModel>(
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
                                  onChanged: (CategoryListModel? value) {
                                    if (value != null) {
                                      state.updateCategory(context, value);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 14.h),
                              TText(
                                keyName: "subCategory",
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
                                    keyName: select,
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
                            ],
                          ),
                        ),
                        SizedBox(height: 60.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButtonWidget(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  style: CustomButtonStyle.style3,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  text: "",
                                  iconWidget: TText(
                                    keyName: "clear",
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
                                  iconWidget: TText(
                                    keyName: "apply",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
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

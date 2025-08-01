import 'dart:io';

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/account/models/city_list_model.dart';
import 'package:animal_market/modules/account/models/state_list_model.dart';
import 'package:animal_market/modules/doctor/models/edit_doctor_argument.dart';
import 'package:animal_market/modules/doctor/providers/doctor_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CreateAccountDoctorView extends StatefulWidget {
  final EditDoctorArgument argument;

  const CreateAccountDoctorView({super.key, required this.argument});

  @override
  State<CreateAccountDoctorView> createState() => _CreateAccountDoctorViewState();
}

class _CreateAccountDoctorViewState extends State<CreateAccountDoctorView> {
  late DoctorProvider provider;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<DoctorProvider>();
      if (widget.argument.isEdit) {
        provider.doctorHome(context, false).then((v) {
          if (mounted) {
          provider.stateListGet(context);}
        });
      } else {
        provider.reset();
        provider.stateListGet(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(title: "createDoctorAccount"),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),
                          CustomTextField(
                            labelText: "name",
                            hintText: "enterName",
                            controller: state.name,
                            borderRadius: 10.dm,
                            borderCl: ColorConstant.borderCl,
                            txKeyboardType: TextInputType.name,
                            leading1: Image.asset(
                              ImageConstant.asiUserIc,
                              height: 16.h,
                              width: 16.w,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return nameIsRequired;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField(
                            labelText: "clinicName",
                            hintText: "enterClinicName",
                            controller: state.clinicName,
                            borderRadius: 10.dm,
                            borderCl: ColorConstant.borderCl,
                            txKeyboardType: TextInputType.name,
                            leading1: Image.asset(
                              ImageConstant.hospitalIc,
                              height: 16.h,
                              width: 16.w,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return clinicNameIsRequired;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          TText(keyName:
                            "workExperience",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.textDarkCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(height: 6.h),
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
                              value: state.experience,
                              hint: const TText(keyName:
                                select,
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
                              items: state.experienceList
                                  .map((s) => DropdownMenuItem<String>(
                                        value: s,
                                        child: TText(keyName:
                                          " $s",
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
                                  state.updateExperience(value);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField(
                            labelText: "fees",
                            hintText: "enterFees",
                            controller: state.fees,
                            borderRadius: 10.dm,
                            borderCl: ColorConstant.borderCl,
                            txKeyboardType: TextInputType.number,
                            leading1: Image.asset(
                              ImageConstant.rupeeCircleIc,
                              height: 16.h,
                              width: 16.w,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enterFees";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          TText(keyName:
                            "states",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.textDarkCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<StateListModel?>(
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
                              value: state.stateModel,
                              hint: const TText(keyName:
                                "states",
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
                              items: state.stateList
                                  .map((s) => DropdownMenuItem<StateListModel>(
                                        value: s,
                                        child: TText(keyName:
                                          " ${s.name}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (StateListModel? value) {
                                if (value != null) {
                                  state.stateUpdate(context, value);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20.h),
                          TText(keyName:
                            "city",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.textDarkCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<CityListModel?>(
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
                              value: state.cityModel,
                              hint: const TText(keyName:
                                select,
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
                              items: state.cityList
                                  .map((s) => DropdownMenuItem<CityListModel>(
                                        value: s,
                                        child: TText(keyName:
                                          " ${s.city}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (CityListModel? value) {
                                if (value != null) {
                                  state.cityUpdate(value);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField(
                            labelText: "address",
                            hintText: "enterAddress",
                            controller: state.address,
                            borderRadius: 10.dm,
                            borderCl: ColorConstant.borderCl,
                            txKeyboardType: TextInputType.name,
                            leading1: Image.asset(
                              ImageConstant.locationIc,
                              height: 16.h,
                              width: 16.w,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return addressIsRequired;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField(
                            labelText: "postCode",
                            hintText: "enterPostCode",
                            controller: state.pinCode,
                            borderRadius: 10.dm,
                            maxLength: 6,
                            borderCl: ColorConstant.borderCl,
                            txKeyboardType: TextInputType.number,
                            leading1: Image.asset(
                              ImageConstant.pinLineIc,
                              height: 16.h,
                              width: 16.w,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "postCodeIsRequired";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField(
                            labelText:"aboutYourself",
                            hintText: "enter",
                            controller: state.aboutUs,
                            borderRadius: 10.dm,
                            borderCl: ColorConstant.borderCl,
                            txKeyboardType: TextInputType.name,
                            maxCheck: 5,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return aboutYourself;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFF9F9EC),
                        borderRadius: BorderRadius.circular(10.dm),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TText(keyName:
                            "photoClinic",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.textDarkCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          TText(keyName:
                            "youPostAGoodPhotos",
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
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12.dm),
                                          child: Image.file(
                                            File(state.image),
                                            height: 124.h,
                                            width: 115.w,
                                            fit: BoxFit.cover,
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
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12.dm),
                                          child: Image.file(
                                            File(state.image1),
                                            height: 124.h,
                                            width: 115.w,
                                            fit: BoxFit.cover,
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
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12.dm),
                                          child: Image.file(
                                            File(state.image2),
                                            height: 124.h,
                                            width: 115.w,
                                            fit: BoxFit.cover,
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
                                    state.onUploadImage(context, "image3");
                                  },
                                  child: state.image3 != ""
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12.dm),
                                          child: Image.file(
                                            File(state.image3),
                                            height: 124.h,
                                            width: 115.w,
                                            fit: BoxFit.cover,
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
                        ],
                      ),
                    ),
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
            bottomSheet: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: ColorConstant.black.withValues(alpha:0.25),
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
                      if (widget.argument.isEdit) {
                        state.createDoctor(context, "", true);
                      } else {
                        if (formKey.currentState!.validate()) {
                          if (state.image == "" || state.image1 == "" || state.image2 == "" || state.image3 == "") {
                            errorToast(context, pleaseUploadAllImages);
                            return;
                          }
                          if (state.experience == null) {
                            errorToast(context, pleaseSelectExperience);
                            return;
                          }
                          if (state.stateId == "") {
                            errorToast(context, pleaseSelectState);
                            return;
                          }
                          if (state.cityId == "") {
                            errorToast(context, pleaseSelectCity);
                            return;
                          }
                          state.createDoctor(context, "", false);
                        }
                      }
                    },
                    text: "",
                    iconWidget: TText(keyName:
                      "submit",
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
      },
    );
  }
}

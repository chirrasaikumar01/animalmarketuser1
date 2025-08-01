// ignore_for_file: must_be_immutable

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  String hintText;
  TextEditingController? controller;
  Widget? leading;
  Widget? leading1;
  TextCapitalization? textCapitalization;
  Widget? trailing;
  double? inputLabelWidth;
  double? inputFieldWidth;
  AutovalidateMode? autoValidateMode;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  List<String> options;
  bool isRequired;
  TextInputType? txKeyboardType;
  bool isEnabled;
  FocusNode? focusNode;
  bool isFocused;
  bool? obscureText;
  bool check;
  bool checking;
  bool changeColor;
  bool? readOnly;
  String? labelText;
  String? labelText1;
  String? labelIcon;
  String? counterText;
  TextInputAction? textInputAction;
  EdgeInsetsGeometry? paddingCustom;
  void Function(String)? onChanged;
  Function(String?)? onSaved;
  int maxCheck;
  int? maxLength;
  double? borderRadius;
  Color? borderCl;
  Color? fillColor;
  TextAlign? textAlign;
  final void Function(String)? onFieldSubmitted;
  Function()? onEditingComplete;
  Function()? onTap;
  final ValueChanged<String>? onOptionSelection;
  CrossAxisAlignment? crossAxisAlignmentDropV;
  MainAxisAlignment? mainAxisAlignmentDropV;

  CustomTextField({
    super.key,
    this.readOnly,
    this.hintText = "",
    this.counterText = "",
    this.maxCheck = 1,
    this.maxLength,
    this.leading,
    this.leading1,
    this.trailing,
    this.controller,
    this.labelText,
    this.labelText1,
    this.options = const [],
    this.inputFormatters,
    this.onTap,
    this.isRequired = false,
    this.onChanged,
    this.checking = false,
    this.inputLabelWidth,
    this.inputFieldWidth,
    this.isEnabled = true,
    this.txKeyboardType,
    this.obscureText,
    this.validator,
    this.focusNode,
    this.check = false,
    this.isFocused = false,
    this.onSaved,
    this.changeColor = false,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onOptionSelection,
    this.textCapitalization,
    this.borderCl,
    this.fillColor,
    this.borderRadius,
    this.autoValidateMode,
    this.paddingCustom,
    this.textAlign,
    this.crossAxisAlignmentDropV,
    this.mainAxisAlignmentDropV,
    this.labelIcon,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode != null) {
      widget.focusNode!.removeListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    setState(() {
      showDropdown = widget.focusNode!.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TText(keyName:
                widget.labelText!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.textDarkCl,
                  fontFamily: FontsStyle.medium,
                  fontStyle: FontStyle.normal,
                ),
              ),
              if (widget.labelIcon != null)
                Image.asset(
                  widget.labelIcon!,
                  height: 18,
                  width: 18,
                ),
            ],
          ),
        if (widget.labelText != null) const SizedBox(height: 6),
        TextFormField(
          readOnly: widget.readOnly ?? false,
          textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          controller: widget.controller,
          focusNode: widget.focusNode,
          autofocus: widget.isFocused,
          onFieldSubmitted: widget.onFieldSubmitted,
          onEditingComplete: widget.onEditingComplete,
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          keyboardType: widget.txKeyboardType ?? TextInputType.name,
          obscureText: widget.obscureText ?? false,
          enabled: widget.isEnabled,
          maxLines: widget.maxCheck,
          maxLength: widget.maxLength,
          onTap: widget.onTap,
          validator: widget.validator,
          textAlign: widget.textAlign ?? TextAlign.start,
          autovalidateMode: widget.autoValidateMode ?? AutovalidateMode.disabled,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: ColorConstant.black,
            fontFamily: FontsStyle.medium,
          ),
          decoration: InputDecoration(
            counterText: widget.counterText,
            fillColor: widget.fillColor ?? Colors.white,
            counterStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              fontFamily: FontsStyle.medium,
              color: ColorConstant.textDarkCl,
            ),
            filled: true,
            labelText: widget.labelText1,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10.sp,
              fontFamily: FontsStyle.regular,
              color: const Color(0xFF3A3838),
            ),
            contentPadding: widget.paddingCustom ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
              borderSide: BorderSide(
                color: widget.borderCl ?? ColorConstant.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
              borderSide: BorderSide(
                color: widget.borderCl ?? ColorConstant.white,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
              borderSide: BorderSide(
                color: widget.borderCl ?? ColorConstant.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
              borderSide: BorderSide(
                color: widget.borderCl ?? ColorConstant.white,
              ),
            ),
            hintText:Provider.of<TranslationsProvider>(context, listen: false).tr(widget.hintText) ,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: ColorConstant.hintTextCl,
              fontWeight: FontWeight.w500,
              fontFamily: FontsStyle.medium,
            ),
            isDense: true,
            suffixIcon: widget.leading1 == null ? null : Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: widget.leading1!),
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            prefixIcon: widget.leading == null
                ? null
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: widget.leading,
                  ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
        if (widget.focusNode != null && widget.options.isNotEmpty && showDropdown) const SizedBox(height: 4),
        if (widget.focusNode != null && widget.options.isNotEmpty && showDropdown)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: ColorConstant.white,
              borderRadius: BorderRadius.circular(20.dm),
              border: Border.all(
                width: 0.5,
                color: widget.borderCl ?? ColorConstant.white,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(115, 115, 115, 0.33),
                  blurRadius: 18,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: widget.crossAxisAlignmentDropV ?? CrossAxisAlignment.start,
              children: [
                ...widget.options.map(
                  (e) => InkWell(
                    onTap: () {
                      if (widget.controller != null) {
                        widget.controller!.text = e;
                        if (widget.onOptionSelection != null) {
                          widget.onOptionSelection!(e);
                        }
                      }
                      widget.focusNode!.unfocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: widget.mainAxisAlignmentDropV ?? MainAxisAlignment.start,
                        children: [
                          TText(keyName:
                            e,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: ColorConstant.black,
                              fontFamily: FontsStyle.regular,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
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
          )
      ],
    );
  }
}

class CustomDateField extends StatefulWidget {
  String hintText;
  TextEditingController? controller;
  double? inputLabelWidth;
  double? inputFieldWidth;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  List<String> options; //If user want to show a searchable dropdown
  bool isRequired;
  TextInputType? txKeyboardType;
  bool isEnabled;
  FocusNode? focusNode;
  bool isFocused;
  bool? obscureText;
  bool check;
  bool checking;
  bool changeColor;
  String labelText;
  void Function(String)? onChanged;
  Function(String?)? onSaved;
  int maxCheck;
  final void Function(String)? onFieldSubmitted;
  Function()? onEditingComplete;
  Function()? onTap;

  CustomDateField({
    super.key,
    this.hintText = "",
    this.maxCheck = 1,
    this.controller,
    this.labelText = "",
    this.options = const [],
    this.inputFormatters,
    this.onTap,
    this.isRequired = false,
    this.onChanged,
    this.checking = false,
    this.inputLabelWidth,
    this.inputFieldWidth,
    this.isEnabled = true,
    this.txKeyboardType,
    this.obscureText,
    this.validator,
    this.focusNode,
    this.check = false,
    this.isFocused = false,
    this.onSaved,
    this.changeColor = false,
    this.onFieldSubmitted,
    this.onEditingComplete,
  });

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TText(keyName:
          widget.labelText,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: widget.onTap,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            autofocus: widget.isFocused,
            onFieldSubmitted: widget.onFieldSubmitted,
            onEditingComplete: widget.onEditingComplete,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            keyboardType: widget.txKeyboardType ?? TextInputType.name,
            obscureText: widget.obscureText ?? false,
            enabled: widget.isEnabled,
            maxLines: widget.maxCheck,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
              suffixIcon: const Icon(
                Icons.calendar_month,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: ColorConstant.textLightCl,
              ),
            ),
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
          ),
        ),
      ],
    );
  }
}

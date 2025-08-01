import 'package:animal_market/core/export_file.dart';

enum CustomButtonStyle { style1, style2, style3, custom }

class CustomButtonWidget extends StatelessWidget {
  final CustomButtonStyle style;
  final Function onPressed;
  final String text;
  final Widget? content;
  final Widget? iconWidget;
  final Widget? widget;
  final bool enabled;
  final EdgeInsets padding;
  final bool? iconAlignRight;
  final double? width;

  const CustomButtonWidget({
    super.key,
    this.style = CustomButtonStyle.style1,
    required this.onPressed,
    required this.text,
    this.width,
    this.content,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.iconWidget,
    this.iconAlignRight, this.widget,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case CustomButtonStyle.style1:
        return InkWell(
          onTap: enabled
              ? () {
                  onPressed();
                }
              : null,
          child: Container(
            width: width ?? MediaQuery.of(context).size.width,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: enabled ? ColorConstant.white : ColorConstant.buttonCl,
            ),
            child: Center(
              child: TText(keyName:
                text,
                style: const TextStyle(color: ColorConstant.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      case CustomButtonStyle.style2:
        return ElevatedButton(
          onPressed: enabled
              ? () {
                  onPressed();
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(width ?? MediaQuery.of(context).size.width, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.dm),
              side: BorderSide(
                color: enabled ? ColorConstant.buttonCl : ColorConstant.buttonCl,
                width: 1,
              ),
            ),
            elevation: 0,
            shadowColor: enabled ? ColorConstant.buttonCl : null,
            backgroundColor: ColorConstant.buttonCl,
          ),
          child: Container(
            width: width ?? MediaQuery.of(context).size.width,
            padding: padding,
            decoration: BoxDecoration(
              color: enabled ? null : ColorConstant.buttonCl,
              borderRadius: BorderRadius.circular(10.dm),
              border: Border.all(
                color: enabled ? ColorConstant.white : ColorConstant.buttonCl,
              ),
            ),
            child: Center(
              child:widget ?? (iconWidget != null
                  ? ((iconAlignRight ?? false)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            TText(keyName:
                              text,
                              style: TextStyle(
                                color: enabled ? ColorConstant.textDarkCl : ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            iconWidget!,
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconWidget!,
                            const SizedBox(
                              width: 10,
                            ),
                            TText(keyName:
                              text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: FontsStyle.medium,
                                color: enabled ? ColorConstant.white : ColorConstant.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ))
                  : TText(keyName:
                      text,
                      style: TextStyle(
                        color: enabled ? ColorConstant.textDarkCl : ColorConstant.textDarkCl,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        fontFamily: FontsStyle.medium,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
            ),
          ),
        );
      case CustomButtonStyle.style3:
        return InkWell(
          onTap: enabled
              ? () {
                  onPressed();
                }
              : null,
          child: Container(
            width: width ?? MediaQuery.of(context).size.width,
            padding: padding,
            decoration: BoxDecoration(
              color: enabled ? ColorConstant.white : ColorConstant.white,
              borderRadius: BorderRadius.circular(10.dm),
              border: Border.all(
                color: enabled ? ColorConstant.appCl : ColorConstant.appCl,
              ),
            ),
            child: Center(
              child: iconWidget != null
                  ? ((iconAlignRight ?? false)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TText(keyName:
                              text,
                              style: TextStyle(
                                color: enabled ? ColorConstant.appCl : ColorConstant.appCl,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            iconWidget!,
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconWidget!,
                            const SizedBox(
                              width: 10,
                            ),
                            TText(keyName:
                              text,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: FontsStyle.medium,
                                color: enabled ? ColorConstant.appCl : ColorConstant.appCl,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ))
                  : TText(keyName:
                      text,
                      style: TextStyle(color: enabled ? ColorConstant.appCl : ColorConstant.appCl, fontWeight: FontWeight.w500),
                    ),
            ),
          ),
        );
      default:
        return InkWell(
          onTap: enabled
              ? () {
                  onPressed();
                }
              : null,
          child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: enabled ? ColorConstant.appCl : ColorConstant.white,
              ),
              child: content),
        );
    }
  }

  Color mixColors(Color color1, Color color2, double factor) {
    return Color.lerp(color1, color2, factor)!;
  }
}

import 'package:animal_market/core/export_file.dart';

class CommonAppBar extends StatefulWidget {
  final String title;
  final Widget? action;
  final Function()? function;

  const CommonAppBar({super.key, required this.title, this.function, this.action});

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorConstant.appBarClOne,
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.borderCl,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: widget.function ??
                () {
                  Navigator.pop(context);
                },
            child: Image.asset(
              ImageConstant.arrowBackIc,
              height: 24.h,
              width: 24.w,
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: TText(
              keyName:
              widget.title,
              maxLines:1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: ColorConstant.textDarkCl,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: FontsStyle.medium,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          widget.action ?? SizedBox.shrink(),
        ],
      ),
    );
  }
}

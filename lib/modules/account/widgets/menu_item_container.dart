import 'package:animal_market/core/export_file.dart';

class MenuItemContainer extends StatefulWidget {
  final String icon;
  final String name;
  final Function() tb;

  const MenuItemContainer({super.key, required this.icon, required this.name, required this.tb});

  @override
  State<MenuItemContainer> createState() => _MenuItemContainerState();
}

class _MenuItemContainerState extends State<MenuItemContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.tb,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(109, 109, 53, 0.18),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(10.dm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.icon,
              height: 40.h,
              width: 40.w,
            ),
            const SizedBox(
              height: 18,
            ),
            TText(keyName:
              widget.name,
              textAlign: TextAlign.center,
              style:  TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: ColorConstant.textDarkCl,
                fontFamily: FontsStyle.medium,
                fontStyle: FontStyle.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}

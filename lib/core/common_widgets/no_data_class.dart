

import 'package:animal_market/core/export_file.dart';

class NoDataClass extends StatefulWidget {
  final double height;
  final String text;

  const NoDataClass({super.key, required this.height, required this.text});

  @override
  State<NoDataClass> createState() => _NoDataClassState();
}

class _NoDataClassState extends State<NoDataClass> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.height,
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageConstant.noDataFoundImg,
              height: 200.h,
              width: 200.w,
            ),
            TText(keyName:
              widget.text,
              style: TextStyle(
                color: ColorConstant.darkAppCl,
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                fontFamily: FontsStyle.semiBold,
              ),
            ),
          ],
        ),

      ),
    );
  }
}

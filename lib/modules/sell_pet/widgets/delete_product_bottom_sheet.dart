import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/export_file.dart';

class DeleteProductBottomSheet {
  static show(BuildContext context, Function() function) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
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
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                        decoration: BoxDecoration(
                          color: ColorConstant.borderCl,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.dm),
                            topLeft: Radius.circular(16.dm),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    ImageConstant.arrowLeftIc,
                                    height: 16.h,
                                    width: 12.w,
                                  ),
                                  SizedBox(width: 14.w),
                                  TText(
                                    keyName: "delete",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ColorConstant.textDarkCl,
                                      fontFamily: FontsStyle.regular,
                                      fontSize: 14.sp,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                ImageConstant.closeIc,
                                height: 22.h,
                                width: 22.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: RTTextSpan(
                          textAlign: TextAlign.start,
                          maxChildren: 0,
                          keyName: 'areYourSureYouWantToDeleteThisListing',
                          style: TextStyle(
                            color: ColorConstant.textDarkCl,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ), items: [],
                        ),
                      ),
                      SizedBox(height: 42.h),
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
                                  keyName: "no",
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
                                  keyName: "yes",
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
      },
    );
  }
}

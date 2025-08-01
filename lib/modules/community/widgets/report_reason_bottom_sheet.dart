import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/community/providers/community_provider.dart';

class ReportReasonBottomSheet {
  static show(BuildContext context, Function() function) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return Consumer<CommunityProvider>(builder: (context, state, child) {
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
                              Row(
                                children: [
                                  Image.asset(
                                    ImageConstant.arrowLeftIc,
                                    height: 16.h,
                                    width: 12.w,
                                  ),
                                  SizedBox(width: 14.w),
                                  TText(keyName:
                                    "Report",
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
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: "Please select reason to  ",
                              style: TextStyle(
                                color: ColorConstant.textDarkCl,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                fontFamily: FontsStyle.medium,
                                fontStyle: FontStyle.normal,
                              ),
                              children: [
                                TextSpan(
                                  text: "Report Post ?",
                                  style: TextStyle(
                                    color: ColorConstant.appCl,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    fontFamily: FontsStyle.regular,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                              itemCount: state.reasonList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                var reason = state.reasonList[index];
                                return GestureDetector(
                                  onTap: () {
                                    state.selectReason(reason.id.toString());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: state.selectedReasonId == reason.id.toString() ? const Color(0xff1B6D19) : Colors.white,
                                              border: Border.all(
                                                color: const Color(0XFFDCDCDC),
                                                width: 1,
                                              ),
                                            ),
                                            width: 25,
                                            height: 25,
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 14,
                                            )),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: TText(keyName:
                                            reason.title.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff1A371A),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(height: 17.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButtonWidget(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  style: CustomButtonStyle.style2,
                                  onPressed: function,
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

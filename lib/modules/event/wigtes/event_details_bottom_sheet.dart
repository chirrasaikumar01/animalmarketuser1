import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/event/models/event_list_model.dart';
import 'package:animal_market/modules/event/providers/event_provider.dart';

class EventDetailsBottomSheet {
  static show(BuildContext context, EventListModel eventData) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return Consumer<EventProvider>(builder: (context, state, child) {
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
                                "eventDetails",
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
                        SizedBox(height: 22.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 17.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.h),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(10.dm),
                                ),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        TText(keyName:
                                        "date",
                                          style: TextStyle(
                                            color: ColorConstant.black,
                                            fontFamily: FontsStyle.medium,
                                            fontSize: 14.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TText(keyName:
                                        " & ",
                                          style: TextStyle(
                                            color: ColorConstant.black,
                                            fontFamily: FontsStyle.medium,
                                            fontSize: 14.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TText(keyName:
                                        "time",
                                          style: TextStyle(
                                            color: ColorConstant.black,
                                            fontFamily: FontsStyle.medium,
                                            fontSize: 14.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TText(keyName:
                                          " : ${eventData.date} , ${eventData.startTime}",
                                          style: TextStyle(
                                            color: ColorConstant.black,
                                            fontFamily: FontsStyle.medium,
                                            fontSize: 14.sp,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              TText(keyName:
                                eventData.title!,
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.regular,
                                  fontSize: 16.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              TText(keyName:
                                eventData.description!,
                                style: TextStyle(
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.regular,
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 30.h),
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

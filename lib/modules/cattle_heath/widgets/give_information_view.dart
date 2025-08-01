import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/cattle_heath/providers/cattle_health_provider.dart';

class GiveInformationView extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const GiveInformationView({super.key, required this.onNext, required this.onPrevious});

  @override
  State<GiveInformationView> createState() => _GiveInformationViewState();
}

class _GiveInformationViewState extends State<GiveInformationView> {
  late CattleHealthProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = context.read<CattleHealthProvider>();
      provider.reportPlanList(context);
      provider.initRazorPay();
      provider.userDetails(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading1 = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CattleHealthProvider>(builder: (context, state, child) {
      return Scaffold(
        backgroundColor: ColorConstant.white,
        resizeToAvoidBottomInset: false,
        body: Builder(builder: (context) {
          if (state.isLoading1) {
            return LoaderClass(height: double.infinity);
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Image.asset(
                        ImageConstant.reportFilledIc,
                        height: 20.h,
                        width: 20.w,
                      ),
                      SizedBox(width: 6.w),
                      TText(keyName:
                        "chooseTypeOfReport",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.semiBold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        itemCount: state.planList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var item = state.planList[index];
                          return GestureDetector(
                            onTap: () {
                              state.updatePlan(context, item);
                            },
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      state.selectedPlanId == item.id.toString() ? ImageConstant.selectedRIc : ImageConstant.unSelectedIc,
                                      height: 18.h,
                                      width: 18.w,
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          TText(keyName:
                                            item.title.toString(),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: state.selectedPlanId == item.id.toString() ? ColorConstant.textDarkCl : ColorConstant.textLightCl,
                                              fontFamily: FontsStyle.medium,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          TText(keyName:
                                            item.description.toString(),
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: state.selectedPlanId == item.id.toString() ? ColorConstant.textDarkCl : ColorConstant.textLightCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    TText(keyName:
                                      "₹ ${item.price}",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: state.selectedPlanId == item.id.toString() ? ColorConstant.textDarkCl : ColorConstant.textLightCl,
                                        fontFamily: FontsStyle.medium,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h)
                              ],
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Image.asset(
                        ImageConstant.messageIc,
                        height: 20.h,
                        width: 20.w,
                      ),
                      SizedBox(width: 6.w),
                      TText(keyName:
                        "moreInformation",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkCl,
                          fontFamily: FontsStyle.semiBold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  TText(keyName:
                    "ifAny",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.textLightCl,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    borderCl: ColorConstant.borderCl,
                    hintText: "enter",
                    maxCheck: 4,
                    controller: state.desController,
                  ),
                  SizedBox(height: 350.h),
                ],
              ),
            ),
          );
        }),
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
                onPressed: () async {
                  if (state.selectedPlanId == "") {
                    errorToast(context, pleaseSelectReportType);
                    return;
                  }
                  if (state.desController.text == "") {
                    errorToast(context, addMoreInformation);
                    return;
                  } else {
                    var status = await state.healthReportAdd(context);
                    if (status) {
                      widget.onNext();
                    } else {
                      if (context.mounted) {
                        errorToast(context, "Something went wrong");
                      }
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
      );
    });
  }
}

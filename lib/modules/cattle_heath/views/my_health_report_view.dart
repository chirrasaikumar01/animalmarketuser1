import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/cattle_heath/providers/cattle_health_provider.dart';
import 'package:animal_market/services/api_url.dart';

class MyHealthReportView extends StatefulWidget {
  const MyHealthReportView({super.key});

  @override
  State<MyHealthReportView> createState() => _MyHealthReportViewState();
}

class _MyHealthReportViewState extends State<MyHealthReportView> {
  late CattleHealthProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = context.read<CattleHealthProvider>();
      provider.myHealthReport(context, "");
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading2 = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CattleHealthProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: PreferredSize(preferredSize: Size(double.infinity, 60.h), child: CommonAppBar(title: "myReports")),
          body: Builder(
            builder: (context) {
              if (state.isLoading2) {
                return LoaderClass(height: double.infinity);
              }
              if (state.myReportAll.isEmpty) {
                return NoDataClass(
                  height: double.infinity,
                  text: "noReportFound",
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    SizedBox(height: 14.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.myReportAll.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, index) {
                          var item = state.myReportAll[index];
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                            margin: EdgeInsets.only(bottom: 11.h),
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                              borderRadius: BorderRadius.circular(10.dm),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        TText(keyName:
                                        "reportId",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant.textLightCl,
                                            fontFamily: FontsStyle.regular,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        TText(keyName:
                                        " : ${item.uniqueCode}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant.textLightCl,
                                            fontFamily: FontsStyle.regular,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        TText(keyName:
                                        "transactionId",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant.textLightCl,
                                            fontFamily: FontsStyle.regular,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        TText(keyName:
                                        ": ${item.transactionId}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant.textLightCl,
                                            fontFamily: FontsStyle.regular,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Divider(color: ColorConstant.borderCl, height: 1.h),
                                SizedBox(height: 10.h),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 7.h),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1F1F1),
                                    borderRadius: BorderRadius.circular(4.dm),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TText(keyName:
                                      "noteByYou",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstant.textDarkCl,
                                          fontFamily: FontsStyle.regular,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      TText(keyName:
                                      "${item.moreInfo}",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstant.textLightCl,
                                          fontFamily: FontsStyle.regular,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        TText(keyName:
                                        "payment",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.regular,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        TText(keyName:
                                        " ₹ ${item.totalFees}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant.textDarkCl,
                                            fontFamily: FontsStyle.regular,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (item.document != "")
                                      GestureDetector(
                                        onTap: () {
                                          state.downloadPdf1(context, "${ApiUrl.imageUrl}${item.document}");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                          decoration: BoxDecoration(color: ColorConstant.appCl, borderRadius: BorderRadius.circular(4.dm)),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                ImageConstant.downloadIc,
                                                height: 24.h,
                                                width: 24.w,
                                              ),
                                              SizedBox(width: 4.w),
                                              TText(keyName:
                                              "downLoadReport",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: ColorConstant.white,
                                                  fontFamily: FontsStyle.regular,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

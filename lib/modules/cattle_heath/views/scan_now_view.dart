// ignore_for_file: deprecated_member_use

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/cattle_heath/providers/cattle_health_provider.dart';
import 'package:animal_market/modules/cattle_heath/widgets/give_information_view.dart';
import 'package:animal_market/modules/cattle_heath/widgets/payment_report_view.dart';
import 'package:animal_market/modules/cattle_heath/widgets/payment_successfully_view.dart';
import 'package:animal_market/modules/cattle_heath/widgets/record_video_view.dart';

class ScanNowView extends StatefulWidget {
  const ScanNowView({super.key});

  @override
  State<ScanNowView> createState() => _ScanNowViewState();
}

class _ScanNowViewState extends State<ScanNowView> {
  late CattleHealthProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<CattleHealthProvider>();
      provider.currentStep = 0;
      provider.resetData();
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.currentStep = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CattleHealthProvider>(builder: (context, state, child) {
      return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          if (state.currentStep > 0) {
            state.previousStep();
            return false;
          } else {
            Navigator.pop(context);
            return willLeave;
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(
                title: "scanNow",
                function: () {
                  if (state.currentStep > 0) {
                    if (state.currentStep == 3) {
                      Navigator.pop(context);
                    } else {
                      state.previousStep();
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: 13.h, width: MediaQuery.of(context).size.width),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: state.buildStep(0, ImageConstant.mobilePhoneIc, "recordVideo","recordVideo1")),
                      Expanded(child: state.buildStepContainer(1)),
                      Expanded(child: state.buildStep(1, ImageConstant.infoIc, "giveInformation","giveInformation1")),
                      Expanded(child: state.buildStepContainer(2)),
                      Expanded(child: state.buildStep(2, ImageConstant.payIc, "paymentS","\n")),
                      Expanded(child: state.buildStepContainer(3)),
                      Expanded(child: state.buildStep(3, ImageConstant.openFolderIc, "getReport","getReport1")),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: state.currentStep == 0
                      ? RecordVideoView(
                          onNext: state.nextStep,
                          onPrevious: state.previousStep,
                        )
                      : state.currentStep == 1
                          ? GiveInformationView(
                              onNext: state.nextStep,
                              onPrevious: state.previousStep,
                            )
                          : state.currentStep == 2
                              ? PaymentReportView(
                                  onNext: state.nextStep,
                                  onPrevious: state.previousStep,
                                )
                              : PaymentSuccessfullyView(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

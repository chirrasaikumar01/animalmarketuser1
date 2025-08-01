import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/cms/models/cms_arguments.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportView extends StatefulWidget {
  final CmsArguments arguments;

  const HelpAndSupportView({super.key, required this.arguments});

  @override
  State<HelpAndSupportView> createState() => _HelpAndSupportViewState();
}

class _HelpAndSupportViewState extends State<HelpAndSupportView> {
  late AccountProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<AccountProvider>();
      provider.getCmsPages(context, widget.arguments.type);
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.appBarClOne,
          appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(
                title: widget.arguments.title,
              )),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  children: [
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              var url = "tel:+91${state.mobileNo}";
                              if (await launchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 29.h),
                              decoration: BoxDecoration(
                                boxShadow: [
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
                                children: [
                                  Image.asset(
                                    ImageConstant.acceptIc,
                                    height: 40.h,
                                    width: 40.w,
                                  ),
                                  SizedBox(height: 40.h),
                                  TText(keyName:
                                    callUs,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.darkAppCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await launchUrl(
                                Uri.parse("https://wa.me/+91${state.whatsappNo}/?text=Hii..."),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 29.h),
                              decoration: BoxDecoration(
                                boxShadow: [
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
                                children: [
                                  Image.asset(
                                    ImageConstant.chatNewIc,
                                    height: 40.h,
                                    width: 40.w,
                                  ),
                                  SizedBox(height: 40.h),
                                  TText(keyName:
                                    chatUs,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.darkAppCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final Uri params = Uri(
                                scheme: 'mailto',
                                path: state.email,
                                query: 'subject=Support & body=Hi,',
                              );
                              await launchUrl(
                                (params),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 29.h),
                              decoration: BoxDecoration(
                                boxShadow: [
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
                                children: [
                                  Image.asset(
                                    ImageConstant.emailIc,
                                    height: 40.h,
                                    width: 40.w,
                                  ),
                                  SizedBox(height: 40.h),
                                  TText(keyName:
                                    emailUs,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.darkAppCl,
                                      fontFamily: FontsStyle.medium,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                child: state.isLoading
                    ? LoaderClass(
                        height: MediaQuery.of(context).size.height,
                        color: ColorConstant.appCl.withValues(alpha:0.30),
                      )
                    : SizedBox(),
              )
            ],
          ),
        ),
      );
    });
  }
}

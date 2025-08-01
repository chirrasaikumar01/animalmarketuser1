import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/auth/models/language_argument.dart';
import 'package:animal_market/modules/auth/providers/auth_provider.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:animal_market/routes/routes.dart';

class SelectLanguageView extends StatefulWidget {
  final LanguageArgument argument;

  const SelectLanguageView({super.key, required this.argument});

  @override
  State<SelectLanguageView> createState() => _SelectLanguageViewState();
}

class _SelectLanguageViewState extends State<SelectLanguageView> {
  late AuthProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<AuthProvider>();
      provider.languageListGet(context);
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
    return Consumer<AuthProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: widget.argument.isEdit ? PreferredSize(preferredSize: Size(double.infinity, 70.h), child: CommonAppBar(title: "Edit Language")) : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.argument.isEdit == true ? SizedBox() : SizedBox(height: 30.h),
              widget.argument.isEdit == true
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: RichText(
                        text: TextSpan(
                          text: selectYourPreferred,
                          style: TextStyle(
                            color: ColorConstant.textDarkCl,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                          children: [
                            WidgetSpan(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(6.dm),
                                ),
                                child: TText(keyName:
                                  language,
                                  style: TextStyle(
                                    color: ColorConstant.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: 30.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Builder(builder: (context) {
                    if (state.isLoading) {
                      return LoaderClass(height: 400.h);
                    }
                    if (state.languageList.isEmpty) {
                      return NoDataClass(
                        height: 400.h,
                        text: noLanguageFound,
                      );
                    }
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.9,
                      ),
                      shrinkWrap: true,
                      itemCount: state.languageList.length,
                      itemBuilder: (context, index) {
                        final firstLetter = state.languageList[index].firstLetter ?? "";
                        final language = state.languageList[index].title ?? "";
                        return GestureDetector(
                          onTap: () {
                            state.updateLanguageCode(state.languageList[index].languageCode ?? "");
                            state.updateLanguage(state.languageList[index].firstLetter ?? "",state.languageList[index].languageCode ?? "");
                            if (widget.argument.isEdit == true) {
                              state.changeLanguage(context);
                              Provider.of<TranslationsProvider>(context, listen: false).loadLanguage(state.languageCode);
                            } else {
                              Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
                              Provider.of<TranslationsProvider>(context, listen: false).loadLanguage(state.languageCode);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorConstant.borderCl,
                                width: 1.w,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC8DFB3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: TText(keyName:
                                      firstLetter,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Color(0xFF296439),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                TText(keyName:
                                  language,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Color(0xFF062D10),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 17.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(2),
                                    bottomLeft: Radius.circular(2),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.appCl,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Image.asset(
                                      ImageConstant.newArrowLang,
                                      color: Colors.white,
                                      height: 18.h,
                                      width: 15.w,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              widget.argument.isEdit == true
                  ? SizedBox(height: 30.h)
                  : Image.asset(
                      ImageConstant.bottomLngImg,
                      height: 120.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
            ],
          ),
        ),
      );
    });
  }
}

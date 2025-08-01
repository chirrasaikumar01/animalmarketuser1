import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/faq/providers/faq_provider.dart';

class FaqsView extends StatefulWidget {
  const FaqsView({super.key});

  @override
  State<FaqsView> createState() => _FaqsViewState();
}

class _FaqsViewState extends State<FaqsView> {
  late FaqProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = context.read<FaqProvider>();
      provider.faqsGet(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading = true;
    provider.selectedIndex = -1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FaqProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(title: "faq"),
            ),
            resizeToAvoidBottomInset: false,
            body: Builder(
              builder: (context) {
                if (state.isLoading) {
                  return LoaderClass(
                    height: double.infinity,
                  );
                }
                if (state.faqsList.isEmpty) {
                  return NoDataClass(height: double.infinity, text: noDataFound,);
                }
                return Column(
                  children: [
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(243, 248, 255, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TText(keyName:
                            "frequentAskedQuestion",
                            style: TextStyle(
                              color: ColorConstant.appCl,
                              fontSize: 14,
                              fontFamily: FontsStyle.regular,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Image.asset(
                            ImageConstant.faqIc1,
                            height: 40,
                            width: 40,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.faqsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      if (state.selectedIndex == index) {
                                        state.updateIndex(-1);
                                      } else {
                                        state.updateIndex(index);
                                      }
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 22,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          TText(keyName:
                                            "${index + 1}",
                                            style: TextStyle(
                                              color: state.selectedIndex == index ? ColorConstant.appCl : ColorConstant.textLightCl,
                                              fontFamily: FontsStyle.medium,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TText(keyName:
                                              state.faqsList[index].title.toString(),
                                              style: TextStyle(
                                                color: state.selectedIndex == index ? ColorConstant.appCl : ColorConstant.textLightCl,
                                                fontFamily: FontsStyle.medium,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (state.selectedIndex == index) {
                                                state.updateIndex(-1);
                                              } else {
                                                state.updateIndex(index);
                                              }
                                            },
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Center(
                                                child: TText(keyName:
                                                  state.selectedIndex == index ? "+" : "-",
                                                  style: const TextStyle(
                                                    color: ColorConstant.appCl,
                                                    fontFamily: FontsStyle.medium,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                const SizedBox(height: 8),
                                state.selectedIndex == index
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 18, right: 2),
                                        child: TText(keyName:
                                          state.faqsList[index].answer.toString(),
                                          style: const TextStyle(
                                            color: Color(0xFF4A4A4A),
                                            fontFamily: FontsStyle.regular,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 8),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Divider(
                                    color: ColorConstant.borderCl,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 22),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

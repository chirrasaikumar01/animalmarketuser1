import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/cms/models/cms_arguments.dart';
import 'package:flutter_html/flutter_html.dart';

class CmsView extends StatefulWidget {
  final CmsArguments cmsArguments;

  const CmsView({super.key, required this.cmsArguments});

  @override
  State<CmsView> createState() => _CmsViewState();
}

class _CmsViewState extends State<CmsView> {
  late AccountProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<AccountProvider>();
      provider.getCmsPages(context, widget.cmsArguments.type);
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
                title: widget.cmsArguments.title,
              )),
          body: Builder(builder: (context) {
            if (state.isLoading) {
              return LoaderClass(
                height: MediaQuery.of(context).size.height - 50,
              );
            }
            if (state.noData) {
              return NoDataClass(
                height: MediaQuery.of(context).size.height - 50,
                text: noDataFound,
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    Html(
                      data: state.content,
                      style: {
                        "body": Style(
                          fontSize: FontSize(12),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontsStyle.medium,
                        ),
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}

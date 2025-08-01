import 'dart:io';

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/common_widgets/player_widget.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/helper/deep_link_service.dart';
import 'package:animal_market/helper/share_service.dart';
import 'package:animal_market/modules/know_education/model/know_argument.dart';
import 'package:animal_market/modules/know_education/providers/know_education_provider.dart';
import 'package:animal_market/modules/know_education/views/full_doc_view.dart';
import 'package:animal_market/modules/know_education/views/full_pdf_view.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class KnowledgeDetailsView extends StatefulWidget {
  final KnowArgument argument;

  const KnowledgeDetailsView({super.key, required this.argument});

  @override
  State<KnowledgeDetailsView> createState() => _KnowledgeDetailsViewState();
}

class _KnowledgeDetailsViewState extends State<KnowledgeDetailsView> {
  late KnowEducationProvider provider;

  Future<void> _downloadAndOpenFile(String url) async {
    try {
      showProgress(context);
      final response = await http.get(Uri.parse(url));
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/document.docx';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      OpenFile.open(filePath);
      if (mounted) {
        closeProgress(context);
        successToast(context, "Opening Document...");
      }
    } catch (e) {
      if (mounted) {
        closeProgress(context);
        errorToast(context, "Error downloading document");
        Log.console("Error downloading file: $e");
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<KnowEducationProvider>();
      provider.knowledgeDetailsGet(context, widget.argument.knowledgeListData.id.toString());
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
    return Consumer<KnowEducationProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.appBarClOne,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 80.h),
              child: CommonAppBar(
                title: state.knowledgeListData.title ?? "",
                action: state.noData || state.isLoading2
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          final link = DeepLinkService().generateDeePLink(state.knowledgeListData.catId.toString(), state.knowledgeListData.id.toString(), "Knowledge");
                          final imageUrl = state.knowledgeListData.image != null && state.knowledgeListData.image!.isNotEmpty ? state.knowledgeListData.image : "";

                          if (link.isNotEmpty) {
                            ShareService.shareProduct(
                              title: state.knowledgeListData.title ?? "",
                              imageUrl: "${ApiUrl.imageUrl}${imageUrl ?? " "}",
                              link: link,
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: ColorConstant.white,
                            borderRadius: BorderRadius.circular(4.dm),
                            border: Border.all(color: ColorConstant.borderCl),
                          ),
                          child: Image.asset(
                            ImageConstant.shareLineIc,
                            height: 22.h,
                            width: 22.w,
                            color: ColorConstant.appCl,
                          ),
                        ),
                      ),
              ),
            ),
            body: Builder(builder: (context) {
              if (state.isLoading2) {
                return LoaderClass(height: double.infinity);
              }
              if (state.noData) {
                return NoDataClass(text: noDataFound, height: double.infinity);
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.dm),
                            child: CustomImage(
                              placeholderAsset: ImageConstant.bannerImg,
                              errorAsset: ImageConstant.bannerImg,
                              radius: 10.dm,
                              imageUrl: state.knowledgeListData.image,
                              baseUrl: ApiUrl.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          TText(
                            keyName: state.knowledgeListData.title ?? "",
                            style: TextStyle(
                              color: ColorConstant.textDarkCl,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 9.h),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.appCl,
                              ),
                              children: [
                                TextSpan(text: state.knowledgeListData.categoryName ?? ""),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: ColorConstant.appCl,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14.sp,
                                  color: ColorConstant.white,
                                ),
                                SizedBox(width: 3.w),
                                TText(
                                  keyName:state.knowledgeListData.postedAgo ?? "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.white,
                                    fontFamily: FontsStyle.semiBold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Divider(color: ColorConstant.borderCl, thickness: 1.w),
                          SizedBox(height: 14.h),
                          Html(
                            data: (state.knowledgeListData.description ?? "")
                                .replaceAll(RegExp(r'<(p|div|br)[^>]*>\s*</\1>'), '')
                                .replaceAll(RegExp(r'\s{2,}'), ' ')
                                .replaceAllMapped(RegExp(r'(\d+\.\s[^\n]+)'), (match) => '${match.group(1)}<br><br>'),
                            extensions: const [TableHtmlExtension()],
                            style: {
                              "body": Style(
                                fontSize: FontSize(16),
                                whiteSpace: WhiteSpace.normal,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.justify,
                                fontFamily: FontsStyle.regular,
                                fontStyle: FontStyle.normal,
                                lineHeight: LineHeight(1.4),
                                color: Colors.black,
                                padding: HtmlPaddings.zero,
                                margin: Margins.zero,
                              ),

                              // Headings
                              "h1": Style(
                                fontSize: FontSize(24),
                                fontWeight: FontWeight.bold,
                                margin: Margins.only(bottom: 8),
                                fontFamily: FontsStyle.bold,
                                color: Colors.black,
                              ),
                              "h2": Style(
                                fontSize: FontSize(22),
                                fontWeight: FontWeight.bold,
                                margin: Margins.only(bottom: 6),
                                fontFamily: FontsStyle.bold,
                                color: Colors.black,
                              ),
                              "h3": Style(
                                fontSize: FontSize(20),
                                fontWeight: FontWeight.w600,
                                margin: Margins.only(bottom: 4),
                                fontFamily: FontsStyle.semiBold,
                                color: Colors.black,
                              ),
                              "h4": Style(
                                fontSize: FontSize(18),
                                fontWeight: FontWeight.w600,
                                fontFamily: FontsStyle.semiBold,
                                color: Colors.black,
                              ),

                              // Paragraph
                              "p": Style(
                                padding: HtmlPaddings.zero,
                                margin: Margins.symmetric(vertical: 8),
                                whiteSpace: WhiteSpace.normal,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.justify,
                                fontFamily: FontsStyle.regular,
                                fontStyle: FontStyle.normal,
                                lineHeight: LineHeight(1.5),
                                color: Colors.black,
                                wordSpacing: 2,
                              ),

                              // Bold / Italic text
                              "strong": Style(fontWeight: FontWeight.bold),
                              "em": Style(fontStyle: FontStyle.italic),
                              "b": Style(fontWeight: FontWeight.bold),
                              "i": Style(fontStyle: FontStyle.italic),

                              // Horizontal Rule
                              "hr": Style(
                                margin: Margins.symmetric(vertical: 12),
                                border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
                              ),

                              // Lists
                              "ul": Style(
                                padding: HtmlPaddings.only(left: 12),
                                margin: Margins.only(bottom: 6),
                                whiteSpace: WhiteSpace.normal,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.justify,
                                fontFamily: FontsStyle.regular,
                                lineHeight: LineHeight(1.4),
                                color: Colors.black,
                                wordSpacing: 2,
                              ),
                              "li": Style(
                                fontSize: FontSize(14),
                                padding: HtmlPaddings.only(bottom: 4),
                                whiteSpace: WhiteSpace.normal,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.justify,
                                fontFamily: FontsStyle.regular,
                                lineHeight: LineHeight(1.4),
                                color: Colors.black,
                                wordSpacing: 2,
                              ),

                              // Tables
                              "table": Style(
                                width: Width(MediaQuery.of(context).size.width * 0.90),
                                border: Border.all(color: Colors.black),
                                backgroundColor: Colors.transparent,
                                padding: HtmlPaddings.zero,
                                margin: Margins.symmetric(vertical: 8),
                                whiteSpace: WhiteSpace.normal,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.justify,
                                fontFamily: FontsStyle.semiBold,
                                lineHeight: LineHeight(1.2),
                                color: Colors.black,
                              ),
                              "tr": Style(
                                padding: HtmlPaddings.zero,
                                margin: Margins.symmetric(vertical: 4),
                                whiteSpace: WhiteSpace.normal,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.justify,
                                fontFamily: FontsStyle.semiBold,
                                lineHeight: LineHeight(1.2),
                                color: Colors.black,
                              ),
                              "td": Style(
                                padding: HtmlPaddings.all(8),
                                margin: Margins.zero,
                                border: Border.all(color: Colors.black),
                                fontSize: FontSize(12),
                                whiteSpace: WhiteSpace.normal,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.justify,
                                fontFamily: FontsStyle.semiBold,
                                lineHeight: LineHeight(1.2),
                                color: Colors.black,
                              ),
                              "th": Style(
                                padding: HtmlPaddings.all(4),
                                margin: Margins.zero,
                                backgroundColor: Colors.grey[300],
                                fontWeight: FontWeight.bold,
                                whiteSpace: WhiteSpace.normal,
                                textAlign: TextAlign.justify,
                                fontFamily: FontsStyle.semiBold,
                                lineHeight: LineHeight(1.2),
                                color: Colors.black,
                              ),
                            },
                          )

                        ],
                      ),
                      SizedBox(height: 14),
                      GestureDetector(
                        onTap: () async {
                          var url = state.knowledgeListData.link ?? "";
                          if (await launchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: ColorConstant.white,
                            border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                            borderRadius: BorderRadius.circular(10.dm),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TText(
                                keyName: 'Link',
                                style: TextStyle(
                                  color: ColorConstant.appCl,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TText(
                                      keyName: state.knowledgeListData.link ?? "",
                                      style: TextStyle(
                                        color: ColorConstant.appCl,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Image.asset(
                                    ImageConstant.clickIc,
                                    height: 24.h,
                                    width: 24.w,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      state.knowledgeListData.video != null && state.knowledgeListData.video!.isNotEmpty
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                color: ColorConstant.white,
                                border: Border(
                                  bottom: BorderSide(color: ColorConstant.borderCl, width: 1),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 7),
                                  TText(
                                    keyName: "video",
                                    style: TextStyle(
                                      color: ColorConstant.appCl,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  GestureDetector(
                                    onTap: () {
                                      if (state.knowledgeListData.video != null && state.knowledgeListData.video!.isNotEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => TikTokVideoPlayer(
                                                      videoUrl: ApiUrl.imageUrl + state.knowledgeListData.video.toString(),
                                                    )));
                                      } else {
                                        errorToast(context, "No Video Found");
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          ImageConstant.demoCategory,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context).size.width * 0.6,
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          left: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: Image.asset(
                                              ImageConstant.playIc,
                                              height: 24.h,
                                              width: 24.w,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: buttonsContainer(
                              imagePath: ImageConstant.pdfIc,
                              text: "viewPdf",
                              bgColor: ColorConstant.white,
                              borderColor: ColorConstant.borderC2,
                              onTap: () {
                                if (state.knowledgeListData.pdf == "") {
                                  errorToast(context, "No PDF found");
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => FullPdfView(url: ApiUrl.imageUrl + state.knowledgeListData.pdf, isDownload: false)));
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: buttonsContainer(
                              imagePath: ImageConstant.folderIc,
                              text: "viewDocument",
                              bgColor: ColorConstant.white,
                              borderColor: ColorConstant.borderC3,
                              onTap: () {
                                String documentUrl = state.knowledgeListData.document;
                                if (documentUrl.isEmpty) {
                                  errorToast(context, "No Document found");
                                  return;
                                }
                                String ext = documentUrl.split('.').last.toLowerCase(); // Fix extension check
                                String fullUrl = ApiUrl.imageUrl + documentUrl;
                                if (ext == "docx" || ext == "doc") {
                                  _downloadAndOpenFile(fullUrl);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullDocView(url: fullUrl, isDownload: false),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget buttonsContainer({
    required String imagePath,
    required String text,
    double imageSize = 50,
    Color bgColor = Colors.white,
    Color borderColor = Colors.grey,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1.w),
          borderRadius: BorderRadius.circular(10.dm),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: imageSize,
              width: imageSize,
            ),
            const SizedBox(height: 6),
            TText(
              keyName: text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

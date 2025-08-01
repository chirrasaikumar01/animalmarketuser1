import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FullPdfView extends StatefulWidget {
  final String url;
  final bool isDownload;

  const FullPdfView({super.key, required this.url, required this.isDownload});

  @override
  State<FullPdfView> createState() => _FullPdfViewState();
}

class _FullPdfViewState extends State<FullPdfView> {
  bool _documentLoadFailed = false;
  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(preferredSize: Size(double.infinity, 60.h), child: CommonAppBar(title: "Pdf")),
            body: _documentLoadFailed
                ? Center(
                    child: TText(keyName:
                      "noDataFound",
                      style: TextStyle(
                        color: ColorConstant.appCl,
                        fontFamily: FontsStyle.medium,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                : SfPdfViewer.network(
                    widget.url,
                    onDocumentLoadFailed: (error) {
                      setState(() {
                        _documentLoadFailed = true;
                      });
                    },
                    pageSpacing: 0,
                  ),
          ),
    );
  }
}

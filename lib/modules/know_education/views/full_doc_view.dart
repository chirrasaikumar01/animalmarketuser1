
import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:webview_flutter/webview_flutter.dart';
class FullDocView extends StatefulWidget {
  final String url;
  final bool isDownload;

  const FullDocView({super.key, required this.url, required this.isDownload});

  @override
  State<FullDocView> createState() => _FullDocViewState();
}

class _FullDocViewState extends State<FullDocView> {
  late WebViewController controller;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    Log.console("Document URL: ${widget.url}");
      _loadWebView(); // Load PDF in WebView
  }

  void _loadWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..enableZoom(true)
      ..loadRequest(Uri.parse(widget.url));

    setState(() {});
  }

  /// Downloads and opens the `.docx` file


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60.h),
          child: CommonAppBar(title: "document"),
        ),
        body: Stack(
          children: [
              WebViewWidget(controller: controller),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: ColorConstant.appCl,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/full_view_image/providers/full_image_view_controller.dart';

class FullImageView extends StatefulWidget {
  final String image;
  final bool isDownload;

  const FullImageView({super.key, required this.image, required this.isDownload});

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  late FullImageViewProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<FullImageViewProvider>();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FullImageViewProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(
                  title: "image",
                  action: Visibility(
                    visible: widget.isDownload,
                    child: GestureDetector(
                      onTap: () {
                        state.saveNetworkImage(context, widget.image);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Icon(
                          Icons.download,
                          color: ColorConstant.appCl,
                          size: 28.h,
                        ),
                      ),
                    ),
                  )),
            ),
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.dm),
                      child: CustomImage(
                        imageUrl: widget.image.toString(),
                        baseUrl: "",
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                        placeholderAsset: ImageConstant.imageGalleryIc,
                        errorAsset: ImageConstant.imageGalleryIc,
                        radius: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

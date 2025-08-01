import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/cattle_heath/providers/cattle_health_provider.dart';
import 'package:video_player/video_player.dart';

class RecordVideoView extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const RecordVideoView({super.key, required this.onNext, required this.onPrevious});

  @override
  State<RecordVideoView> createState() => _RecordVideoViewState();
}

class _RecordVideoViewState extends State<RecordVideoView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CattleHealthProvider>(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: ColorConstant.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.dm),
                    child: CustomImage(
                      placeholderAsset: ImageConstant.docBannerImg,
                      errorAsset: ImageConstant.docBannerImg,
                      radius: 10.dm,
                      imageUrl: "",
                      baseUrl: "",
                      height: 145.h,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10.dm),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(9.dm),
                      border: Border.all(color: ColorConstant.borderCl),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              ImageConstant.videoIc,
                              height: 20.h,
                              width: 20.w,
                            ),
                            SizedBox(width: 6.w),
                            TText(keyName:
                              "video",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.textDarkCl,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        TText(keyName:
                          "record",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.textLightCl,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        if (state.videoFile != "")
                           state.videoPlayerController!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: state.videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(state.videoPlayerController!),
                                )
                              : Container()
                        else
                          GestureDetector(
                            onTap: () {
                              state.pickMedia(context: context, isVideo: true);
                              state.isVideoUpdate(true);
                            },
                            child: Image.asset(
                              ImageConstant.videoUploadIc,
                              height: 70.h,
                              width: 115.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10.dm),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(9.dm),
                      border: Border.all(color: ColorConstant.borderCl),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              ImageConstant.imageGalleryIc,
                              height: 20.h,
                              width: 20.w,
                            ),
                            SizedBox(width: 6.w),
                            TText(keyName:
                              "image",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.textDarkCl,
                                fontFamily: FontsStyle.semiBold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        TText(keyName:
                          "captureThe",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.textLightCl,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Wrap(
                          spacing: 5.w,
                          runSpacing: 10.h,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: [
                            ...state.images.asMap().entries.map((entry) {
                              int index = entry.key;
                              var file = entry.value;
                              return Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.dm)),
                                margin: EdgeInsets.only(right: 2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.dm),
                                  child: Stack(
                                    children: [
                                      Image.file(
                                        file,
                                        height: 70.h,
                                        width: 76.w,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        right: 3,
                                        top: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            state.removeImage(index);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 2.w,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: 10.sp,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            GestureDetector(
                              onTap: () {
                                state.pickMedia(context: context, isVideo: false);
                                state.isVideoUpdate(false);
                              },
                              child: Image.asset(
                                ImageConstant.uploadImageIc,
                                height: 70.h,
                                width: 76.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 120.h)
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: ColorConstant.black.withValues(alpha:0.25),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ], color: ColorConstant.white),
            child: Wrap(
              children: [
                CustomButtonWidget(
                  style: CustomButtonStyle.style2,
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  onPressed: () {
                    if (state.videoFile == "") {
                      errorToast(context, pleaseUploadVideo);
                      return;
                    } else if (state.images.isEmpty) {
                      errorToast(context, pleaseUploadImage);
                      return;
                    } else {
                      widget.onNext();
                    }
                  },
                  text: "",
                  iconWidget: TText(keyName:
                    "submit",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.textDarkCl,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

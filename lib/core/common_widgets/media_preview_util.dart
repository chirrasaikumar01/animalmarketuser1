import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/player_widget.dart';
import 'package:animal_market/core/image_constant.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MediaPreviewUtil {
  static void showMediaPreviewDialog(
      BuildContext context, {
        required String image,
        required bool isVideo,
      }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: isVideo
                  ? TikTokVideoPlayer(videoUrl: "${ApiUrl.imageUrl}$image")
                  : InteractiveViewer(
                child: CustomImage(
                  placeholderAsset: ImageConstant.demoUserImg,
                  errorAsset: ImageConstant.demoUserImg,
                  radius: 0.dm,
                  imageUrl: image,
                  baseUrl: ApiUrl.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 25,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

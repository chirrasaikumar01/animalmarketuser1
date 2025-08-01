import 'dart:io';

import 'package:animal_market/core/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PickImageUtility {
  PickImageUtility.instance({
    required this.applyEditor,
    required this.context,
    this.cropPageTitle,
    this.toolbarBackgroundColor,
    this.toolbarTextColor,
    this.initialAspectRation,
  });

  final bool applyEditor;

  final ImagePicker _picker = ImagePicker();
  final String? cropPageTitle;
  final Color? toolbarTextColor;
  final Color? toolbarBackgroundColor;
  final BuildContext context;
  final CropAspectRatioPreset? initialAspectRation;

  Future<File?> pickedFile(ImageSource imageSource) async {
    final theme = Theme.of(context);
    final pickedImage = await _picker.pickImage(
      source: imageSource,
    );
    if (pickedImage != null) {
      if (applyEditor) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: cropPageTitle ?? 'Edit Photo',
              cropGridColor: ColorConstant.appCl,
              statusBarColor: ColorConstant.appCl,
              toolbarColor: toolbarBackgroundColor ?? theme.primaryColor,
              cropFrameColor: ColorConstant.appCl,
              toolbarWidgetColor: ColorConstant.white,
              initAspectRatio: initialAspectRation ?? CropAspectRatioPreset.original,
              lockAspectRatio: true,
              backgroundColor: ColorConstant.appCl,
              activeControlsWidgetColor: ColorConstant.appCl,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            IOSUiSettings(
              title: cropPageTitle ?? 'Edit Photo',
              showCancelConfirmationDialog: true,
              aspectRatioLockEnabled: true,
              aspectRatioLockDimensionSwapEnabled: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
          ],
        );
        if (croppedFile != null) {
          return File(croppedFile.path);
        } else {
          File(pickedImage.path);
        }
      } else {
        return File(pickedImage.path);
      }
    }
    return null;
  }
}

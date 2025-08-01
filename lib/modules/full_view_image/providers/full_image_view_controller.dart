import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FullImageViewProvider extends ChangeNotifier {
  final GlobalKey _globalKey = GlobalKey();

  saveLocalImage() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      Log.console(result);
    }
    notifyListeners();
  }

  saveNetworkImage(BuildContext context, String image) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        if (context.mounted) {
          showProgress(context);
        }
        var response = await Dio().get(image, options: Options(responseType: ResponseType.bytes));
        final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 60, name: "Aegis Tax Service");
        if (context.mounted) {
          closeProgress(context);
          if (result != null) {
            successToast(context, 'Gallery updated');
          } else {
            errorToast(context, 'Error updating gallery');
          }
        }
      } catch (e) {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, 'Error downloading image: $e');
        }
      }
    } else {
      if (context.mounted) {
        closeProgress(context);
        errorToast(context, 'Permission denied');
      }
    }
    notifyListeners();
  }

  Future<void> downloadImage(BuildContext context, String image) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final directory = await getExternalStorageDirectory();
      Log.console(directory);
      const path = '/storage/emulated/0/Download/Aegis_Tax_Service_images';
      final dir = Directory(path);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final filePath = '$path/${DateTime.now().millisecondsSinceEpoch}.jpg';
      try {
        await Dio().download(image, filePath);
        if (context.mounted) {
          successToast(context, 'Image saved to $filePath');
        }
        final result = await Process.run('am', ['broadcast', '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE', '-d', 'file://$filePath']);
        if (context.mounted) {
          if (result.exitCode == 0) {
            successToast(context, 'Gallery updated');
          } else {
            errorToast(context, 'Error updating gallery');
          }
        }
      } catch (e) {
        if (context.mounted) {
          errorToast(context, 'Error downloading image: $e');
        }
      }
    } else {
      if (context.mounted) {
        errorToast(context, 'Permission denied');
      }
    }
  }
}

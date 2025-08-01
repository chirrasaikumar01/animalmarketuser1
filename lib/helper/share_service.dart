import 'dart:io';

import 'package:animal_market/core/export_file.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareProduct({
    required String title,
    required String imageUrl,
    required String link,
  }) async {
    try {
      final text = '$title\n\nCheck it out: $link';
      if (imageUrl.isNotEmpty) {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/shared_image.jpg');
          await file.writeAsBytes(response.bodyBytes);
          await Share.shareXFiles(
            [XFile(file.path)],
            text: text,
          );
          return;
        } else {
          Log.console("⚠️ Image download failed, falling back to text-only share.");
        }
      } else {
        Log.console("ℹ️ No image URL provided, sharing text only.");
      }

      await Share.share(text);
    } catch (e) {
      Log.console('❌ Error sharing product: $e');
      await Share.share('$title\n\n$link');
    }
  }
}

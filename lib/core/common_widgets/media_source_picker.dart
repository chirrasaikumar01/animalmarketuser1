import 'package:animal_market/core/common_widgets/column_spacer.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:image_picker/image_picker.dart';


class MediaSourcePicker extends StatelessWidget {
  const MediaSourcePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.dm),
      child: ColumnSpacer(
        spacerWidget: SizedBox(
          height: 12.h,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  ImageConstant.arrowBackIc,
                  height: 24.h,
                  width: 24.w,
                ),
              )
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop(ImageSource.gallery);
            },
            child: Row(
              children: [
                Container(
                  width: 50.h,
                  height: 50.h,
                  padding: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color: ColorConstant.darkAppCl,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.photo_rounded,
                      color: ColorConstant.appCl,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TText(keyName:
                  "Upload from Gallery",
                  style: TextStyle(
                    color: ColorConstant.appCl,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 0.10,
                    fontFamily: FontsStyle.medium,
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop(ImageSource.camera);
            },
            child: Row(
              children: [
                Container(
                  width: 50.h,
                  height: 50.h,
                  padding: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color: ColorConstant.darkAppCl,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_rounded,
                      color: ColorConstant.appCl,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TText(keyName:
                  "Take a picture",
                  style: TextStyle(
                    color: ColorConstant.appCl,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 0.10,
                    fontFamily: FontsStyle.medium,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10.h)
        ],
      ),
    );
  }
}

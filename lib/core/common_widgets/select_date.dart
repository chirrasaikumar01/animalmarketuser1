
import 'package:animal_market/core/export_file.dart';
import 'package:intl/intl.dart';


Future<void> selectDate({
  required BuildContext context,
  required TextEditingController dateController,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String dateFormat = 'E dd-MM-yyyy',
  Function(DateTime)? onDatePicked,
}) async {
  final DateTime now = DateTime.now();
  final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate ?? now,
        firstDate: firstDate ?? now,
        lastDate: lastDate ?? DateTime(3000),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: ColorConstant.white,
                onPrimary: ColorConstant.appCl,
                surface:  ColorConstant.appCl,
                onSurface: ColorConstant.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  backgroundColor: ColorConstant.textDarkCl,
                ),
              ),
            ),
            child: child!,
          );
        },
      ) ??
      initialDate;

  if (picked != null) {
    DateFormat formatter = DateFormat(dateFormat);
    dateController.text = formatter.format(picked);
    if (onDatePicked != null) {
      onDatePicked(picked);
    }
  }
}

import 'package:animal_market/core/export_file.dart';
import 'package:intl/intl.dart';

Future<void> selectTime({
  required BuildContext context,
  required TextEditingController timeController,
  TimeOfDay? initialTime,
  String timeFormat = 'hh:mm a',
  Function(TimeOfDay)? onTimePicked,
}) async {
  final TimeOfDay now = TimeOfDay.now();
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initialTime ?? now,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: ColorConstant.white,
            onPrimary: ColorConstant.appCl,
            surface: ColorConstant.appCl,
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
  );

  if (picked != null) {
    final DateTime now = DateTime.now();
    final DateTime formattedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
    timeController.text = DateFormat(timeFormat).format(formattedTime);

    if (onTimePicked != null) {
      onTimePicked(picked);
    }
  }
}

import 'package:animal_market/core/export_file.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final String time;
  final String? selectedTime;
  final Function() onTap;
  final Color? titleColor;
  final Color? borderColor;
  final Color? hintColor;
  final Color? colorBlack;

  const CustomDatePicker({
    super.key,
    required this.selectedDate,
    this.selectedTime,
    required this.onTap,
    this.titleColor,
    this.borderColor,
    this.hintColor,
    this.colorBlack,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = selectedDate == null ? "Select Date" : DateFormat('yyyy-MM-dd').format(selectedDate!);

    String formattedTime = selectedTime == null ? "Select Time" : selectedTime!;

    String displayText = '';
    if (selectedDate != null && selectedTime != null) {
      displayText = "$formattedDate $formattedTime";
    } else if (selectedDate != null) {
      displayText = formattedDate;
    } else if (selectedTime != null) {
      displayText = formattedTime;
    } else {
      displayText = "Select Date and Time";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: ColorConstant.borderCl),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  time == ""
                      ? TText(keyName:
                          " Select Date and Time ",
                          style: TextStyle(
                            fontSize: 12,
                            color: displayText == "Select Date and Time" ? ColorConstant.grayCl : colorBlack,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : TText(keyName:
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: displayText == "Select Date and Time" ? ColorConstant.grayCl : colorBlack,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                  const Icon(
                    Icons.calendar_month,
                    size: 18,
                    color: ColorConstant.appCl,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

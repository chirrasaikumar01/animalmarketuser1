import 'dart:convert';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/doctor/models/time_slot_list_model.dart';
import 'package:animal_market/services/api_service.dart';

class TimeSlotProvider extends ChangeNotifier {
  final Map<String, bool> loadingDays = {};
  final List<Map<String, String>> dayList = [
    {"name": "Monday", "type": "mon"},
    {"name": "Tuesday", "type": "tue"},
    {"name": "Wednesday", "type": "wed"},
    {"name": "Thursday", "type": "thu"},
    {"name": "Friday", "type": "fri"},
    {"name": "Saturday", "type": "sat"},
    {"name": "Sunday", "type": "sun"},
  ];

  final Map<String, List<TimeSlotsListModel>> timeSlots = {"sun": [], "mon": [], "tue": [], "wed": [], "thu": [], "fri": [], "sat": []};
  final Map<String, List<TimeSlotsListModel>> selectedTimeSlots = {"sun": [], "mon": [], "tue": [], "wed": [], "thu": [], "fri": [], "sat": []};
  final List<String> selectedDays = [];

  /// Check if a specific day is loading
  bool isDayLoading(String day) {
    return loadingDays[day] ?? false;
  }

  /// Update selected days and fetch time slots if needed
  void updateSelected(BuildContext context, String type) {
    if (selectedDays.contains(type)) {
      selectedDays.remove(type);
      selectedTimeSlots[type] = [];
    } else {
      selectedDays.add(type);
      timeSlotsList(context, type);
    }
    notifyListeners();
  }

  /// Update selected time slots for a specific day
  void updateTimeSlots(String day, TimeSlotsListModel timeSlot) {
    if (selectedTimeSlots[day]!.contains(timeSlot)) {
      selectedTimeSlots[day]!.remove(timeSlot);
    } else {
      selectedTimeSlots[day]!.add(timeSlot);
    }
    notifyListeners();
  }

  /// Fetch available time slots from the API for a specific day
  Future<void> timeSlotsList(BuildContext context, String day) async {
    if (timeSlots[day]!.isNotEmpty) return;
    try {
      loadingDays[day] = true;
      notifyListeners();

      var result = await ApiService.timeSlotsList("", day);
      var json = jsonDecode(result.body);

      if (json["status"] == true) {
        loadingDays[day] = false;
        List<String> apiDays = List<String>.from(json["days"]);
        for (var apiDay in apiDays) {
          if (!selectedDays.contains(apiDay)) {
            selectedDays.add(apiDay);
            if (context.mounted) {
              timeSlotsList(context, apiDay);
            }
          }
        }

        timeSlots[day] = (json["data"] as List).map((item) => TimeSlotsListModel.fromJson(item)).toList();
        // Store selected time slots separately
        selectedTimeSlots[day] = timeSlots[day]!.where((slot) => slot.isSelected == 1).toList();
      } else {
        loadingDays[day] = false;
        if (context.mounted) errorToast(context, json["message"]);
      }
    } catch (e) {
      loadingDays[day] = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  /// Add selected time slots for a doctor
  Future<void> addDoctorTimeSlots(BuildContext context, String day) async {
    try {
      if (selectedTimeSlots[day]!.isEmpty) {
        errorToast(context, "Please select time slots for $day");
        return;
      }
      showProgress(context);

      var result = await ApiService.addDoctorTimeSlots(day, selectedTimeSlots[day]!);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        closeProgress(context);
        if (json["status"] == true) {
          successToast(context, json["message"]);
        } else {
          errorToast(context, json["message"]);
        }
      }
    } catch (e) {
      if (context.mounted) closeProgress(context);
      Log.console(e.toString());
    }
  }
}

import 'dart:convert';

import 'package:animal_market/core/common_widgets/select_date.dart';
import 'package:animal_market/core/common_widgets/select_time.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/event/models/event_list_model.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:intl/intl.dart';

class EventProvider extends ChangeNotifier {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController eventDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  bool isRemind = false;
  bool isEvent = false;
  bool isLoading = true;
  var eventList = <EventListModel>[];
  var allEventList = <EventListModel>[];

  void isRemindChange(bool v) {
    isRemind = v;
    notifyListeners();
  }

  void isEventUpdate(bool v) {
    isEvent = v;
    notifyListeners();
  }

  Future<void> dateSelect(BuildContext context) {
    return selectDate(
      context: context,
      dateController: eventDate,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
      onDatePicked: (pickedDate) {
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        eventDate.text = formatter.format(pickedDate);
        notifyListeners();
      },
    );
  }

  Future<void> timeSelect(BuildContext context) async {
    return selectTime(
      context: context,
      timeController: startTime,
      initialTime: TimeOfDay.now(),
      onTimePicked: (pickedTime) {
        DateTime now = DateTime.now();
        DateTime formattedTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
        DateFormat formatter = DateFormat('hh:mm a');
        startTime.text = formatter.format(formattedTime);
        notifyListeners();
      },
    );
  }

  void reset() {
    title.text = "";
    description.text = "";
    eventDate.text = "";
    startTime.text = "";
    isRemind = false;
    isEvent = false;
  }

  Future<void> allEventGet(BuildContext context) async {
    try {
      var result = await ApiService.eventList("");
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        allEventList = List<EventListModel>.from(json['data'].map((i) => EventListModel.fromJson(i))).toList(growable: true);
      } else {}
    } catch (e) {
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> eventListGet(BuildContext context) async {
    try {
      isLoading = true;
      var result = await ApiService.eventList(eventDate.text);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        eventList = List<EventListModel>.from(json['data'].map((i) => EventListModel.fromJson(i))).toList(growable: true);
      } else {
        isLoading = false;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteEvent(BuildContext context, String eventId) async {
    try {
      showProgress(context);
      var result = await ApiService.deleteEvent(eventId);
      var json = jsonDecode(result.body);
      if (context.mounted) {
        if (json["status"] == true) {
          closeProgress(context);
          Navigator.pop(context);
          eventListGet(context);
          successToast(context, json["message"].toString());
        } else {
          closeProgress(context);
          if (context.mounted) {
            errorToast(context, json["message"].toString());
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> addEvent(BuildContext context) async {
    Log.console(eventDate.text);
    try {
      showProgress(context);
      var result = await ApiService.addEvent(
        title.text,
        description.text,
        eventDate.text,
        startTime.text,
        "",
        isRemind == true ? "1" : "0",
      );
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          eventListGet(context);
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
    }
    notifyListeners();
  }

  String formatDate(BuildContext context, DateTime date) {
    try {
      var formattedDate = DateFormat("yyyy-MM-dd").format(date);
      eventDate.text = formattedDate;
      eventListGet(context);
      return formattedDate;
    } catch (e) {
      return "";
    }
  }

  String formatDate1(String date) {
    try {
      var parsedDate = DateFormat("yyyy-MM-dd").parse(date);
      var formattedDate = DateFormat("dd\nMMM").format(parsedDate);
      return formattedDate;
    } catch (e) {
      return "";
    }
  }
}

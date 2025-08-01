import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/doctor/views/doctor_appointment_list_view.dart';
import 'package:animal_market/modules/doctor/views/doctor_view.dart';
import 'package:animal_market/modules/doctor/views/time_slot_view.dart';

class DoctorProfileDashboardProvider extends ChangeNotifier {
  List<String> baseTitles = [
    home,
    myAppointment,
    slots,
  ];

  List<Widget> get baseWidgets => [
        DoctorView(),
        DoctorAppointmentListView(isBottom: true),
        TimeSlotView(),
      ];

  int baseActiveBottomIndex = 0;

  void onChangeBaseBottomIndex(int index) {
    baseActiveBottomIndex = index;
    notifyListeners();
  }
}

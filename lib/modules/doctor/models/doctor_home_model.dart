import 'package:animal_market/modules/doctor/models/banner_model.dart';
import 'package:animal_market/modules/doctor/models/doctor_model.dart';
import 'package:animal_market/modules/doctor/models/my_appointment_model.dart';

class DoctorHomeModel {
  List<BannerModel>? banners;
  int? isDoctor;
  int? totalAppointment;
  int? todayAppointment;
  List<MyAppointment>? myAppointments;
  DoctorModel? doctor;

  DoctorHomeModel({
    this.banners,
    this.isDoctor,
    this.totalAppointment,
    this.todayAppointment,
    this.myAppointments,
    this.doctor,
  });

  factory DoctorHomeModel.fromJson(Map<String, dynamic> json) => DoctorHomeModel(
        banners: json["banners"] == null ? [] : List<BannerModel>.from(json["banners"]!.map((x) => BannerModel.fromJson(x))),
        isDoctor: json["is_doctor"],
        totalAppointment: json["total_appointment"],
        todayAppointment: json["today_appointment"],
        myAppointments: json["my_appointments"] == null ? [] : List<MyAppointment>.from(json["my_appointments"]!.map((x) => MyAppointment.fromJson(x))),
        doctor: json["doctor"] == null ? null : DoctorModel.fromJson(json["doctor"]),
      );

  Map<String, dynamic> toJson() => {
        "banners": banners == null ? [] : List<dynamic>.from(banners!.map((x) => x.toJson())),
        "is_doctor": isDoctor,
        "total_appointment": totalAppointment,
        "today_appointment": todayAppointment,
        "my_appointments": myAppointments == null ? [] : List<dynamic>.from(myAppointments!.map((x) => x.toJson())),
        "doctor": doctor?.toJson(),
      };
}

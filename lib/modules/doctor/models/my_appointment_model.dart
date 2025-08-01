import 'package:animal_market/modules/doctor/models/doctor_model.dart';
import 'package:animal_market/modules/doctor/models/patient_model.dart';

class MyAppointment {
  int? id;
  String? appointmentId;
  String? doctorId;
  String? patientId;
  String? date;
  String? timeSlotId;
  String? startTime;
  String? endTime;
  String? time;
  String? mobileNo;
  String? status;
  String? paymentMode;
  dynamic fees;
  DoctorModel? doctor;
  Patient? patient;

  MyAppointment({
    this.id,
    this.appointmentId,
    this.doctorId,
    this.patientId,
    this.date,
    this.timeSlotId,
    this.startTime,
    this.endTime,
    this.time,
    this.mobileNo,
    this.status,
    this.paymentMode,
    this.fees,
    this.doctor,
    this.patient,
  });

  factory MyAppointment.fromJson(Map<String, dynamic> json) => MyAppointment(
    id: json["id"],
    appointmentId: json["appointment_id"],
    doctorId: json["doctor_id"],
    patientId: json["patient_id"],
    date: json["date"],
    timeSlotId: json["time_slot_id"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    time: json["time"],
    mobileNo: json["mobile_no"],
    status: json["status"],
    paymentMode: json["payment_mode"],
    fees: json["fees"],
    doctor: json["doctor"] == null ? null : DoctorModel.fromJson(json["doctor"]),
    patient: json["patient"] == null ? null : Patient.fromJson(json["patient"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "appointment_id": appointmentId,
    "doctor_id": doctorId,
    "patient_id": patientId,
    "date": date,
    "time_slot_id": timeSlotId,
    "start_time": startTime,
    "end_time": endTime,
    "time": time,
    "mobile_no": mobileNo,
    "status": status,
    "payment_mode": paymentMode,
    "fees": fees,
    "doctor": doctor?.toJson(),
    "patient": patient?.toJson(),
  };
}
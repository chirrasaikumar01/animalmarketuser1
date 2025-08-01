// To parse this JSON data, do
//
//     final doctorListModel = doctorListModelFromJson(jsonString);

import 'dart:convert';

DoctorListModel doctorListModelFromJson(String str) => DoctorListModel.fromJson(json.decode(str));

String doctorListModelToJson(DoctorListModel data) => json.encode(data.toJson());

class DoctorListModel {
  int? id;
  String? memberId;
  String? name;
  String? clinicName;
  String? experience;
  String? aboutDoctor;
  String? state;
  String? city;
  String? pincode;
  String? latitude;
  String? longitude;
  String? fees;
  String? address;
  String? holiday;
  String? mobile;
  String? whatsappNo;
  String? profile;

  DoctorListModel({
    this.id,
    this.memberId,
    this.name,
    this.clinicName,
    this.experience,
    this.aboutDoctor,
    this.state,
    this.city,
    this.pincode,
    this.latitude,
    this.longitude,
    this.fees,
    this.address,
    this.holiday,
    this.mobile,
    this.whatsappNo,
    this.profile,
  });

  factory DoctorListModel.fromJson(Map<String, dynamic> json) => DoctorListModel(
    id: json["id"],
    memberId: json["member_id"],
    name: json["name"],
    clinicName: json["clinic_name"],
    experience: json["experience"],
    aboutDoctor: json["about_doctor"],
    state: json["state"],
    city: json["city"],
    pincode: json["pincode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    fees: json["fees"],
    address: json["address"],
    holiday: json["holiday"],
    mobile: json["mobile"],
    whatsappNo: json["whatsapp_no"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "member_id": memberId,
    "name": name,
    "clinic_name": clinicName,
    "experience": experience,
    "about_doctor": aboutDoctor,
    "state": state,
    "city": city,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,
    "fees": fees,
    "address": address,
    "holiday": holiday,
    "mobile": mobile,
    "whatsapp_no": whatsappNo,
    "profile": profile,
  };
}

class DoctorModel {
  int? id;
  dynamic frontUserId;
  String? profileImage;
  String? memberId;
  String? name;
  String? clinicName;
  String? experience;
  String? aboutDoctor;
  dynamic state;
  dynamic city;
  String? address;
  String? pincode;
  String? clinicOpenTime;
  String? clinicCloseTime;
  String? holiday;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? title;
  String? fees;

  DoctorModel({
    this.id,
    this.frontUserId,
    this.profileImage,
    this.memberId,
    this.name,
    this.clinicName,
    this.experience,
    this.aboutDoctor,
    this.state,
    this.city,
    this.address,
    this.pincode,
    this.clinicOpenTime,
    this.clinicCloseTime,
    this.holiday,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.title,
    this.fees,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
    id: json["id"],
    frontUserId: json["front_user_id"],
    profileImage: json["profile_image"],
    memberId: json["member_id"],
    name: json["name"],
    clinicName: json["clinic_name"],
    experience: json["experience"],
    aboutDoctor: json["about_doctor"],
    state: json["state"],
    city: json["city"],
    address: json["address"],
    pincode: json["pincode"],
    clinicOpenTime: json["clinic_open_time"],
    clinicCloseTime: json["clinic_close_time"],
    holiday: json["holiday"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    title: json["title"],
    fees: json["fees"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "front_user_id": frontUserId,
    "profile_image": profileImage,
    "member_id": memberId,
    "name": name,
    "clinic_name": clinicName,
    "experience": experience,
    "about_doctor": aboutDoctor,
    "state": state,
    "city": city,
    "address": address,
    "pincode": pincode,
    "clinic_open_time": clinicOpenTime,
    "clinic_close_time": clinicCloseTime,
    "holiday": holiday,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "title": title,
    "fees": fees,
  };
}
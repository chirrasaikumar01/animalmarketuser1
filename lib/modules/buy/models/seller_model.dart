class Seller {
  int? id;
  String? memberId;
  String? name;
  dynamic countryCode;
  String? mobile;
  String? whatsappNo;
  String? email;
  String? address;
  dynamic state;
  dynamic city;
  String? pincode;
  String? latitude;
  String? longitude;
  String? languageCode;
  String? gender;
  DateTime? dob;
  String? profile;
  int? isSeller;
  int? isDoctor;
  int? isCropVarified;
  int? isCattleVarified;
  int? status;
  int? deactivateReasonId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic totalViews;
  dynamic totalCalls;

  Seller({
    this.id,
    this.memberId,
    this.name,
    this.countryCode,
    this.mobile,
    this.whatsappNo,
    this.email,
    this.address,
    this.state,
    this.city,
    this.pincode,
    this.latitude,
    this.longitude,
    this.languageCode,
    this.gender,
    this.dob,
    this.profile,
    this.isSeller,
    this.isDoctor,
    this.isCropVarified,
    this.isCattleVarified,
    this.status,
    this.deactivateReasonId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.totalCalls,
    this.totalViews,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    id: json["id"],
    memberId: json["member_id"],
    name: json["name"],
    countryCode: json["country_code"],
    mobile: json["mobile"],
    whatsappNo: json["whatsapp_no"],
    email: json["email"],
    address: json["address"],
    state: json["state"],
    city: json["city"],
    pincode: json["pincode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    languageCode: json["language_code"],
    gender: json["gender"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    profile: json["profile"],
    isSeller: json["is_seller"],
    isDoctor: json["is_doctor"],
    isCropVarified: json["is_crop_varified"],
    isCattleVarified: json["is_cattle_varified"],
    status: json["status"],
    deactivateReasonId: json["deactivate_reason_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    totalViews: json["total_views"],
    totalCalls: json["total_calls"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "member_id": memberId,
    "name": name,
    "country_code": countryCode,
    "mobile": mobile,
    "whatsapp_no": whatsappNo,
    "email": email,
    "address": address,
    "state": state,
    "city": city,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,
    "language_code": languageCode,
    "gender": gender,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "profile": profile,
    "is_seller": isSeller,
    "is_doctor": isDoctor,
    "is_crop_varified": isCropVarified,
    "is_cattle_varified": isCattleVarified,
    "status": status,
    "deactivate_reason_id": deactivateReasonId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "total_views": totalViews,
    "total_calls": totalCalls,
  };
}
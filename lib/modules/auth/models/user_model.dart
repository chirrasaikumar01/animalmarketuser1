class UserModel {
  bool? status;
  String? accessToken;
  String? tokenType;
  User? user;
  String? message;

  UserModel({
    this.status,
    this.accessToken,
    this.tokenType,
    this.user,
    this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"],
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        user: json["data"] == null ? null : User.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "access_token": accessToken,
        "token_type": tokenType,
        "data": user?.toJson(),
        "message": message,
      };
}

class User {
  int? id;
  String? memberId;
  String? name;
  String? countryCode;
  String? mobile;
  String? whatsappNo;
  String? email;
  String? address;
  String? languageCode;
  String? gender;
  String? dob;
  String? profile;
  dynamic isSeller;
  dynamic status;
  dynamic deactivateReasonId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? deletedAt;
  dynamic state;
  dynamic city;
  dynamic pinCode;
  dynamic latitude;
  dynamic longitude;

  User({
    this.id,
    this.memberId,
    this.name,
    this.countryCode,
    this.mobile,
    this.whatsappNo,
    this.email,
    this.address,
    this.languageCode,
    this.gender,
    this.dob,
    this.profile,
    this.isSeller,
    this.status,
    this.deactivateReasonId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.state,
    this.city,
    this.pinCode,
    this.latitude,
    this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        memberId: json["member_id"] ?? "",
        name: json["name"] ?? "",
        countryCode: json["country_code"] ?? "",
        mobile: json["mobile"] ?? "",
        whatsappNo: json["whatsapp_no"] ?? "",
        email: json["email"] ?? "",
        address: json["address"] ?? "",
        languageCode: json["language_code"] ?? "",
        gender: json["gender"] ?? "",
        dob: json["dob"] ?? "",
        profile: json["profile"] ?? "",
        state: json["state"] ?? "",
        city: json["city"] ?? "",
        pinCode: json["pincode"] ?? "",
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "",
        isSeller: json["is_seller"] ?? 0,
        status: json["status"],
        deactivateReasonId: json["deactivate_reason_id"] ?? "",
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
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
        "language_code": languageCode,
        "gender": gender,
        "dob": dob,
        "profile": profile,
        "is_seller": isSeller,
        "status": status,
        "state": state,
        "city": city,
        "pincode": pinCode,
        "latitude": latitude,
        "longitude": longitude,
        "deactivate_reason_id": deactivateReasonId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

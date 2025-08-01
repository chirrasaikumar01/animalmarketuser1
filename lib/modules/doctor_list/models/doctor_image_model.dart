class DoctorImageModel {
  int? id;
  int? doctorId;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  DoctorImageModel({
    this.id,
    this.doctorId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory DoctorImageModel.fromJson(Map<String, dynamic> json) => DoctorImageModel(
    id: json["id"],
    doctorId: json["doctor_id"],
    image: json["image"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "doctor_id": doctorId,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
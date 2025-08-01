class CityListModel {
  int? id;
  String? city;
  int? stateId;

  CityListModel({
    this.id,
    this.city,
    this.stateId,
  });

  factory CityListModel.fromJson(Map<String, dynamic> json) => CityListModel(
    id: json["id"],
    city: json["city"],
    stateId: json["state_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city": city,
    "state_id": stateId,
  };
}

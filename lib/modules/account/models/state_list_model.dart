class StateListModel {
  int? id;
  String? name;
  int? countryId;

  StateListModel({
    this.id,
    this.name,
    this.countryId,
  });

  factory StateListModel.fromJson(Map<String, dynamic> json) => StateListModel(
    id: json["id"],
    name: json["name"],
    countryId: json["country_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_id": countryId,
  };
}

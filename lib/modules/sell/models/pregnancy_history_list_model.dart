class PregnancyHistoryListModel {
  int? id;
  String? title;

  PregnancyHistoryListModel({
    this.id,
    this.title,
  });

  factory PregnancyHistoryListModel.fromJson(Map<String, dynamic> json) => PregnancyHistoryListModel(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

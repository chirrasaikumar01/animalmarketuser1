class EventListModel {
  int? id;
  String? title;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  String? remindMe;
  int? status;

  EventListModel({
    this.id,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.remindMe,
    this.status,
  });

  factory EventListModel.fromJson(Map<String, dynamic> json) => EventListModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    date: json["date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    remindMe: json["remind_me"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date": date,
    "start_time": startTime,
    "end_time": endTime,
    "remind_me": remindMe,
    "status": status,
  };
}

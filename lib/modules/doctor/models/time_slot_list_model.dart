class TimeSlotsListModel {
  int? id;
  String? timeSlots;
  String? startTime;
  String? endTime;
  int? status;
  int? isSelected;

  TimeSlotsListModel({
    this.id,
    this.timeSlots,
    this.startTime,
    this.endTime,
    this.status,
    this.isSelected,
  });

  factory TimeSlotsListModel.fromJson(Map<String, dynamic> json) => TimeSlotsListModel(
        id: json["id"],
        timeSlots: json["time_slots"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        isSelected: json["is_selected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "time_slots": timeSlots,
        "start_time": startTime,
        "end_time": endTime,
        "status": status,
        "is_selected": isSelected,
      };
}

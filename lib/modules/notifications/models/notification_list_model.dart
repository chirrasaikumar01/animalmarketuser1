class NotificationListModel {
  int? id;
  dynamic userId;
  int? refereeId;
  dynamic studentId;
  dynamic type;
  String? title;
  String? message;
  String? image;
  int? isRead;
  String? createdAt;
  String? updatedAt;
  String? url;

  NotificationListModel({
    this.id,
    this.userId,
    this.refereeId,
    this.studentId,
    this.type,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.url,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
        id: json["id"],
        userId: json["user_id"],
        refereeId: json["referee_id"],
        studentId: json["student_id"],
        type: json["type"],
        title: json["title"],
        message: json["message"],
        isRead: json["is_read"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        image: json["image"] ?? "",
        url: json["url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "referee_id": refereeId,
        "student_id": studentId,
        "type": type,
        "title": title,
        "message": message,
        "is_read": isRead,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image": image,
        "url": url,
      };
}

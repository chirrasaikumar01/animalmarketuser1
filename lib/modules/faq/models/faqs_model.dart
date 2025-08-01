class FaqsModel {
  int? id;
  String? title;
  String? answer;

  FaqsModel({
    this.id,
    this.title,
    this.answer,
  });

  factory FaqsModel.fromJson(Map<String, dynamic> json) => FaqsModel(
        id: json["id"],
        title: json["title"],
    answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "answer": answer,
      };
}

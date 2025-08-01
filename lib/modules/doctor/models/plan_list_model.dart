class PlanListModel {
  int? id;
  String? title;
  String? description;
  String? price;
  String? discountPrice;
  String? duration;
  int? noOfDuration;
  int? isBestSelling;
  int? status;
  int? isPurchased;
  dynamic gst;

  PlanListModel({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPrice,
    this.duration,
    this.noOfDuration,
    this.isBestSelling,
    this.status,
    this.isPurchased,
    this.gst,
  });

  factory PlanListModel.fromJson(Map<String, dynamic> json) => PlanListModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    discountPrice: json["discount_price"],
    duration: json["duration"],
    noOfDuration: json["no_of_duration"],
    isBestSelling: json["is_best_selling"],
    status: json["status"],
    isPurchased: json["is_purchased"],
    gst: json["gst"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "discount_price": discountPrice,
    "duration": duration,
    "no_of_duration": noOfDuration,
    "is_best_selling": isBestSelling,
    "status": status,
    "is_purchased": isPurchased,
    "gst": gst,
  };
}

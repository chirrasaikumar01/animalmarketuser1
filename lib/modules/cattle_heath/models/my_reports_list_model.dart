class MyReportsListModel {
  int? id;
  String? uniqueCode;
  String? reportPlanId;
  String? patientId;
  String? fees;
  String? gst;
  String? totalFees;
  String? moreInfo;
  String? paymentStatus;
  dynamic transactionId;
  String? document;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  MyReportsListModel({
    this.id,
    this.uniqueCode,
    this.reportPlanId,
    this.patientId,
    this.fees,
    this.gst,
    this.totalFees,
    this.moreInfo,
    this.paymentStatus,
    this.transactionId,
    this.document,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory MyReportsListModel.fromJson(Map<String, dynamic> json) => MyReportsListModel(
    id: json["id"],
    uniqueCode: json["unique_code"],
    reportPlanId: json["report_plan_id"],
    patientId: json["patient_id"],
    fees: json["fees"],
    gst: json["gst"],
    totalFees: json["total_fees"],
    moreInfo: json["more_info"],
    paymentStatus: json["payment_status"],
    transactionId: json["transaction_id"],
    document: json["document"]??"",
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_code": uniqueCode,
    "report_plan_id": reportPlanId,
    "patient_id": patientId,
    "fees": fees,
    "gst": gst,
    "total_fees": totalFees,
    "more_info": moreInfo,
    "payment_status": paymentStatus,
    "transaction_id": transactionId,
    "document": document,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

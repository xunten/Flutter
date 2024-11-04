// To parse this JSON data, do
//
//     final withdrawalListModel = withdrawalListModelFromJson(jsonString);

import 'dart:convert';

WithdrawalListModel withdrawalListModelFromJson(String str) =>
    WithdrawalListModel.fromJson(json.decode(str));

String withdrawalListModelToJson(WithdrawalListModel data) =>
    json.encode(data.toJson());

class WithdrawalListModel {
  int? status;
  String? message;
  List<Result>? result;

  WithdrawalListModel({
    this.status,
    this.message,
    this.result,
  });

  factory WithdrawalListModel.fromJson(Map<String, dynamic> json) =>
      WithdrawalListModel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(
            json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? id;
  int? userId;
  String? point;
  String? totalAmount;
  String? paymentType;
  String? paymentDetail;
  int? status;
  String? createdAt;
  String? updatedAt;

  Result({
    this.id,
    this.userId,
    this.point,
    this.totalAmount,
    this.paymentType,
    this.paymentDetail,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        point: json["point"],
        totalAmount: json["total_amount"],
        paymentType: json["payment_type"],
        paymentDetail: json["payment_detail"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "point": point,
        "total_amount": totalAmount,
        "payment_type": paymentType,
        "payment_detail": paymentDetail,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

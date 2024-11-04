// To parse this JSON data, do
//
//     final packagesModel = packagesModelFromJson(jsonString);

import 'dart:convert';

PackagesModel packagesModelFromJson(String str) =>
    PackagesModel.fromJson(json.decode(str));

String packagesModelToJson(PackagesModel data) => json.encode(data.toJson());

class PackagesModel {
  int? status;
  String? message;
  List<Result>? result;

  PackagesModel({
    this.status,
    this.message,
    this.result,
  });

  factory PackagesModel.fromJson(Map<String, dynamic> json) => PackagesModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? id;
  String? name;
  int? price;
  String? image;
  String? currencyType;
  String? point;
  String? androidProductPackage;
  String? iosProductPackage;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isDelete;

  Result({
    this.id,
    this.name,
    this.price,
    this.image,
    this.currencyType,
    this.point,
    this.androidProductPackage,
    this.iosProductPackage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isDelete,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        currencyType: json["currency_type"],
        point: json["point"],
        androidProductPackage: json["android_product_package"],
        iosProductPackage: json["ios_product_package"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isDelete: json["is_delete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
        "currency_type": currencyType,
        "point": point,
        "android_product_package": androidProductPackage,
        "ios_product_package": iosProductPackage,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_delete": isDelete,
      };
}

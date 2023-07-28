// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final String code;
  final String name;
  final String productId;
  final int qty;

  ProductModel({
    required this.code,
    required this.name,
    required this.productId,
    required this.qty,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        code: json["code"],
        name: json["name"],
        productId: json["productID"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "productID": productId,
        "qty": qty,
      };
}

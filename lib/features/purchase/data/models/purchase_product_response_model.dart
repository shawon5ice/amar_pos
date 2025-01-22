import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'purchase_product_response_model.g.dart'; // This is the generated file.

@JsonSerializable()
class PurchaseProductResponseModel {
  final bool success;
  final Data data;
  @JsonKey(name: 'count_total')
  final int countTotal;
  @JsonKey(name: 'amount_total')
  final num amountTotal;

  PurchaseProductResponseModel({
    required this.success,
    required this.data,
    required this.countTotal,
    required this.amountTotal,
  });

  factory PurchaseProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseProductResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'data')
  final List<PurchaseProduct> returnProducts; // Fixed type to match the intended model.
  final Meta meta;

  Data({
    required this.returnProducts,
    required this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class PurchaseProduct {
  final int id;
  final String category;
  final String brand;
  final String product;
  final int quantity;
  @JsonKey(name: 'total_price')
  final num totalPrice;

  PurchaseProduct({
    required this.id,
    required this.category,
    required this.brand,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory PurchaseProduct.fromJson(Map<String, dynamic> json) =>
      _$PurchaseProductFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseProductToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: 'last_page')
  final int lastPage;
  final int total;

  Meta({
    required this.lastPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

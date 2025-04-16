import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'return_product_response_model.g.dart'; // This is the generated file.

@JsonSerializable()
class ReturnProductResponseModel {
  final bool success;
  final Data data;
  @JsonKey(name: "count_total", defaultValue:  0)
  final int countTotal;
  @JsonKey(name: "amount_total", defaultValue:  0)
  final num amountTotal;

  ReturnProductResponseModel({
    required this.success,
    required this.data,
    required this.amountTotal,
    required this.countTotal,
  });

  factory ReturnProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ReturnProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnProductResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'data')
  final List<ReturnProduct> returnProducts; // Fixed type to match the intended model.
  final Meta meta;

  Data({
    required this.returnProducts,
    required this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class ReturnProduct {
  final int id;
  final String category;
  @JsonKey(defaultValue: '--')
  final String brand;
  final String product;
  final int quantity;
  @JsonKey(name: 'sold_price')
  final num soldPrice;

  ReturnProduct({
    required this.id,
    required this.category,
    required this.brand,
    required this.product,
    required this.quantity,
    required this.soldPrice,
  });

  factory ReturnProduct.fromJson(Map<String, dynamic> json) =>
      _$ReturnProductFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnProductToJson(this);
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

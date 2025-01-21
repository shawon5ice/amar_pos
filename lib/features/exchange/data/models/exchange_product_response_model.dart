import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'exchange_product_response_model.g.dart'; // This is the generated file.

@JsonSerializable()
class ExchangeProductResponseModel {
  final bool success;
  final Data data;

  ExchangeProductResponseModel({
    required this.success,
    required this.data,
  });

  factory ExchangeProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeProductResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'data')
  final List<ExchangeProduct> exchangeProducts; // Fixed type to match the intended model.
  final Meta meta;

  Data({
    required this.exchangeProducts,
    required this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class ExchangeProduct {
  final int id;
  final String category;
  final String brand;
  final String product;
  final int quantity;
  @JsonKey(name: 'sold_price')
  final num soldPrice;

  ExchangeProduct({
    required this.id,
    required this.category,
    required this.brand,
    required this.product,
    required this.quantity,
    required this.soldPrice,
  });

  factory ExchangeProduct.fromJson(Map<String, dynamic> json) =>
      _$ExchangeProductFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeProductToJson(this);
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

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'sold_product_response_model.g.dart'; // This is the generated file.

@JsonSerializable()
class SoldProductResponseModel {
  final bool success;
  final Data data;

  SoldProductResponseModel({
    required this.success,
    required this.data,
  });

  factory SoldProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SoldProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoldProductResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'data')
  final List<SoldProductModel> soldProducts;
  final Meta meta;

  Data({
    required this.soldProducts,
    required this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class SoldProductModel {
  final int id;
  final String category;
  final String brand;
  final String product;
  final int quantity;
  @JsonKey(name: 'sold_price')
  final num soldPrice;

  SoldProductModel({
    required this.id,
    required this.category,
    required this.brand,
    required this.product,
    required this.quantity,
    required this.soldPrice,
  });

  factory SoldProductModel.fromJson(Map<String, dynamic> json) => _$SoldProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoldProductModelToJson(this);
}


@JsonSerializable()
class Meta {
  final int currentPage;
  final int lastPage;
  final int total;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

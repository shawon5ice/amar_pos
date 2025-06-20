import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'exchange_product_response_model.g.dart'; // This is the generated file.

@JsonSerializable()
class ExchangeProductResponseModel {
  final bool success;
  @DataConverter()
  final ExchangeProductListDataModel data;
  @JsonKey(name: 'amount_total',defaultValue: 0)
  final num amountTotal;
  @JsonKey(name: 'count_total',defaultValue: 0)
  final num countTotal;

  ExchangeProductResponseModel({
    required this.success,
    required this.data,
    required this.countTotal,
    required this.amountTotal,
  });

  factory ExchangeProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeProductResponseModelToJson(this);
}

@JsonSerializable()
class ExchangeProductListDataModel {
  @JsonKey(name: 'data')
  final List<ExchangeProduct> exchangeProducts; // Fixed type to match the intended model.
  final Meta? meta;

  ExchangeProductListDataModel({
    required this.exchangeProducts,
    required this.meta,
  });

  factory ExchangeProductListDataModel.fromJson(Map<String, dynamic> json) => _$ExchangeProductListDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeProductListDataModelToJson(this);
}

@JsonSerializable()
class ExchangeProduct {
  final int id;
  final String category;
  @JsonKey(defaultValue: 'N/A')
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


class DataConverter implements JsonConverter<ExchangeProductListDataModel, dynamic> {
  const DataConverter();

  @override
  ExchangeProductListDataModel fromJson(dynamic json) {
    if (json is List) {
      return ExchangeProductListDataModel(exchangeProducts: [], meta: null);
    } else if (json is Map<String, dynamic>) {
      return ExchangeProductListDataModel.fromJson(json);
    } else {
      throw Exception('Unexpected type for data: ${json.runtimeType}');
    }
  }

  @override
  dynamic toJson(ExchangeProductListDataModel object) => object.toJson();
}
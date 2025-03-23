import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'sold_product_response_model.g.dart'; // This is the generated file.

@JsonSerializable()
class SoldProductResponseModel {
  final bool success;
  @DataConverter()
  final Data data;
  @JsonKey(name: 'count_total')
  final int countTotal;
  @JsonKey(name: 'amount_total')
  final num amountTotal;

  SoldProductResponseModel({
    required this.success,
    required this.data,
    required this.countTotal,
    required this.amountTotal,
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


  Data.empty()
      : soldProducts = [],
        meta = Meta.empty();

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class SoldProductModel {
  final int id;
  final String? category;
  final String? brand;
  final String product;
  final int quantity;
  @JsonKey(name: 'sold_price')
  final num soldPrice;

  SoldProductModel({
    required this.id,
    this.category,
    this.brand,
    required this.product,
    required this.quantity,
    required this.soldPrice,
  });

  factory SoldProductModel.fromJson(Map<String, dynamic> json) => _$SoldProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoldProductModelToJson(this);
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

  Meta.empty()
      : lastPage = 0,
        total = 0;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}


class DataConverter implements JsonConverter<Data, dynamic> {
  const DataConverter();

  @override
  Data fromJson(dynamic json) {
    if (json is List) {
      return Data.empty();
    } else if (json is Map<String, dynamic>) {
      return Data.fromJson(json);
    } else {
      throw Exception('Unexpected type for data: ${json.runtimeType}');
    }
  }

  @override
  dynamic toJson(Data object) => object.toJson();
}
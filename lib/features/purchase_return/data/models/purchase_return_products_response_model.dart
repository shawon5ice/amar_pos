import 'package:json_annotation/json_annotation.dart';

part 'purchase_return_products_response_model.g.dart'; // This is the generated file.


@JsonSerializable(explicitToJson: true)
class PurchaseReturnProductResponseModel {
  final bool success;
  final Data? data;
  @JsonKey(name: 'count_total')
  final int countTotal;
  @JsonKey(name: 'amount_total')
  final int amountTotal;

  PurchaseReturnProductResponseModel({
    required this.success,
    this.data,
    required this.countTotal,
    required this.amountTotal,
  });

  factory PurchaseReturnProductResponseModel.fromJson(Map<String, dynamic> json) => _$PurchaseReturnProductResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseReturnProductResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Data {
  @JsonKey(name: 'data')
  final List<PurchaseReturnProduct>? returnProducts;
  final Meta? meta;

  Data({
    this.returnProducts,
    this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class PurchaseReturnProduct {
  final int id;
  final String? category;
  final String? brand;
  final String product;
  final int quantity;
  @JsonKey(name: 'total_price')
  final int totalPrice;

  PurchaseReturnProduct({
    required this.id,
    required this.category,
    required this.brand,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory PurchaseReturnProduct.fromJson(Map<String, dynamic> json) => _$PurchaseReturnProductFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseReturnProductToJson(this);
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

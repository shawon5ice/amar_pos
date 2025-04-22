// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_product_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeProductResponseModel _$ExchangeProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    ExchangeProductResponseModel(
      success: json['success'] as bool,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
      countTotal: json['count_total'] as num? ?? 0,
      amountTotal: json['amount_total'] as num? ?? 0,
    );

Map<String, dynamic> _$ExchangeProductResponseModelToJson(
        ExchangeProductResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'amount_total': instance.amountTotal,
      'count_total': instance.countTotal,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      exchangeProducts: (json['data'] as List<dynamic>)
          .map((e) => ExchangeProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'data': instance.exchangeProducts,
      'meta': instance.meta,
    };

ExchangeProduct _$ExchangeProductFromJson(Map<String, dynamic> json) =>
    ExchangeProduct(
      id: (json['id'] as num).toInt(),
      category: json['category'] as String,
      brand: json['brand'] as String? ?? 'N/A',
      product: json['product'] as String,
      quantity: (json['quantity'] as num).toInt(),
      soldPrice: json['sold_price'] as num,
    );

Map<String, dynamic> _$ExchangeProductToJson(ExchangeProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'brand': instance.brand,
      'product': instance.product,
      'quantity': instance.quantity,
      'sold_price': instance.soldPrice,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'last_page': instance.lastPage,
      'total': instance.total,
    };

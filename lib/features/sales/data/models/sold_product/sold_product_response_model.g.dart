// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_product_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoldProductResponseModel _$SoldProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    SoldProductResponseModel(
      success: json['success'] as bool,
      data: const DataConverter().fromJson(json['data']),
      countTotal: (json['count_total'] as num).toInt(),
      amountTotal: json['amount_total'] as num,
    );

Map<String, dynamic> _$SoldProductResponseModelToJson(
        SoldProductResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
      'count_total': instance.countTotal,
      'amount_total': instance.amountTotal,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      soldProducts: (json['data'] as List<dynamic>)
          .map((e) => SoldProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'data': instance.soldProducts,
      'meta': instance.meta,
    };

SoldProductModel _$SoldProductModelFromJson(Map<String, dynamic> json) =>
    SoldProductModel(
      id: (json['id'] as num).toInt(),
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      product: json['product'] as String,
      quantity: (json['quantity'] as num).toInt(),
      soldPrice: json['sold_price'] as num,
    );

Map<String, dynamic> _$SoldProductModelToJson(SoldProductModel instance) =>
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

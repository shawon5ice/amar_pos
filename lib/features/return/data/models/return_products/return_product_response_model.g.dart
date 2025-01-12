// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_product_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnProductResponseModel _$ReturnProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    ReturnProductResponseModel(
      success: json['success'] as bool,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReturnProductResponseModelToJson(
        ReturnProductResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      returnProducts: (json['data'] as List<dynamic>)
          .map((e) => ReturnProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'data': instance.returnProducts,
      'meta': instance.meta,
    };

ReturnProduct _$ReturnProductFromJson(Map<String, dynamic> json) =>
    ReturnProduct(
      id: (json['id'] as num).toInt(),
      category: json['category'] as String,
      brand: json['brand'] as String,
      product: json['product'] as String,
      quantity: (json['quantity'] as num).toInt(),
      soldPrice: json['sold_price'] as num,
    );

Map<String, dynamic> _$ReturnProductToJson(ReturnProduct instance) =>
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

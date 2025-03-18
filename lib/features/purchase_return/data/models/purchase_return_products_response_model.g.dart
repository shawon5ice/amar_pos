// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_return_products_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseReturnProductResponseModel _$PurchaseReturnProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    PurchaseReturnProductResponseModel(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      countTotal: (json['count_total'] as num).toInt(),
      amountTotal: (json['amount_total'] as num).toInt(),
    );

Map<String, dynamic> _$PurchaseReturnProductResponseModelToJson(
        PurchaseReturnProductResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data?.toJson(),
      'count_total': instance.countTotal,
      'amount_total': instance.amountTotal,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      returnProducts: (json['data'] as List<dynamic>?)
          ?.map(
              (e) => PurchaseReturnProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'data': instance.returnProducts?.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
    };

PurchaseReturnProduct _$PurchaseReturnProductFromJson(
        Map<String, dynamic> json) =>
    PurchaseReturnProduct(
      id: (json['id'] as num).toInt(),
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      product: json['product'] as String,
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: (json['total_price'] as num).toInt(),
    );

Map<String, dynamic> _$PurchaseReturnProductToJson(
        PurchaseReturnProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'brand': instance.brand,
      'product': instance.product,
      'quantity': instance.quantity,
      'total_price': instance.totalPrice,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'last_page': instance.lastPage,
      'total': instance.total,
    };

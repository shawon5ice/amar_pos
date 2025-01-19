// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_methods_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodsResponseModel _$PaymentMethodsResponseModelFromJson(
        Map<String, dynamic> json) =>
    PaymentMethodsResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaymentMethodsResponseModelToJson(
        PaymentMethodsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      paymentOptions: (json['details'] as List<dynamic>)
          .map((e) => PaymentOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.paymentOptions,
    };

PaymentOption _$PaymentOptionFromJson(Map<String, dynamic> json) =>
    PaymentOption(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$PaymentOptionToJson(PaymentOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

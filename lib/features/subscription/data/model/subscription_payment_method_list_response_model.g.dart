// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_payment_method_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPaymentMethodListResponseModel
    _$SubscriptionPaymentMethodListResponseModelFromJson(
            Map<String, dynamic> json) =>
        SubscriptionPaymentMethodListResponseModel(
          success: json['success'] as bool?,
          data: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  SubscriptionPaymentMethod.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$SubscriptionPaymentMethodListResponseModelToJson(
        SubscriptionPaymentMethodListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

SubscriptionPaymentMethod _$SubscriptionPaymentMethodFromJson(
        Map<String, dynamic> json) =>
    SubscriptionPaymentMethod(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      shortCode: json['short_code'] as String?,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$SubscriptionPaymentMethodToJson(
        SubscriptionPaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'short_code': instance.shortCode,
      'description': instance.description,
      'logo': instance.logo,
    };

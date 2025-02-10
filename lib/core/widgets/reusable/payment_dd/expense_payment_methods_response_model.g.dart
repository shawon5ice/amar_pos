// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_payment_methods_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartOfAccountPaymentMethodsResponseModel
    _$ChartOfAccountPaymentMethodsResponseModelFromJson(
            Map<String, dynamic> json) =>
        ChartOfAccountPaymentMethodsResponseModel(
          success: json['success'] as bool,
          paymentMethods: (json['data'] as List<dynamic>)
              .map((e) => ChartOfAccountPaymentMethod.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$ChartOfAccountPaymentMethodsResponseModelToJson(
        ChartOfAccountPaymentMethodsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.paymentMethods,
    };

ChartOfAccountPaymentMethod _$ChartOfAccountPaymentMethodFromJson(
        Map<String, dynamic> json) =>
    ChartOfAccountPaymentMethod(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ChartOfAccountPaymentMethodToJson(
        ChartOfAccountPaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

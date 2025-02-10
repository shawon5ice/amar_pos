// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_payment_methods_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensePaymentMethodsResponseModel _$ExpensePaymentMethodsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ExpensePaymentMethodsResponseModel(
      success: json['success'] as bool,
      paymentMethods: (json['data'] as List<dynamic>)
          .map((e) => ExpensePaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExpensePaymentMethodsResponseModelToJson(
        ExpensePaymentMethodsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.paymentMethods,
    };

ExpensePaymentMethod _$ExpensePaymentMethodFromJson(
        Map<String, dynamic> json) =>
    ExpensePaymentMethod(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ExpensePaymentMethodToJson(
        ExpensePaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

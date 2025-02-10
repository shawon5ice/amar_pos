import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense_payment_methods_response_model.g.dart';

@JsonSerializable()
class ExpensePaymentMethodsResponseModel {
  final bool success;
  @JsonKey(name: 'data')
  final List<ExpensePaymentMethod> paymentMethods;

  ExpensePaymentMethodsResponseModel({required this.success, required this.paymentMethods});

  factory ExpensePaymentMethodsResponseModel.fromJson(Map<String, dynamic> json) => _$ExpensePaymentMethodsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExpensePaymentMethodsResponseModelToJson(this);
}


@JsonSerializable()
class ExpensePaymentMethod {
  final int id;
  final String name;

  ExpensePaymentMethod({required this.id, required this.name});

  factory ExpensePaymentMethod.fromJson(Map<String, dynamic> json) => _$ExpensePaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$ExpensePaymentMethodToJson(this);
}

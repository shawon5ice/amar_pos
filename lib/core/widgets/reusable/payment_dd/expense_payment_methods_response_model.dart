import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense_payment_methods_response_model.g.dart';

@JsonSerializable()
class ChartOfAccountPaymentMethodsResponseModel {
  final bool success;
  @JsonKey(name: 'data')
  final List<ChartOfAccountPaymentMethod> paymentMethods;

  ChartOfAccountPaymentMethodsResponseModel({required this.success, required this.paymentMethods});

  factory ChartOfAccountPaymentMethodsResponseModel.fromJson(Map<String, dynamic> json) => _$ChartOfAccountPaymentMethodsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChartOfAccountPaymentMethodsResponseModelToJson(this);
}


@JsonSerializable()
class ChartOfAccountPaymentMethod {
  final int id;
  final String name;
  final int? root;

  ChartOfAccountPaymentMethod({required this.id, required this.name, this.root});

  factory ChartOfAccountPaymentMethod.fromJson(Map<String, dynamic> json) => _$ChartOfAccountPaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$ChartOfAccountPaymentMethodToJson(this);
}

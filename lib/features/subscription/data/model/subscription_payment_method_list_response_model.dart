import 'package:json_annotation/json_annotation.dart';

part 'subscription_payment_method_list_response_model.g.dart';

@JsonSerializable()
class SubscriptionPaymentMethodListResponseModel {
  final bool? success;
  final List<SubscriptionPaymentMethod>? data;

  SubscriptionPaymentMethodListResponseModel({
    this.success,
    this.data,
  });

  factory SubscriptionPaymentMethodListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPaymentMethodListResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionPaymentMethodListResponseModelToJson(this);
}

@JsonSerializable()
class SubscriptionPaymentMethod {
  final int? id;
  final String? name;

  @JsonKey(name: 'short_code')
  final String? shortCode;

  final String? description;
  final String? logo;

  SubscriptionPaymentMethod({
    this.id,
    this.name,
    this.shortCode,
    this.description,
    this.logo,
  });

  factory SubscriptionPaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPaymentMethodFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionPaymentMethodToJson(this);
}

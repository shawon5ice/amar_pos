import 'package:json_annotation/json_annotation.dart';


part 'payment_methods_response_model.g.dart';

@JsonSerializable()
class PaymentMethodsResponseModel {
  final bool success;
  @JsonKey(name: 'data')
  final List<PaymentMethod> data;

  PaymentMethodsResponseModel({required this.success, required this.data});

  factory PaymentMethodsResponseModel.fromJson(Map<String, dynamic> json) => _$PaymentMethodsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodsResponseModelToJson(this);

}

@JsonSerializable()
class PaymentMethod {
  final int id;
  final String name;
  @JsonKey(name: 'details')
  final List<PaymentOption> paymentOptions;

  PaymentMethod({required this.id, required this.name, required this.paymentOptions});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

}

@JsonSerializable()
class PaymentOption {
  final int id;
  final String name;

  PaymentOption({required this.id, required this.name});

  factory PaymentOption.fromJson(Map<String, dynamic> json) => _$PaymentOptionFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentOptionToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionResponse {
  final bool success;
  final SubscriptionData data;

  SubscriptionResponse({
    required this.success,
    required this.data,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionResponseToJson(this);
}

@JsonSerializable()
class SubscriptionData {
  final int id;
  @JsonKey(name: 'sl_no')
  final String slNo;

  @JsonKey(name: 'business_id')
  final int businessId;

  @JsonKey(name: 'package_id')
  final int packageId;

  @JsonKey(name: 'start_date')
  final String startDate;

  @JsonKey(name: 'end_date')
  final String endDate;

  @JsonKey(name: 'package_price')
  final int packagePrice;

  @JsonKey(name: 'package_details')
  final String packageDetails;

  @JsonKey(name: 'payment_method')
  final int? paymentMethod;

  @JsonKey(name: 'payment_status')
  final int paymentStatus;

  @JsonKey(name: 'transaction_id')
  final String? transactionId;

  SubscriptionData({
    required this.id,
    required this.slNo,
    required this.businessId,
    required this.packageId,
    required this.startDate,
    required this.endDate,
    required this.packagePrice,
    required this.packageDetails,
    this.paymentMethod,
    required this.paymentStatus,
    this.transactionId,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionDataToJson(this);
}

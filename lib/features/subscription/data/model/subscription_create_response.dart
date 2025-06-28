import 'package:json_annotation/json_annotation.dart';

part 'subscription_create_response.g.dart';

@JsonSerializable()
class SubscriptionCreateResponse {
  final bool success;
  final String message;
  final SubscriptionCreateData data;

  SubscriptionCreateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SubscriptionCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionCreateResponseToJson(this);
}

@JsonSerializable()
class SubscriptionCreateData {
  @JsonKey(name: 'package_id')
  final int packageId;

  @JsonKey(name: 'payment_method')
  final int paymentMethod;

  @JsonKey(name: 'package_price')
  final int packagePrice;

  @JsonKey(name: 'package_details')
  final String packageDetails;

  @JsonKey(name: 'max_sl_no')
  final int maxSlNo;

  @JsonKey(name: 'sl_no')
  final String slNo;

  @JsonKey(name: 'start_date')
  final String startDate;

  @JsonKey(name: 'end_date')
  final String endDate;

  @JsonKey(name: 'payment_status')
  final int paymentStatus;

  final int status;

  @JsonKey(name: 'business_id')
  final int businessId;

  @JsonKey(name: 'created_by')
  final int createdBy;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;


  SubscriptionCreateData({
    required this.packageId,
    required this.paymentMethod,
    required this.packagePrice,
    required this.packageDetails,
    required this.maxSlNo,
    required this.slNo,
    required this.startDate,
    required this.endDate,
    required this.paymentStatus,
    required this.status,
    required this.businessId,
    required this.createdBy,
    required this.updatedAt,
    required this.createdAt,
  });

  factory SubscriptionCreateData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionCreateDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionCreateDataToJson(this);
}

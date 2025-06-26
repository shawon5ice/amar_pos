import 'package:json_annotation/json_annotation.dart';

part 'subscription_list_response_model.g.dart';

@JsonSerializable()
class SubscriptionListResponseModel {
  final bool success;
  final List<SubscriptionPackage> data;

  SubscriptionListResponseModel({
    required this.success,
    required this.data,
  });

  factory SubscriptionListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionListResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionListResponseModelToJson(this);
}

@JsonSerializable()
class SubscriptionPackage {
  final int id;
  final String name;
  final String description;

  @JsonKey(name: 'trial_days')
  final int trialDays;

  @JsonKey(name: 'store_limit')
  final int storeLimit;

  @JsonKey(name: 'user_limit')
  final int userLimit;

  @JsonKey(name: 'product_limit')
  final int productLimit;

  @JsonKey(name: 'total_days')
  final String totalDays;

  final int price;

  @JsonKey(name: 'discount_price')
  final int discountPrice;

  final List<SubscriptionPackageDetail> details;

  SubscriptionPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.trialDays,
    required this.storeLimit,
    required this.userLimit,
    required this.productLimit,
    required this.totalDays,
    required this.price,
    required this.discountPrice,
    required this.details,
  });

  factory SubscriptionPackage.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPackageFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionPackageToJson(this);
}

@JsonSerializable()
class SubscriptionPackageDetail {
  final int id;

  @JsonKey(name: 'package_id')
  final int packageId;

  final String title;

  SubscriptionPackageDetail({
    required this.id,
    required this.packageId,
    required this.title,
  });

  factory SubscriptionPackageDetail.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPackageDetailFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionPackageDetailToJson(this);
}

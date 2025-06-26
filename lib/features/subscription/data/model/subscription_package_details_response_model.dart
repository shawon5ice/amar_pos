import 'package:json_annotation/json_annotation.dart';

part 'subscription_package_details_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SubscriptionPackageDetailsResponseModel {
  final bool? success;
  final SubscriptionPackageDetailData? data;

  SubscriptionPackageDetailsResponseModel({
    this.success,
    this.data,
  });

  factory SubscriptionPackageDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPackageDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionPackageDetailsResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SubscriptionPackageDetailData {
  final int? id;
  final String? name;
  final String? description;

  @JsonKey(name: 'trial_days')
  final int? trialDays;

  @JsonKey(name: 'store_limit')
  final int? storeLimit;

  @JsonKey(name: 'user_limit')
  final int? userLimit;

  @JsonKey(name: 'product_limit')
  final int? productLimit;

  @JsonKey(name: 'total_days')
  final String? totalDays;

  final int? price;

  @JsonKey(name: 'discount_price')
  final int? discountPrice;

  final List<PackageFeatureDetail>? details;

  SubscriptionPackageDetailData({
    this.id,
    this.name,
    this.description,
    this.trialDays,
    this.storeLimit,
    this.userLimit,
    this.productLimit,
    this.totalDays,
    this.price,
    this.discountPrice,
    this.details,
  });

  factory SubscriptionPackageDetailData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPackageDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionPackageDetailDataToJson(this);
}

@JsonSerializable()
class PackageFeatureDetail {
  final int? id;

  @JsonKey(name: 'package_id')
  final int? packageId;

  final String? title;

  PackageFeatureDetail({
    this.id,
    this.packageId,
    this.title,
  });

  factory PackageFeatureDetail.fromJson(Map<String, dynamic> json) =>
      _$PackageFeatureDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PackageFeatureDetailToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_package_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPackageDetailsResponseModel
    _$SubscriptionPackageDetailsResponseModelFromJson(
            Map<String, dynamic> json) =>
        SubscriptionPackageDetailsResponseModel(
          success: json['success'] as bool?,
          data: json['data'] == null
              ? null
              : SubscriptionPackageDetailData.fromJson(
                  json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$SubscriptionPackageDetailsResponseModelToJson(
        SubscriptionPackageDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data?.toJson(),
    };

SubscriptionPackageDetailData _$SubscriptionPackageDetailDataFromJson(
        Map<String, dynamic> json) =>
    SubscriptionPackageDetailData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      trialDays: (json['trial_days'] as num?)?.toInt(),
      storeLimit: (json['store_limit'] as num?)?.toInt(),
      userLimit: (json['user_limit'] as num?)?.toInt(),
      productLimit: (json['product_limit'] as num?)?.toInt(),
      totalDays: json['total_days'] as String?,
      price: (json['price'] as num?)?.toInt(),
      discountPrice: (json['discount_price'] as num?)?.toInt(),
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => PackageFeatureDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubscriptionPackageDetailDataToJson(
        SubscriptionPackageDetailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'trial_days': instance.trialDays,
      'store_limit': instance.storeLimit,
      'user_limit': instance.userLimit,
      'product_limit': instance.productLimit,
      'total_days': instance.totalDays,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'details': instance.details?.map((e) => e.toJson()).toList(),
    };

PackageFeatureDetail _$PackageFeatureDetailFromJson(
        Map<String, dynamic> json) =>
    PackageFeatureDetail(
      id: (json['id'] as num?)?.toInt(),
      packageId: (json['package_id'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$PackageFeatureDetailToJson(
        PackageFeatureDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'package_id': instance.packageId,
      'title': instance.title,
    };

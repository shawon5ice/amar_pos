// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionListResponseModel _$SubscriptionListResponseModelFromJson(
        Map<String, dynamic> json) =>
    SubscriptionListResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => SubscriptionPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubscriptionListResponseModelToJson(
        SubscriptionListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

SubscriptionPackage _$SubscriptionPackageFromJson(Map<String, dynamic> json) =>
    SubscriptionPackage(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      trialDays: (json['trial_days'] as num).toInt(),
      storeLimit: (json['store_limit'] as num).toInt(),
      userLimit: (json['user_limit'] as num).toInt(),
      productLimit: (json['product_limit'] as num).toInt(),
      totalDays: json['total_days'] as String,
      price: (json['price'] as num).toInt(),
      discountPrice: (json['discount_price'] as num).toInt(),
      details: (json['details'] as List<dynamic>)
          .map((e) =>
              SubscriptionPackageDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubscriptionPackageToJson(
        SubscriptionPackage instance) =>
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
      'details': instance.details,
    };

SubscriptionPackageDetail _$SubscriptionPackageDetailFromJson(
        Map<String, dynamic> json) =>
    SubscriptionPackageDetail(
      id: (json['id'] as num).toInt(),
      packageId: (json['package_id'] as num).toInt(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$SubscriptionPackageDetailToJson(
        SubscriptionPackageDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'package_id': instance.packageId,
      'title': instance.title,
    };

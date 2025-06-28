// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionResponse _$SubscriptionResponseFromJson(
        Map<String, dynamic> json) =>
    SubscriptionResponse(
      success: json['success'] as bool,
      data: SubscriptionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubscriptionResponseToJson(
        SubscriptionResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

SubscriptionData _$SubscriptionDataFromJson(Map<String, dynamic> json) =>
    SubscriptionData(
      id: (json['id'] as num).toInt(),
      slNo: json['sl_no'] as String,
      businessId: (json['business_id'] as num).toInt(),
      packageId: (json['package_id'] as num).toInt(),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      packagePrice: (json['package_price'] as num).toInt(),
      packageDetails: json['package_details'] as String,
      paymentMethod: (json['payment_method'] as num?)?.toInt(),
      paymentStatus: (json['payment_status'] as num).toInt(),
      transactionId: json['transaction_id'] as String?,
    );

Map<String, dynamic> _$SubscriptionDataToJson(SubscriptionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sl_no': instance.slNo,
      'business_id': instance.businessId,
      'package_id': instance.packageId,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'package_price': instance.packagePrice,
      'package_details': instance.packageDetails,
      'payment_method': instance.paymentMethod,
      'payment_status': instance.paymentStatus,
      'transaction_id': instance.transactionId,
    };

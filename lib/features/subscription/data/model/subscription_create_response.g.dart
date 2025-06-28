// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_create_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionCreateResponse _$SubscriptionCreateResponseFromJson(
        Map<String, dynamic> json) =>
    SubscriptionCreateResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data:
          SubscriptionCreateData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubscriptionCreateResponseToJson(
        SubscriptionCreateResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

SubscriptionCreateData _$SubscriptionCreateDataFromJson(
        Map<String, dynamic> json) =>
    SubscriptionCreateData(
      packageId: (json['package_id'] as num).toInt(),
      paymentMethod: (json['payment_method'] as num).toInt(),
      packagePrice: (json['package_price'] as num).toInt(),
      packageDetails: json['package_details'] as String,
      maxSlNo: (json['max_sl_no'] as num).toInt(),
      slNo: json['sl_no'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      paymentStatus: (json['payment_status'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      businessId: (json['business_id'] as num).toInt(),
      createdBy: (json['created_by'] as num).toInt(),
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$SubscriptionCreateDataToJson(
        SubscriptionCreateData instance) =>
    <String, dynamic>{
      'package_id': instance.packageId,
      'payment_method': instance.paymentMethod,
      'package_price': instance.packagePrice,
      'package_details': instance.packageDetails,
      'max_sl_no': instance.maxSlNo,
      'sl_no': instance.slNo,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'payment_status': instance.paymentStatus,
      'status': instance.status,
      'business_id': instance.businessId,
      'created_by': instance.createdBy,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
    };

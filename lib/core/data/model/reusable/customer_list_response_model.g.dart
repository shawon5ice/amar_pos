// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerListResponseModel _$CustomerListResponseModelFromJson(
        Map<String, dynamic> json) =>
    CustomerListResponseModel(
      success: json['success'] as bool,
      customerListData: (json['data'] as List<dynamic>)
          .map((e) => CustomerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerListResponseModelToJson(
        CustomerListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.customerListData,
    };

CustomerInfo _$CustomerInfoFromJson(Map<String, dynamic> json) => CustomerInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$CustomerInfoToJson(CustomerInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

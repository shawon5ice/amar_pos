// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierListResponseModel _$SupplierListResponseModelFromJson(
        Map<String, dynamic> json) =>
    SupplierListResponseModel(
      success: json['success'] as bool,
      supplierList: (json['data'] as List<dynamic>)
          .map((e) => SupplierInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SupplierListResponseModelToJson(
        SupplierListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.supplierList,
    };

SupplierInfo _$SupplierInfoFromJson(Map<String, dynamic> json) => SupplierInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      business: json['business'] as String,
      code: json['code'] as String,
      phone: json['phone'] as String,
      openingBalance: json['opening_balance'] as num?,
      address: json['address'] as String,
      photo: json['photo'] as String?,
      due: json['due'] as num?,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$SupplierInfoToJson(SupplierInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'business': instance.business,
      'code': instance.code,
      'phone': instance.phone,
      'address': instance.address,
      'opening_balance': instance.openingBalance,
      'due': instance.due,
      'photo': instance.photo,
      'status': instance.status,
    };

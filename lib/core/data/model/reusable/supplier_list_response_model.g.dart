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
      name: json['name'] as String? ?? 'N/A',
      business: json['business'] as String? ?? 'N/A',
      code: json['code'] as String? ?? 'N/A',
      phone: json['phone'] as String? ?? 'N/A',
      openingBalance: json['opening_balance'] as num? ?? 0,
      address: json['address'] as String? ?? 'N/A',
      photo: json['photo'] as String? ?? 'N/A',
      due: json['due'] as num? ?? 0,
      status: (json['status'] as num?)?.toInt() ?? -1,
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

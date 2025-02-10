// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_list_dd_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientListDDResponseModel _$ClientListDDResponseModelFromJson(
        Map<String, dynamic> json) =>
    ClientListDDResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ClientInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ClientListDDResponseModelToJson(
        ClientListDDResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

ClientInfo _$ClientInfoFromJson(Map<String, dynamic> json) => ClientInfo(
      id: (json['id'] as num).toInt(),
      clientNo: json['client_no'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      openingBalance: json['opening_balance'] as num,
      previousDue: json['previous_due'] as num,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$ClientInfoToJson(ClientInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_no': instance.clientNo,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'opening_balance': instance.openingBalance,
      'previous_due': instance.previousDue,
      'status': instance.status,
    };

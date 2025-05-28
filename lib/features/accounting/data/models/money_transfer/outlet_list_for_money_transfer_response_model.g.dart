// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outlet_list_for_money_transfer_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutletListForMoneyTransferResponseModel
    _$OutletListForMoneyTransferResponseModelFromJson(
            Map<String, dynamic> json) =>
        OutletListForMoneyTransferResponseModel(
          success: json['success'] as bool,
          data: const DataConverter().fromJson(json['data']),
        );

Map<String, dynamic> _$OutletListForMoneyTransferResponseModelToJson(
        OutletListForMoneyTransferResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      fromAccounts: (json['from_accounts'] as List<dynamic>?)
          ?.map((e) =>
              OutletForMoneyTransferData.fromJson(e as Map<String, dynamic>))
          .toList(),
      fromStores: (json['from_stores'] as List<dynamic>?)
          ?.map((e) =>
              OutletForMoneyTransferData.fromJson(e as Map<String, dynamic>))
          .toList(),
      toStores: (json['to_stores'] as List<dynamic>?)
          ?.map((e) =>
              OutletForMoneyTransferData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataWrapperToJson(DataWrapper instance) =>
    <String, dynamic>{
      'from_stores': instance.fromStores,
      'to_stores': instance.toStores,
      'from_accounts': instance.fromAccounts,
    };

OutletForMoneyTransferData _$OutletForMoneyTransferDataFromJson(
        Map<String, dynamic> json) =>
    OutletForMoneyTransferData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      storeId: json['store_id'] as int?,
    );

Map<String, dynamic> _$OutletForMoneyTransferDataToJson(
        OutletForMoneyTransferData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'store_id': instance.storeId,
    };

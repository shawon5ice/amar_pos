// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_ledger_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientLedgerListResponseModel _$ClientLedgerListResponseModelFromJson(
        Map<String, dynamic> json) =>
    ClientLedgerListResponseModel(
      success: json['success'] as bool,
      data: const DataConverter().fromJson(json['data']),
      countTotal: (json['count_total'] as num?)?.toInt() ?? 0,
      amountTotal: json['amount_total'] as num? ?? 0,
    );

Map<String, dynamic> _$ClientLedgerListResponseModelToJson(
        ClientLedgerListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
      'count_total': instance.countTotal,
      'amount_total': instance.amountTotal,
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ClientLedgerData.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataWrapperToJson(DataWrapper instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

ClientLedgerData _$ClientLedgerDataFromJson(Map<String, dynamic> json) =>
    ClientLedgerData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      due: json['due'] as num,
      clientNo: json['client_no'] as String,
      lastPaymentDate: json['last_payment_date'] as String? ?? 'N/A',
    );

Map<String, dynamic> _$ClientLedgerDataToJson(ClientLedgerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'due': instance.due,
      'last_payment_date': instance.lastPaymentDate,
      'client_no': instance.clientNo,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'last_page': instance.lastPage,
      'total': instance.total,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_ledger_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierLedgerListResponseModel _$SupplierLedgerListResponseModelFromJson(
        Map<String, dynamic> json) =>
    SupplierLedgerListResponseModel(
      success: json['success'] as bool,
      data: const DataConverter().fromJson(json['data']),
      countTotal: (json['count_total'] as num?)?.toInt() ?? 0,
      amountTotal: json['amount_total'] as num? ?? 0,
    );

Map<String, dynamic> _$SupplierLedgerListResponseModelToJson(
        SupplierLedgerListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
      'count_total': instance.countTotal,
      'amount_total': instance.amountTotal,
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SupplierLedgerData.fromJson(e as Map<String, dynamic>))
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

SupplierLedgerData _$SupplierLedgerDataFromJson(Map<String, dynamic> json) =>
    SupplierLedgerData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      due: json['due'] as num,
      code: json['code'] as String?,
      lastPaymentDate: json['last_payment_date'] as String?,
    );

Map<String, dynamic> _$SupplierLedgerDataToJson(SupplierLedgerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'due': instance.due,
      'last_payment_date': instance.lastPaymentDate,
      'code': instance.code,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'last_page': instance.lastPage,
      'total': instance.total,
    };

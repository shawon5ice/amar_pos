// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_ledger_statement_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierLedgerStatementResponseModel
    _$SupplierLedgerStatementResponseModelFromJson(Map<String, dynamic> json) =>
        SupplierLedgerStatementResponseModel(
          success: json['success'] as bool,
          data: json['data'] == null
              ? null
              : DataWrapper.fromJson(json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$SupplierLedgerStatementResponseModelToJson(
        SupplierLedgerStatementResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              SupplierLedgerStatementData.fromJson(e as Map<String, dynamic>))
          .toList(),
      clientInfo: json['clientInfo'] == null
          ? null
          : ClientInfo.fromJson(json['clientInfo'] as Map<String, dynamic>),
      balance: json['balance'] as num?,
      debit: json['debit'] as num?,
      credit: json['credit'] as num?,
    );

Map<String, dynamic> _$DataWrapperToJson(DataWrapper instance) =>
    <String, dynamic>{
      'data': instance.data,
      'clientInfo': instance.clientInfo,
      'debit': instance.debit,
      'credit': instance.credit,
      'balance': instance.balance,
    };

ClientInfo _$ClientInfoFromJson(Map<String, dynamic> json) => ClientInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      due: json['due'] as num,
      clientNo: json['client_no'] as String,
      lastPaymentDate: json['last_payment_date'] as String,
    );

Map<String, dynamic> _$ClientInfoToJson(ClientInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'due': instance.due,
      'last_payment_date': instance.lastPaymentDate,
      'client_no': instance.clientNo,
    };

SupplierLedgerStatementData _$SupplierLedgerStatementDataFromJson(
        Map<String, dynamic> json) =>
    SupplierLedgerStatementData(
      date: json['date'] as String,
      slNo: json['sl_no'] as String,
      debit: json['debit'] as num,
      credit: json['credit'] as num,
      balance: json['balance'] as num,
    );

Map<String, dynamic> _$SupplierLedgerStatementDataToJson(
        SupplierLedgerStatementData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'sl_no': instance.slNo,
      'debit': instance.debit,
      'credit': instance.credit,
      'balance': instance.balance,
    };

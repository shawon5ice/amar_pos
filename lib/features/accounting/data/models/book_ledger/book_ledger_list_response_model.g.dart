// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_ledger_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookLedgerListResponseModel _$BookLedgerListResponseModelFromJson(
        Map<String, dynamic> json) =>
    BookLedgerListResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => DataWrapper.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$BookLedgerListResponseModelToJson(
        BookLedgerListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => LedgerData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      debit: json['debit'] == null ? 0 : dynamicNumberFromJson(json['debit']),
      credit:
          json['credit'] == null ? 0 : dynamicNumberFromJson(json['credit']),
      type: json['type'] as String,
      balance:
          json['balance'] == null ? 0 : dynamicNumberFromJson(json['balance']),
    );

Map<String, dynamic> _$DataWrapperToJson(DataWrapper instance) =>
    <String, dynamic>{
      'data': instance.data,
      'debit': dynamicNumberToJson(instance.debit),
      'credit': dynamicNumberToJson(instance.credit),
      'type': instance.type,
      'balance': dynamicNumberToJson(instance.balance),
    };

LedgerData _$LedgerDataFromJson(Map<String, dynamic> json) => LedgerData(
      date: json['date'] as String,
      slNo: json['sl_no'] as String,
      accountName: json['account_name'] as String?,
      fullNarration: json['full_narration'] as String?,
      balance:
          json['balance'] == null ? 0 : dynamicNumberFromJson(json['balance']),
      type: json['type'] as String?,
      debit: json['debit'] == null ? 0 : dynamicNumberFromJson(json['debit']),
      credit:
          json['credit'] == null ? 0 : dynamicNumberFromJson(json['credit']),
    );

Map<String, dynamic> _$LedgerDataToJson(LedgerData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'sl_no': instance.slNo,
      'account_name': instance.accountName,
      'full_narration': instance.fullNarration,
      'balance': dynamicNumberToJson(instance.balance),
      'debit': dynamicNumberToJson(instance.debit),
      'type': instance.type,
      'credit': dynamicNumberToJson(instance.credit),
    };

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
          .toList(),
    );

Map<String, dynamic> _$BookLedgerListResponseModelToJson(
        BookLedgerListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: json['data'] == null
          ? null
          : BookLedgerList.fromJson(json['data'] as Map<String, dynamic>),
      debit: DataWrapper._debitFromJson(json['debit']),
      credit: DataWrapper._debitFromJson(json['credit']),
      type: json['type'] as String,
      balance: json['balance'] as num,
    );

Map<String, dynamic> _$DataWrapperToJson(DataWrapper instance) =>
    <String, dynamic>{
      'data': instance.data,
      'debit': DataWrapper._debitToJson(instance.debit),
      'credit': DataWrapper._debitToJson(instance.credit),
      'type': instance.type,
      'balance': instance.balance,
    };

BookLedgerList _$BookLedgerListFromJson(Map<String, dynamic> json) =>
    BookLedgerList(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => LedgerData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BookLedgerListToJson(BookLedgerList instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
      'last_page': instance.lastPage,
    };

LedgerData _$LedgerDataFromJson(Map<String, dynamic> json) => LedgerData(
      date: json['date'] as String,
      slNo: json['sl_no'] as String,
      accountName: json['account_name'] as String?,
      fullNarration: json['full_narration'] as String?,
      balance: json['balance'] as num?,
      type: json['type'] as String?,
      debit: json['debit'] ?? 0,
      credit: json['credit'] ?? 0,
    );

Map<String, dynamic> _$LedgerDataToJson(LedgerData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'sl_no': instance.slNo,
      'account_name': instance.accountName,
      'full_narration': instance.fullNarration,
      'balance': instance.balance,
      'debit': instance.debit,
      'type': instance.type,
      'credit': instance.credit,
    };

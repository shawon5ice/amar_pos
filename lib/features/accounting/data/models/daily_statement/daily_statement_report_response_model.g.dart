// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_statement_report_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyStatementReportResponseModel _$DailyStatementReportResponseModelFromJson(
        Map<String, dynamic> json) =>
    DailyStatementReportResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => DailyStatementData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyStatementReportResponseModelToJson(
        DailyStatementReportResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

DailyStatementData _$DailyStatementDataFromJson(Map<String, dynamic> json) =>
    DailyStatementData(
      data: const DataConverter().fromJson(json['data']),
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$DailyStatementDataToJson(DailyStatementData instance) =>
    <String, dynamic>{
      'data': const DataConverter().toJson(instance.data),
      'debit': instance.debit,
      'credit': instance.credit,
      'balance': instance.balance,
    };

StatementData _$StatementDataFromJson(Map<String, dynamic> json) =>
    StatementData(
      data: (json['data'] as List<dynamic>)
          .map((e) => TransactionData.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastPage: (json['last_page'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StatementDataToJson(StatementData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'last_page': instance.lastPage,
      'total': instance.total,
    };

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) =>
    TransactionData(
      accountType: (json['account_type'] as num).toInt(),
      slNo: json['sl_no'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      paymentMethod: json['payment_method'] as String?,
      purpose: json['purpose'] as String?,
    );

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'account_type': instance.accountType,
      'sl_no': instance.slNo,
      'amount': instance.amount,
      'date': instance.date,
      'payment_method': instance.paymentMethod,
      'purpose': instance.purpose,
    };
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_voucher_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalVoucherResponseModel _$JournalVoucherResponseModelFromJson(
        Map<String, dynamic> json) =>
    JournalVoucherResponseModel(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : VoucherData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JournalVoucherResponseModelToJson(
        JournalVoucherResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data?.toJson(),
    };

VoucherData _$VoucherDataFromJson(Map<String, dynamic> json) => VoucherData(
      id: (json['id'] as num).toInt(),
      voucherType: (json['voucher_type'] as num).toInt(),
      remarks: json['remarks'] as String?,
      details: (json['details'] as List<dynamic>)
          .map((e) => VoucherDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethod: json['payment_method'] == null
          ? null
          : PaymentMethod.fromJson(
              json['payment_method'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VoucherDataToJson(VoucherData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'voucher_type': instance.voucherType,
      'remarks': instance.remarks,
      'details': instance.details.map((e) => e.toJson()).toList(),
      'payment_method': instance.paymentMethod?.toJson(),
    };

VoucherDetail _$VoucherDetailFromJson(Map<String, dynamic> json) =>
    VoucherDetail(
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      refNo: json['ref_no'] as String?,
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
    );

Map<String, dynamic> _$VoucherDetailToJson(VoucherDetail instance) =>
    <String, dynamic>{
      'account': instance.account,
      'ref_no': instance.refNo,
      'debit': instance.debit,
      'credit': instance.credit,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      root: (json['root'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'root': instance.root,
    };

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      root: (json['root'] as num).toInt(),
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'root': instance.root,
    };

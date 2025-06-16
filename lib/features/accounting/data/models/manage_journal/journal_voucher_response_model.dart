import 'package:json_annotation/json_annotation.dart';

part 'journal_voucher_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class JournalVoucherResponseModel {
  final bool success;
  final VoucherData? data;

  JournalVoucherResponseModel({
    required this.success,
    this.data,
  });

  factory JournalVoucherResponseModel.fromJson(Map<String, dynamic> json) =>
      _$JournalVoucherResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$JournalVoucherResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VoucherData {
  final int id;

  @JsonKey(name: 'voucher_type')
  final int voucherType;

  final String? remarks;

  final List<VoucherDetail> details; // ✅ not nullable, but can be empty

  @JsonKey(name: 'payment_method')
  final PaymentMethod? paymentMethod;

  VoucherData({
    required this.id,
    required this.voucherType,
    this.remarks,
    required this.details,
    this.paymentMethod,
  });

  factory VoucherData.fromJson(Map<String, dynamic> json) =>
      _$VoucherDataFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherDataToJson(this);
}

@JsonSerializable()
class VoucherDetail {
  final Account account;

  @JsonKey(name: 'ref_no')
  final String? refNo;

  final double debit;
  final double credit;

  VoucherDetail({
    required this.account,
    this.refNo,
    required this.debit,
    required this.credit,
  });

  factory VoucherDetail.fromJson(Map<String, dynamic> json) =>
      _$VoucherDetailFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherDetailToJson(this);
}

@JsonSerializable()
class Account {
  final int id;
  final String name;
  final int? root;

  Account({
    required this.id,
    required this.name,
    this.root,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable()
class PaymentMethod {
  final int id;
  final String name;
  final int root;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.root,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}

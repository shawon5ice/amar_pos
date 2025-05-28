import 'package:json_annotation/json_annotation.dart';

part 'book_ledger_list_response_model.g.dart';

@JsonSerializable()
class BookLedgerListResponseModel {
  final bool success;

  @JsonKey(defaultValue: [])
  final List<DataWrapper> data;

  BookLedgerListResponseModel({
    required this.success,
    required this.data,
  });

  factory BookLedgerListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BookLedgerListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookLedgerListResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  @JsonKey(name: 'data', defaultValue: [])
  final List<LedgerData> data;

  @JsonKey(defaultValue: 0, fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? debit;

  @JsonKey(defaultValue: 0, fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? credit;

  final String type;

  @JsonKey(defaultValue: 0, fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? balance;

  DataWrapper({
    required this.data,
    required this.debit,
    required this.credit,
    required this.type,
    required this.balance,
  });

  factory DataWrapper.fromJson(Map<String, dynamic> json) =>
      _$DataWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class LedgerData {
  final String date;

  @JsonKey(name: 'sl_no')
  final String slNo;

  @JsonKey(name: 'account_name')
  final String? accountName;

  @JsonKey(name: 'full_narration')
  final String? fullNarration;

  @JsonKey(defaultValue: 0, fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? balance;

  @JsonKey(defaultValue: 0, fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? debit;

  final String? type;

  @JsonKey(defaultValue: 0, fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? credit;

  LedgerData({
    required this.date,
    required this.slNo,
    required this.accountName,
    required this.fullNarration,
    required this.balance,
    required this.type,
    required this.debit,
    required this.credit,
  });

  factory LedgerData.fromJson(Map<String, dynamic> json) =>
      _$LedgerDataFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerDataToJson(this);
}

/// Parses numbers safely from string/empty/null
num? dynamicNumberFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String && value.isEmpty) return 0;
  return num.tryParse(value.toString()) ?? 0;
}

/// Serializes numbers to string or 0 if null
dynamic dynamicNumberToJson(num? value) => value ?? 0;

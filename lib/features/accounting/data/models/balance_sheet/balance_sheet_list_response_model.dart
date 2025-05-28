import 'package:json_annotation/json_annotation.dart';

part 'balance_sheet_list_response_model.g.dart';

@JsonSerializable()
class BalanceSheetListResponseModel {
  final bool success;

  @JsonKey(defaultValue: [])
  final List<BalanceSheet> data;

  BalanceSheetListResponseModel({
    required this.success,
    this.data = const [],
  });

  factory BalanceSheetListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BalanceSheetListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceSheetListResponseModelToJson(this);
}

@JsonSerializable()
class BalanceSheet {
  final String? name;

  @JsonKey(
    defaultValue: 0,
    fromJson: dynamicNumberFromJson,
    toJson: dynamicNumberToJson,
  )
  final num? debit;

  @JsonKey(
    defaultValue: 0,
    fromJson: dynamicNumberFromJson,
    toJson: dynamicNumberToJson,
  )
  final num? credit;

  BalanceSheet({
    this.name,
    this.debit,
    this.credit,
  });

  factory BalanceSheet.fromJson(Map<String, dynamic> json) =>
      _$BalanceSheetFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceSheetToJson(this);
}

num dynamicNumberFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String && value.trim().isEmpty) return 0;
  return num.tryParse(value.toString()) ?? 0;
}

dynamic dynamicNumberToJson(num? value) => value ?? 0;

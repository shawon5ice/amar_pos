import 'package:json_annotation/json_annotation.dart';

part 'balance_sheet_list_response_model.g.dart';

@JsonSerializable()
class BalanceSheetListResponseModel {
  final bool success;
  final List<BalanceSheet>? data;

  BalanceSheetListResponseModel({required this.success, required this.data,});

  factory BalanceSheetListResponseModel.fromJson(Map<String, dynamic> json) => _$BalanceSheetListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceSheetListResponseModelToJson(this);
}

@JsonSerializable()
class BalanceSheet {
  // final String? align;
  final String? name;
  @JsonKey(defaultValue: 0, name: 'is_minus')
  // final int? isMinus;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? debit;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? credit;


  BalanceSheet({
    // required this.align,
    // required this.isMinus,
    required this.name,
    required this.debit,
    required this.credit,
  });

  factory BalanceSheet.fromJson(Map<String, dynamic> json) => _$BalanceSheetFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceSheetToJson(this);
}

num? dynamicNumberFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String && value.isEmpty) return null; // or 0.0 if needed
  return num.tryParse(value.toString());
}

 dynamic dynamicNumberToJson(num? value) => value ?? "";
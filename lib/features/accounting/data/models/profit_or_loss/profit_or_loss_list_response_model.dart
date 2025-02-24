import 'package:json_annotation/json_annotation.dart';

part 'profit_or_loss_list_response_model.g.dart';

@JsonSerializable()
class ProfitOrLossListResponseModel {
  final bool success;
  final List<ProfitOrLoss>? data;

  ProfitOrLossListResponseModel({required this.success, required this.data,});

  factory ProfitOrLossListResponseModel.fromJson(Map<String, dynamic> json) => _$ProfitOrLossListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfitOrLossListResponseModelToJson(this);
}

@JsonSerializable()
class ProfitOrLoss {
  final String? align;
  final String? name;
  @JsonKey(defaultValue: 0, name: 'is_minus')
  final int? isMinus;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? debit;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? credit;


  ProfitOrLoss({
    required this.align,
    required this.isMinus,
    required this.name,
    required this.debit,
    required this.credit,
  });

  factory ProfitOrLoss.fromJson(Map<String, dynamic> json) => _$ProfitOrLossFromJson(json);
  Map<String, dynamic> toJson() => _$ProfitOrLossToJson(this);
}

num? dynamicNumberFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String && value.isEmpty) return null; // or 0.0 if needed
  return num.tryParse(value.toString());
}

 dynamic dynamicNumberToJson(num? value) => value ?? "";
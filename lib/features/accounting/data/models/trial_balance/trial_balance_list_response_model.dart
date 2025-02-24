import 'package:json_annotation/json_annotation.dart';

part 'trial_balance_list_response_model.g.dart';

@JsonSerializable()
class TrialBalanceListResponseModel {
  final bool success;
  @DataConverter()
  final List<DataWrapper>? data;

  TrialBalanceListResponseModel({required this.success, required this.data,});

  factory TrialBalanceListResponseModel.fromJson(Map<String, dynamic> json) => _$TrialBalanceListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$TrialBalanceListResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  @JsonKey(name: 'data', )
  final List<TrialBalance>? trialBalanceList;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? debit;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? credit;
  

  DataWrapper({
    required this.trialBalanceList,
    required this.debit,
    required this.credit,
  });


  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}



@JsonSerializable()
class TrialBalance {
  final String? code;
  final String? name;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? debit;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? credit;


  TrialBalance({
    required this.code,
    required this.name,
    required this.debit,
    required this.credit,
  });

  factory TrialBalance.fromJson(Map<String, dynamic> json) => _$TrialBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$TrialBalanceToJson(this);
}

class DataConverter implements JsonConverter<DataWrapper?, dynamic> {
  const DataConverter();

  @override
  DataWrapper? fromJson(dynamic json) {
    if (json is List) {
      return null;
    } else if (json is Map<String, dynamic>) {
      return DataWrapper.fromJson(json);
    } else {
      throw Exception('Unexpected type for data: ${json.runtimeType}');
    }
  }

  @override
  dynamic toJson(DataWrapper? object) => object?.toJson();
}

num? dynamicNumberFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String && value.isEmpty) return null; // or 0.0 if needed
  return num.tryParse(value.toString());
}

 dynamic dynamicNumberToJson(num? value) => value ?? "";
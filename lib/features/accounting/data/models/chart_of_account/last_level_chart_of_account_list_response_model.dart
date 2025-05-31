import 'package:json_annotation/json_annotation.dart';

part 'last_level_chart_of_account_list_response_model.g.dart';

@JsonSerializable()
class LastLevelChartOfAccountListResponseModel {
  final bool success;
  final List<ChartOfAccount> data;

  LastLevelChartOfAccountListResponseModel({required this.success, required this.data});

  factory LastLevelChartOfAccountListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LastLevelChartOfAccountListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LastLevelChartOfAccountListResponseModelToJson(this);
}

@JsonSerializable()
class ChartOfAccount {
  final int id;
  final String name;

  ChartOfAccount({required this.id, required this.name});

  factory ChartOfAccount.fromJson(Map<String, dynamic> json) =>
      _$ChartOfAccountFromJson(json);
  Map<String, dynamic> toJson() => _$ChartOfAccountToJson(this);
}

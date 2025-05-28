import 'package:json_annotation/json_annotation.dart';

part 'chart_of_account_list_response_model.g.dart';

@JsonSerializable()
class ChartOfAccountListResponseModel {
  final bool success;
  final ChartOfAccountData data;

  ChartOfAccountListResponseModel({
    required this.success,
    required this.data,
  });

  factory ChartOfAccountListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChartOfAccountListResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChartOfAccountListResponseModelToJson(this);
}

@JsonSerializable()
class ChartOfAccountData {
  final List<ChartOfAccountItem> data;
  final Meta meta;

  ChartOfAccountData({
    required this.data,
    required this.meta,
  });

  factory ChartOfAccountData.fromJson(Map<String, dynamic> json) =>
      _$ChartOfAccountDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChartOfAccountDataToJson(this);
}

@JsonSerializable()
class ChartOfAccountItem {
  final int id;
  final List<dynamic> business;
  final List<dynamic> store;
  final String? code;
  final String name;

  @JsonKey(fromJson: chartRootFromJson, toJson: chartRootToJson)
  final ChartOfAccountRoot? root;

  final String type;
  final String? remarks;

  @JsonKey(name: 'is_actionable')
  final bool isActionable;

  ChartOfAccountItem({
    required this.id,
    required this.business,
    required this.store,
    this.code,
    required this.name,
    this.root,
    required this.type,
    this.remarks,
    required this.isActionable,
  });

  factory ChartOfAccountItem.fromJson(Map<String, dynamic> json) =>
      _$ChartOfAccountItemFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChartOfAccountItemToJson(this);
}

@JsonSerializable()
class ChartOfAccountRoot {
  final int id;
  final String name;

  ChartOfAccountRoot({
    required this.id,
    required this.name,
  });

  factory ChartOfAccountRoot.fromJson(Map<String, dynamic> json) =>
      _$ChartOfAccountRootFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChartOfAccountRootToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: 'last_page')
  final int lastPage;

  final int total;

  Meta({
    required this.lastPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) =>
      _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}


ChartOfAccountRoot? chartRootFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
    return ChartOfAccountRoot.fromJson(json);
  }
  return null;
}

dynamic chartRootToJson(ChartOfAccountRoot? root) {
  return root?.toJson();
}

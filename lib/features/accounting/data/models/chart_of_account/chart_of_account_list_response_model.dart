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
  final int? parentId;

  @JsonKey(fromJson: _parseBusiness, toJson: _businessToJson)
  final Business? business;

  @JsonKey(fromJson: _parseStore, toJson: _storeToJson)
  final Store? store;

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
    this.business,
    this.parentId,
    this.store,
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
class Business {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String logo;
  final String address;

  @JsonKey(name: 'photo_url')
  final String photoUrl;

  Business({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.logo,
    required this.address,
    required this.photoUrl,
  });

  factory Business.fromJson(Map<String, dynamic> json) =>
      _$BusinessFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessToJson(this);
}

@JsonSerializable()
class Store {
  final int id;
  final String name;
  final String phone;
  final String address;

  Store({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory Store.fromJson(Map<String, dynamic> json) =>
      _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
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

  Map<String, dynamic> toJson() => _$ChartOfAccountRootToJson(this);
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

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

// ==== Custom converters ====

Business? _parseBusiness(dynamic json) {
  if (json is Map<String, dynamic>) {
    return Business.fromJson(json);
  }
  return null;
}

dynamic _businessToJson(Business? business) => business?.toJson();

Store? _parseStore(dynamic json) {
  if (json is Map<String, dynamic>) {
    return Store.fromJson(json);
  }
  return null;
}

dynamic _storeToJson(Store? store) => store?.toJson();

ChartOfAccountRoot? chartRootFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
    return ChartOfAccountRoot.fromJson(json);
  }
  return null;
}

dynamic chartRootToJson(ChartOfAccountRoot? root) => root?.toJson();

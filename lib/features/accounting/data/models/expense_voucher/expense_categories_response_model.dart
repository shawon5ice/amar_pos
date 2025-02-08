import 'package:json_annotation/json_annotation.dart';

part 'expense_categories_response_model.g.dart';

@JsonSerializable()
class ExpenseCategoriesResponseModel {
  final bool success;
  @DataConverter()
  final DataWrapper data;

  ExpenseCategoriesResponseModel({required this.success, required this.data});

  factory ExpenseCategoriesResponseModel.fromJson(Map<String, dynamic> json) => _$ExpenseCategoriesResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseCategoriesResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  @JsonKey(name: 'data')
  final List<ExpenseCategory>? data;
  final Meta? meta;

  DataWrapper({this.data, this.meta});

  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class ExpenseCategory {
  final int id;
  // final List<dynamic> business;
  // final List<dynamic> store;
  final String? code;
  final String name;
  final Root root;
  final String type;
  final String? remarks;
  @JsonKey(name: 'is_actionable')
  final bool isActionable;

  ExpenseCategory({
    required this.id,
    // required this.business,
    // required this.store,
    this.code,
    required this.name,
    required this.root,
    required this.type,
    this.remarks,
    required this.isActionable,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) => _$ExpenseCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseCategoryToJson(this);
}

@JsonSerializable()
class Root {
  final int id;
  final String name;

  Root({required this.id, required this.name});

  factory Root.fromJson(Map<String, dynamic> json) => _$RootFromJson(json);
  Map<String, dynamic> toJson() => _$RootToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: 'last_page')
  final int lastPage;
  final int total;

  Meta({required this.lastPage, required this.total});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
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
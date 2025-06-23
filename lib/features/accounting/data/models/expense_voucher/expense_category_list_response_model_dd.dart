import 'package:json_annotation/json_annotation.dart';

part 'expense_category_list_response_model_dd.g.dart';

@JsonSerializable()
class ExpenseCategoryListResponseModelDD {
  final bool success;
  final List<Expense> data;

  ExpenseCategoryListResponseModelDD({
    required this.success,
    required this.data,
  });

  factory ExpenseCategoryListResponseModelDD.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryListResponseModelDDFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseCategoryListResponseModelDDToJson(this);
}

@JsonSerializable()
class Expense {
  final int id;
  final String name;
  final int root;

  Expense({
    required this.id,
    required this.name,
    required this.root,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Expense &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

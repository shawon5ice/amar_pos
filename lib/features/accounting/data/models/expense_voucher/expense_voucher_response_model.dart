import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense_voucher_response_model.g.dart';

@JsonSerializable()
class ExpenseVoucherResponseModel {
  final bool success;
  @DataConverter()
  final DataWrapper? data;

  ExpenseVoucherResponseModel({required this.success, required this.data});

  factory ExpenseVoucherResponseModel.fromJson(Map<String, dynamic> json) => _$ExpenseVoucherResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseVoucherResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  final List<TransactionData>? data;
  final Meta? meta;

  DataWrapper({this.data, this.meta});

  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class TransactionData {
  final int id;
  final String date;
  @JsonKey(name: 'sl_no')
  final String slNo;
  final Category category;
  @JsonKey(name: 'payment_method')
  final ChartOfAccountPaymentMethod paymentMethod;
  final double amount;
  @JsonKey(name: 'account_type')
  final int accountType;
  final String? remarks;

  TransactionData({
    required this.id,
    required this.date,
    required this.slNo,
    required this.category,
    required this.paymentMethod,
    required this.amount,
    required this.accountType,
    this.remarks,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) => _$TransactionDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}

@JsonSerializable()
class Category {
  final int id;
  @JsonKey(name: 'business_id')
  final int? businessId;
  @JsonKey(name: 'store_id')
  final int? storeId;
  final String name;
  final String? code;
  final String? remarks;
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Category({
    required this.id,
    this.businessId,
    this.storeId,
    required this.name,
    this.code,
    this.remarks,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}


@JsonSerializable()
class PaymentMethod {
  final int id;
  @JsonKey(name: 'business_id')
  final int? businessId;
  @JsonKey(name: 'store_id')
  final int? storeId;
  final String name;
  final String? code;
  final String? remarks;
  final int root;
  final int type;
  final int status;
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  PaymentMethod({
    required this.id,
    this.businessId,
    this.storeId,
    required this.name,
    this.code,
    this.remarks,
    required this.root,
    required this.type,
    required this.status,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.createdAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
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
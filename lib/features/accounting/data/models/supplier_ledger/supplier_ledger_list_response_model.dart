import 'package:json_annotation/json_annotation.dart';

part 'supplier_ledger_list_response_model.g.dart';

@JsonSerializable()
class SupplierLedgerListResponseModel {
  final bool success;
  @DataConverter()
  final DataWrapper? data;
  @JsonKey(name: 'count_total', defaultValue: 0)
  final int countTotal;
  @JsonKey(name: 'amount_total', defaultValue: 0)
  final num amountTotal;

  SupplierLedgerListResponseModel({required this.success, required this.data,required this.countTotal,required this.amountTotal});

  factory SupplierLedgerListResponseModel.fromJson(Map<String, dynamic> json) => _$SupplierLedgerListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierLedgerListResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  final List<SupplierLedgerData>? data;
  final Meta? meta;

  DataWrapper({this.data, this.meta});

  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class SupplierLedgerData {
  final int id;
  final String? name;
  final String? phone;
  final String? address;

  final num due;
  @JsonKey(name: 'last_payment_date')
  final String? lastPaymentDate;
  final String? code;

  SupplierLedgerData({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.due,
    required this.code,
    required this.lastPaymentDate,
  });

  factory SupplierLedgerData.fromJson(Map<String, dynamic> json) => _$SupplierLedgerDataFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierLedgerDataToJson(this);
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
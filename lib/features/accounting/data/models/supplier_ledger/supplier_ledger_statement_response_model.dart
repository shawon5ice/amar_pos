import 'package:json_annotation/json_annotation.dart';

part 'supplier_ledger_statement_response_model.g.dart';

@JsonSerializable()
class SupplierLedgerStatementResponseModel {
  final bool success;
  final DataWrapper? data;


  SupplierLedgerStatementResponseModel(
      {required this.success,
      required this.data,});

  factory SupplierLedgerStatementResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$SupplierLedgerStatementResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SupplierLedgerStatementResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  final List<SupplierLedgerStatementData>? data;
  final ClientInfo? clientInfo;
  final num? debit;
  final num? credit;
  final num? balance;

  DataWrapper({
    this.data,
    this.clientInfo,
    this.balance,
    this.debit,
    this.credit,
  });

  factory DataWrapper.fromJson(Map<String, dynamic> json) =>
      _$DataWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class ClientInfo {
  final int id;
  final String name;
  final String phone;
  final String address;

  final num due;
  @JsonKey(name: 'last_payment_date')
  final String lastPaymentDate;
  @JsonKey(name: 'client_no')
  final String clientNo;

  ClientInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.due,
    required this.clientNo,
    required this.lastPaymentDate,
  });

  factory ClientInfo.fromJson(Map<String, dynamic> json) =>
      _$ClientInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ClientInfoToJson(this);
}

@JsonSerializable()
class SupplierLedgerStatementData {
  final String date;
  @JsonKey(name: 'sl_no')
  final String slNo;
  final num debit;
  final num credit;
  final num balance;

  SupplierLedgerStatementData({
    required this.date,
    required this.slNo,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory SupplierLedgerStatementData.fromJson(Map<String, dynamic> json) =>
      _$SupplierLedgerStatementDataFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierLedgerStatementDataToJson(this);
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

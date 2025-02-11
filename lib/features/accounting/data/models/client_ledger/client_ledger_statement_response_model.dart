import 'package:amar_pos/core/widgets/reusable/client_dd/client_list_dd_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_ledger_statement_response_model.g.dart';

@JsonSerializable()
class ClientLedgerStatementResponseModel {
  final bool success;
  final DataWrapper? data;


  ClientLedgerStatementResponseModel(
      {required this.success,
      required this.data,});

  factory ClientLedgerStatementResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$ClientLedgerStatementResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ClientLedgerStatementResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  final List<LedgerStatementData>? data;
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
class LedgerStatementData {
  final String date;
  @JsonKey(name: 'sl_no')
  final String slNo;
  final num debit;
  final num credit;
  final num balance;

  LedgerStatementData({
    required this.date,
    required this.slNo,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory LedgerStatementData.fromJson(Map<String, dynamic> json) =>
      _$LedgerStatementDataFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerStatementDataToJson(this);
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

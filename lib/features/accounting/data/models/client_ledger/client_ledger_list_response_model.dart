import 'package:amar_pos/core/widgets/reusable/client_dd/client_list_dd_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_ledger_list_response_model.g.dart';

@JsonSerializable()
class ClientLedgerListResponseModel {
  final bool success;
  @DataConverter()
  final DataWrapper? data;
  @JsonKey(name: 'count_total', defaultValue: 0)
  final int countTotal;
  @JsonKey(name: 'amount_total', defaultValue: 0)
  final num amountTotal;

  ClientLedgerListResponseModel({required this.success, required this.data,required this.countTotal,required this.amountTotal});

  factory ClientLedgerListResponseModel.fromJson(Map<String, dynamic> json) => _$ClientLedgerListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClientLedgerListResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  final List<ClientLedgerData>? data;
  final Meta? meta;

  DataWrapper({this.data, this.meta});

  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class ClientLedgerData {
  final int id;
  final String name;
  final String phone;
  final String address;

  final num due;
  @JsonKey(name: 'last_payment_date', defaultValue: 'N/A')
  final String lastPaymentDate;
  @JsonKey(name: 'client_no')
  final String clientNo;

  ClientLedgerData({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.due,
    required this.clientNo,
    required this.lastPaymentDate,
  });

  factory ClientLedgerData.fromJson(Map<String, dynamic> json) => _$ClientLedgerDataFromJson(json);
  Map<String, dynamic> toJson() => _$ClientLedgerDataToJson(this);
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
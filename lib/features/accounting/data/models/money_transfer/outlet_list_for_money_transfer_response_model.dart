import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'outlet_list_for_money_transfer_response_model.g.dart';

@JsonSerializable()
class OutletListForMoneyTransferResponseModel {
  final bool success;
  @DataConverter()
  final DataWrapper? data;

  OutletListForMoneyTransferResponseModel({required this.success, required this.data,});

  factory OutletListForMoneyTransferResponseModel.fromJson(Map<String, dynamic> json) => _$OutletListForMoneyTransferResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$OutletListForMoneyTransferResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  @JsonKey(name: 'from_stores')
  final List<OutletForMoneyTransferData>? fromStores;

  @JsonKey(name: 'to_stores')
  final List<OutletForMoneyTransferData>? toStores;

  @JsonKey(name: 'from_accounts')
  final List<OutletForMoneyTransferData>? fromAccounts;

  DataWrapper({this.fromAccounts, this.fromStores, this.toStores});

  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class OutletForMoneyTransferData {
  final int id;
  final String name;
  @JsonKey(name: 'store_id')
  final int? storeId;


  OutletForMoneyTransferData({
    required this.id,
    required this.name,
    this.storeId
  });

  factory OutletForMoneyTransferData.fromJson(Map<String, dynamic> json) => _$OutletForMoneyTransferDataFromJson(json);
  Map<String, dynamic> toJson() => _$OutletForMoneyTransferDataToJson(this);
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

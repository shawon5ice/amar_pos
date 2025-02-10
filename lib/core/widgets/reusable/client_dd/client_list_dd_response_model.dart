import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/features/exchange/data/models/create_exchange_request_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_list_dd_response_model.g.dart';

@JsonSerializable()
class ClientListDDResponseModel {
  final bool success;
  @JsonKey(defaultValue: [])
  final List<ClientInfo> data;

  ClientListDDResponseModel({required this.success, required this.data,});

  factory ClientListDDResponseModel.fromJson(Map<String, dynamic> json) => _$ClientListDDResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClientListDDResponseModelToJson(this);
}



@JsonSerializable()
class ClientInfo {
  final int id;
  @JsonKey(name: 'client_no')
  final String clientNo;
  final String name;
  final String phone;
  final String address;
  @JsonKey(name: 'opening_balance')
  final num openingBalance;  
  @JsonKey(name: 'previous_due')
  final num previousDue;
  final int status;

  ClientInfo({
    required this.id,
    required this.clientNo,
    required this.name,
    required this.phone,
    required this.address,
    required this.openingBalance,
    required this.previousDue,
    required this.status,
  });

  factory ClientInfo.fromJson(Map<String, dynamic> json) => _$ClientInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ClientInfoToJson(this);
}

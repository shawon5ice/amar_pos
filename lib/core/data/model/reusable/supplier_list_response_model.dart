import 'package:json_annotation/json_annotation.dart';


part 'supplier_list_response_model.g.dart';

@JsonSerializable()
class SupplierListResponseModel {
  final bool success;
  @JsonKey(name: 'data')
  final List<SupplierInfo> supplierList;

  SupplierListResponseModel({
    required this.success,
    required this.supplierList,
  });

  factory SupplierListResponseModel.fromJson(Map<String, dynamic> json) => _$SupplierListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierListResponseModelToJson(this);

}

@JsonSerializable()
class SupplierInfo {
  final int id;
  @JsonKey(defaultValue: 'N/A')
  final String name;
  @JsonKey(defaultValue: 'N/A')
  final String business;
  @JsonKey(defaultValue: 'N/A')
  final String code;
  @JsonKey(defaultValue: 'N/A')
  final String phone;
  @JsonKey(defaultValue: 'N/A')
  final String address;
  @JsonKey(name: 'opening_balance', defaultValue: 0)
  final num openingBalance;
  @JsonKey(name: 'previous_due', defaultValue: 0)
  final num previousDue;
  @JsonKey(defaultValue: 'N/A')
  final String photo;
  @JsonKey(defaultValue: -1)
  final int status;

  SupplierInfo({
    required this.id,
    required this.name,
    required this.business,
    required this.code,
    required this.phone,
    required this.openingBalance,
    required this.address,
    required this.photo,
    required this.previousDue,
    required this.status,
  });

  factory SupplierInfo.fromJson(Map<String, dynamic> json) => _$SupplierInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierInfoToJson(this);

}

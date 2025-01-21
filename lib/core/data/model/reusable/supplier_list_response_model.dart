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
  final String name;
  final String business;
  final String code;
  final String phone;
  final String address;
  @JsonKey(name: 'opening_balance')
  final num? openingBalance;
  final num? due;
  final String? photo;
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
    required this.due,
    required this.status,
  });

  factory SupplierInfo.fromJson(Map<String, dynamic> json) => _$SupplierInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierInfoToJson(this);

}

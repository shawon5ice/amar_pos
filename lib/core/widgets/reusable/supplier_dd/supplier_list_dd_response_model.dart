// import 'package:json_annotation/json_annotation.dart';
//
// part 'supplier_list_dd_response_model.g.dart';
//
// @JsonSerializable()
// class SupplierListDDResponseModel {
//   final bool success;
//   @JsonKey(defaultValue: [])
//   final List<SupplierInfo> data;
//
//   SupplierListDDResponseModel({required this.success, required this.data,});
//
//   factory SupplierListDDResponseModel.fromJson(Map<String, dynamic> json) => _$SupplierListDDResponseModelFromJson(json);
//   Map<String, dynamic> toJson() => _$SupplierListDDResponseModelToJson(this);
// }
//
// @JsonSerializable()
// class SupplierInfo {
//   final int id;
//   final String name;
//   final String business;
//   final String phone;
//   final String address;
//   final String code;
//   @JsonKey(name: 'opening_balance')
//   final num openingBalance;
//   final num due;
//   final int status;
//   final String photo;
//
//   SupplierInfo({
//     required this.id,
//     required this.business,
//     required this.name,
//     required this.phone,
//     required this.address,
//     required this.openingBalance,
//     required this.status,
//     required this.due,
//     required this.code,
//     required this.photo,
//   });
//
//   factory SupplierInfo.fromJson(Map<String, dynamic> json) => _$SupplierInfoFromJson(json);
//   Map<String, dynamic> toJson() => _$SupplierInfoToJson(this);
// }

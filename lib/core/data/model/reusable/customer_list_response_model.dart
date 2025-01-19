import 'package:json_annotation/json_annotation.dart';

part 'customer_list_response_model.g.dart';

@JsonSerializable()
class CustomerListResponseModel {
  final bool success;
  @JsonKey(name: 'data')
  final List<CustomerInfo> customerListData;

  CustomerListResponseModel({
    required this.success,
    required this.customerListData,
  });

  factory CustomerListResponseModel.fromJson(Map<String, dynamic> json) => _$CustomerListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerListResponseModelToJson(this);
}

@JsonSerializable()
class CustomerInfo {
  final int id;
  final String? name;
  final String phone;
  final String address;

  CustomerInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => _$CustomerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerInfoToJson(this);
}
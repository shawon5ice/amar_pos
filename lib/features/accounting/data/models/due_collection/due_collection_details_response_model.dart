import 'package:json_annotation/json_annotation.dart';

part 'due_collection_details_response_model.g.dart';

@JsonSerializable()
class DueCollectionDetailsResponseModel {
  final bool success;
  final DueCollectionDetailsData data;

  DueCollectionDetailsResponseModel({required this.success, required this.data});

  factory DueCollectionDetailsResponseModel.fromJson(Map<String, dynamic> json) => _$DueCollectionDetailsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DueCollectionDetailsResponseModelToJson(this);
}

@JsonSerializable()
class DueCollectionDetailsData {
  final int id;
  final Business business;
  final Store store;
  final Client client;
  @JsonKey(name: 'sl_no')
  final String slNo;
  final String date;
  final String remarks;
  final Creator creator;
  @JsonKey(name: 'previous_due')
  final double previousDue;
  final List<Detail> details;

  DueCollectionDetailsData({
    required this.id,
    required this.business,
    required this.store,
    required this.client,
    required this.slNo,
    required this.date,
    required this.remarks,
    required this.creator,
    required this.previousDue,
    required this.details,
  });

  factory DueCollectionDetailsData.fromJson(Map<String, dynamic> json) => _$DueCollectionDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$DueCollectionDetailsDataToJson(this);
}

@JsonSerializable()
class Business {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String logo;
  final String address;
  @JsonKey(name: 'photo_url')
  final String photoUrl;

  Business({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.logo,
    required this.address,
    required this.photoUrl,
  });

  factory Business.fromJson(Map<String, dynamic> json) => _$BusinessFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessToJson(this);
}

@JsonSerializable()
class Store {
  final int id;
  final String name;
  final String phone;
  final String address;

  Store({required this.id, required this.name, required this.phone, required this.address});

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable()
class Client {
  final int id;
  @JsonKey(name: 'client_no')
  final String clientNo;
  final String name;
  final String phone;
  final String address;
  @JsonKey(name: 'opening_balance')
  final double openingBalance;
  @JsonKey(name: 'previous_due')
  final double previousDue;
  final int status;

  Client({
    required this.id,
    required this.clientNo,
    required this.name,
    required this.phone,
    required this.address,
    required this.openingBalance,
    required this.previousDue,
    required this.status,
  });

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
  Map<String, dynamic> toJson() => _$ClientToJson(this);
}

@JsonSerializable()
class Creator {
  final int id;
  final String name;
  @JsonKey(name: 'photo_url')
  final String photoUrl;

  Creator({required this.id, required this.name, required this.photoUrl});

  factory Creator.fromJson(Map<String, dynamic> json) => _$CreatorFromJson(json);
  Map<String, dynamic> toJson() => _$CreatorToJson(this);
}

@JsonSerializable()
class Detail {
  final int id;
  final double amount;
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;

  Detail({required this.id, required this.amount, required this.paymentMethod});

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);
  Map<String, dynamic> toJson() => _$DetailToJson(this);
}

@JsonSerializable()
class PaymentMethod {
  final int id;
  final String name;
  final int root;

  PaymentMethod({required this.id, required this.name, required this.root});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
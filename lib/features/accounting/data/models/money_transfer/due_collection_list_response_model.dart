import 'package:amar_pos/core/widgets/reusable/client_dd/client_list_dd_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'due_collection_list_response_model.g.dart';

@JsonSerializable()
class DueCollectionListResponseModel {
  final bool success;
  @DataConverter()
  final DataWrapper? data;
  @JsonKey(name: 'count_total', defaultValue: 0)
  final int countTotal;
  @JsonKey(name: 'amount_total', defaultValue: 0)
  final num amountTotal;

  DueCollectionListResponseModel({required this.success, required this.data,required this.countTotal,required this.amountTotal});

  factory DueCollectionListResponseModel.fromJson(Map<String, dynamic> json) => _$DueCollectionListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DueCollectionListResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  final List<DueCollectionData>? data;
  final Meta? meta;

  DataWrapper({this.data, this.meta});

  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class DueCollectionData {
  final int id;
  final String date;
  @JsonKey(name: 'sl_no')
  final String slNo;
  @JsonKey(name: 'payment_method')
  final ChartOfAccountPaymentMethod paymentMethod;
  @JsonKey(name: 'business')
  final Business? business;
  @JsonKey(name: 'store')
  final Store? store;
  @JsonKey(name: 'creator')
  final Creator? creator;

  // @ClientConverter()
  // @JsonKey(name: 'client',)
  final ClientInfo? client;
  final double amount;
  final String? remarks;

  DueCollectionData({
    required this.id,
    required this.date,
    required this.slNo,
    required this.paymentMethod,
    required this.amount,
    required this.creator,
    required this.store,
    required this.business,
    required this.client,
    this.remarks,
  });

  factory DueCollectionData.fromJson(Map<String, dynamic> json) => _$DueCollectionDataFromJson(json);
  Map<String, dynamic> toJson() => _$DueCollectionDataToJson(this);
}

@JsonSerializable()
class Category {
  final int id;
  @JsonKey(name: 'business_id')
  final int? businessId;
  @JsonKey(name: 'store_id')
  final int? storeId;
  final String name;
  final String? code;
  final String? remarks;
  final int root;
  final int type;
  final int status;
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Category({
    required this.id,
    this.businessId,
    this.storeId,
    required this.name,
    this.code,
    this.remarks,
    required this.root,
    required this.type,
    required this.status,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}


@JsonSerializable()
class Creator {
  final int id;
  final String name;
  final String? photo;

  Creator({
    required this.id,
    required this.name,
    required this.photo,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => _$CreatorFromJson(json);
  Map<String, dynamic> toJson() => _$CreatorToJson(this);
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


@JsonSerializable()
class Business {
  final int id;
  final String? name;
  final String? phone;
  final String? email;
  final String? logo;
  final String? address;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  Business({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    required this.logo,
    required this.photoUrl,
  });

  factory Business.fromJson(Map<String, dynamic> json) => _$BusinessFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessToJson(this);
}



@JsonSerializable()
class Store {
  final int id;
  final String? name;
  final String? phone;
  final String? address;

  Store({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
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

class ClientConverter implements JsonConverter<ClientInfo?, dynamic> {
  const ClientConverter();

  @override
  ClientInfo? fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ClientInfo.fromJson(json);
    } else if(json != Map<String, dynamic>){
      return null;
    }else {
      throw Exception('Unexpected type for data: ${json.runtimeType}');
    }
  }

  @override
  dynamic toJson(ClientInfo? object) => object?.toJson();
}

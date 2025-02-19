import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'money_adjustment_list_response_model.g.dart';

@JsonSerializable()
class MoneyAdjustmentListResponseModel {
  final bool success;
  @DataConverter()
  final DataWrapper? data;

  MoneyAdjustmentListResponseModel({required this.success, required this.data,});

  factory MoneyAdjustmentListResponseModel.fromJson(Map<String, dynamic> json) => _$MoneyAdjustmentListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$MoneyAdjustmentListResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  final List<MoneyAdjustmentData>? data;
  final Meta? meta;

  DataWrapper({this.data, this.meta});

  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class MoneyAdjustmentData {
  final int id;
  final String date;
  @JsonKey(name: 'sl_no')
  final String slNo;
  final Business? business;
  final Store? store;
  @JsonKey(name: 'creator')
  final Creator? creator;

  @JsonKey(name: 'payment_method')
  final ChartOfAccountPaymentMethod paymentMethod;
  final double amount;
  final String? remarks;

  MoneyAdjustmentData({
    required this.id,
    required this.date,
    required this.slNo,
    required this.amount,
    required this.creator,
    required this.business,
    this.remarks,
    required this.paymentMethod,
    required this.store,
  });

  factory MoneyAdjustmentData.fromJson(Map<String, dynamic> json) => _$MoneyAdjustmentDataFromJson(json);
  Map<String, dynamic> toJson() => _$MoneyAdjustmentDataToJson(this);
}

@JsonSerializable()
class Creator {
  final int id;
  final String name;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  Creator({
    required this.id,
    required this.name,
    required this.photoUrl,
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
  @JsonKey(name: 'currency_id')
  final int? currencyId;
  @JsonKey(name: 'owner_id')
  final int? ownerId;
  @JsonKey(name: 'time_zone')
  final String? timeZone;


  Business({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    required this.logo,
    required this.photoUrl,
    this.timeZone,
    this.currencyId,
    this.ownerId,
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

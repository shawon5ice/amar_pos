import 'package:amar_pos/core/core.dart';

class SupplierListResponseModel {
  SupplierListResponseModel({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data data;

  SupplierListResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    return _data;
  }
}



class Data {
  Data({
    required this.supplierList,
    required this.meta,

  });
  late final List<Supplier> supplierList;
  late final Meta meta;

  Data.fromJson(Map<String, dynamic> json){
    meta = Meta.fromJson(json['meta']);
    supplierList = List.from(json['data']).map((e)=>Supplier.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['meta'] = meta.toJson();
    _data['data'] = supplierList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Supplier {
  Supplier({
    required this.id,
    this.business,
    required this.name,
    this.code ,
    this.phone,
    this.address,
    this.openingBalance,
    this.photo,
    this.status = 0,
  });
  late final int id;
  late String? business;
  late final String name;
  late String? code ;
  late String? phone;
  late String? address;
  late int? openingBalance;
  late String? photo;
  late int status;

  Supplier.fromJson(Map<String, dynamic> json){
    id = json['id'];
    business = json['business'];
    name = json['name'];
    code  = json['code '];
    phone = json['phone'];
    address = json['address'];
    openingBalance = json['opening_balance'];
    photo = json['photo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['business'] = business;
    _data['name'] = name;
    _data['code '] = code ;
    _data['phone'] = phone;
    _data['address'] = address;
    _data['opening_balance'] = openingBalance;
    _data['photo'] = photo;
    _data['status'] = status;
    return _data;
  }
}
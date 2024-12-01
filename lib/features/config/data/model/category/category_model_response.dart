import 'package:amar_pos/core/core.dart';

class CategoryModelResponse {
  CategoryModelResponse({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data data;

  CategoryModelResponse.fromJson(Map<String, dynamic> json){
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
    required this.categoryList,
    required this.meta,
  });
  late final List<Category> categoryList;
  late final Meta meta;

  Data.fromJson(Map<String, dynamic> json){
    meta = Meta.fromJson(json['meta']);
    categoryList = List.from(json['data']).map((e)=>Category.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['meta'] = meta.toJson();
    _data['data'] = categoryList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Category {
  Category({
    required this.id,
    this.business,
    required this.name,
    this.logo,
    this.url,
  });
  late final int id;
  late final String? business;
  late final String name;
  late final String? logo;
  late final String? url;

  Category.fromJson(Map<String, dynamic> json){
    id = json['id'];
    business = json['business'];
    name = json['name'];
    logo = json['logo'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['business'] = business;
    _data['name'] = name;
    _data['logo'] = logo;
    _data['url'] = url;
    return _data;
  }
}
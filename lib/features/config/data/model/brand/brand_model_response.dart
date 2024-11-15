class BrandModelResponse {
  BrandModelResponse({
    required this.success,
    required this.brandList,
  });
  late final bool success;
  late final List<Brand> brandList;

  BrandModelResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    brandList = List.from(json['data']).map((e)=>Brand.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = brandList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Brand {
  Brand({
    required this.id,
    this.business,
    required this.name,
    this.description,
    this.url,
    required this.logo,
  });
  late final int id;
  late final String? business;
  late final String name;
  late final String? description;
  late final String? url;
  late final String logo;

  Brand.fromJson(Map<String, dynamic> json){
    id = json['id'];
    business = json['business'];
    name = json['name'];
    description = json['description'];
    url = json['url'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['business'] = business;
    _data['name'] = name;
    _data['description'] = description;
    _data['url'] = url;
    _data['logo'] = logo;
    return _data;
  }
}
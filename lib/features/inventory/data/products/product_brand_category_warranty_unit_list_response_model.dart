class ProductBrandCategoryWarrantyUnitListResponseModel {
  ProductBrandCategoryWarrantyUnitListResponseModel({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data data;

  ProductBrandCategoryWarrantyUnitListResponseModel.fromJson(Map<String, dynamic> json){
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
    required this.categories,
    required this.brands,
    required this.units,
    required this.warranties,
  });
  late final List<Categories> categories;
  late final List<Brands> brands;
  late final List<Units> units;
  late final List<Warranties> warranties;

  Data.fromJson(Map<String, dynamic> json){
    categories = List.from(json['categories']).map((e)=>Categories.fromJson(e)).toList();
    brands = List.from(json['brands']).map((e)=>Brands.fromJson(e)).toList();
    units = List.from(json['units']).map((e)=>Units.fromJson(e)).toList();
    warranties = List.from(json['warranties']).map((e)=>Warranties.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categories'] = categories.map((e)=>e.toJson()).toList();
    _data['brands'] = brands.map((e)=>e.toJson()).toList();
    _data['units'] = units.map((e)=>e.toJson()).toList();
    _data['warranties'] = warranties.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Categories {
  Categories({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Categories.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Brands {
  Brands({
    required this.id,
    required this.name,
    required this.logo,
  });
  late final int id;
  late final String name;
  late final String logo;

  Brands.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['logo'] = logo;
    return _data;
  }
}

class Units {
  Units({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Units.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Warranties {
  Warranties({
    required this.id,
    this.name,
  });
  late final int id;
  late final String? name;

  Warranties.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}
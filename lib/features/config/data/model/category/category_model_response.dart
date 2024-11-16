class CategoryModelResponse {
  CategoryModelResponse({
    required this.success,
    required this.categoryList,
  });
  late final bool success;
  late final List<Category> categoryList;

  CategoryModelResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    categoryList = List.from(json['data']).map((e)=>Category.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
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
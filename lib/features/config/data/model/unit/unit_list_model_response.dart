class UnitListModelResponse {
  UnitListModelResponse({
    required this.success,
    required this.unitList,
  });
  late final bool success;
  late final List<Unit> unitList;

  UnitListModelResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    unitList = List.from(json['data']).map((e)=>Unit.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = unitList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Unit {
  Unit({
    required this.id,
    required this.name,
    this.description,
    this.logo,
  });
  late final int id;
  late final String name;
  late final String? description;
  late final String? logo;

  Unit.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['logo'] = logo;
    return _data;
  }
}
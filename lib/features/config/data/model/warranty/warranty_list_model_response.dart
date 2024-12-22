class WarrantyListModelResponse {
  WarrantyListModelResponse({
    required this.success,
    required this.warrantyList,
  });
  late final bool success;
  late final List<Warranty> warrantyList;

  WarrantyListModelResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    warrantyList = List.from(json['data']).map((e)=>Warranty.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = warrantyList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Warranty {
  Warranty({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Warranty.fromJson(Map<String, dynamic> json){
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
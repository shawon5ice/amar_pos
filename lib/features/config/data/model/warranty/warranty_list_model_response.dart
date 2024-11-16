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
    required this.title,
    required this.description,
    required this.type,
    required this.count,
  });
  late final int id;
  late final String title;
  late final String description;
  late final String type;
  late final int count;

  Warranty.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['type'] = type;
    _data['count'] = count;
    return _data;
  }
}
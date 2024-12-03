class OutletListDDResponseModel {
  OutletListDDResponseModel({
    required this.success,
    required this.outletDDList,
  });
  late final bool success;
  late final List<OutletDD> outletDDList;

  OutletListDDResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    outletDDList = List.from(json['data']).map((e)=>OutletDD.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = outletDDList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class OutletDD {
  OutletDD({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  OutletDD.fromJson(Map<String, dynamic> json){
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
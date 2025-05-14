class OutletListModelResponse {
  OutletListModelResponse({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data? data;

  OutletListModelResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = json['data'] is Map ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.outletList,
    required this.meta,
  });
  late final List<Outlet> outletList;
  late final Meta meta;

  Data.fromJson(Map<String, dynamic> json){
    outletList = List.from(json['data']).map((e)=>Outlet.fromJson(e)).toList();
    meta = Meta.fromJson(json['meta']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = outletList.map((e)=>e.toJson()).toList();
    _data['meta'] = meta.toJson();
    return _data;
  }
}

class Outlet {
  Outlet({
    required this.id,
    required this.business,
    required this.name,
    required this.code,
    required this.phone,
    required this.address,
    required this.bkash,
    required this.nagad,
    required this.status,
    required this.isDefault,
  });
  late final int id;
  late final String business;
  late final String name;
  late final String code;
  late final String phone;
  late final String address;
  late final String bkash;
  late final String nagad;
  late int status;
  late final int isDefault;

  Outlet.fromJson(Map<String, dynamic> json){
    id = json['id'];
    business = json['business'];
    name = json['name'];
    code = json['code'];
    phone = json['phone'];
    address = json['address'];
    bkash = json['bkash'] ?? '';
    nagad = json['nagad'] ?? '';
    status = json['status'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['business'] = business;
    _data['name'] = name;
    _data['code'] = code;
    _data['phone'] = phone;
    _data['address'] = address;
    _data['bkash'] = bkash;
    _data['nagad'] = nagad;
    _data['status'] = status;
    _data['is_default'] = isDefault;
    return _data;
  }
}

class Meta {
  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });
  late final int? currentPage;
  late final int? from;
  late final int lastPage;
  late final String? path;
  late final int perPage;
  late final int? to;
  late final int total;

  Meta.fromJson(Map<String, dynamic> json){
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['current_page'] = currentPage;
    _data['from'] = from;
    _data['last_page'] = lastPage;
    _data['path'] = path;
    _data['per_page'] = perPage;
    _data['to'] = to;
    _data['total'] = total;
    return _data;
  }
}
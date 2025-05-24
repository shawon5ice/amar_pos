class ClientListModelResponse {
  ClientListModelResponse({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data? data;

  ClientListModelResponse.fromJson(Map<String, dynamic> json){
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
    required this.clientList,
    required this.meta,
  });
  late final List<Client> clientList;
  late final Meta meta;

  Data.fromJson(Map<String, dynamic> json){
    clientList = List.from(json['data']).map((e)=>Client.fromJson(e)).toList();
    meta = Meta.fromJson(json['meta']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = clientList.map((e)=>e.toJson()).toList();
    _data['meta'] = meta.toJson();
    return _data;
  }
}

class Client {
  Client({
    required this.id,
    required this.clientNo,
    required this.name,
    required this.phone,
    required this.address,
    required this.openingBalance,
    required this.status,
  });
  late final int id;
  late final String clientNo;
  late final String name;
  late final String phone;
  late final String address;
  late final int openingBalance;
  late int status;

  Client.fromJson(Map<String, dynamic> json){
    id = json['id'];
    clientNo = json['client_no'];
    name = json['name'];
    phone = json['phone'];
    address = json['address']??'';
    openingBalance = json['opening_balance'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['client_no'] = clientNo;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['address'] = address;
    _data['opening_balance'] = openingBalance;
    _data['status'] = status;
    return _data;
  }
}

class Meta {
  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
  late final int currentPage;
  late final int lastPage;
  late final int perPage;
  late final int total;

  Meta.fromJson(Map<String, dynamic> json){
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['current_page'] = currentPage;
    _data['last_page'] = lastPage;
    _data['per_page'] = perPage;
    _data['total'] = total;
    return _data;
  }
}
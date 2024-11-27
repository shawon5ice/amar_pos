class CustomerLstModelResponse {
  CustomerLstModelResponse({
    required this.success,
    required this.customerList,
  });
  late final bool success;
  late final List<Customer> customerList;

  CustomerLstModelResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    customerList = List.from(json['data']).map((e)=>Customer.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = customerList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Customer {
  Customer({
    required this.id,
    required this.business,
    required this.name,
    required this.phone,
    required this.address,
  });
  late final int id;
  late final String business;
  late final String name;
  late final String phone;
  late final String address;

  Customer.fromJson(Map<String, dynamic> json){
    id = json['id'];
    business = json['business'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['business'] = business;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['address'] = address;
    return _data;
  }
}
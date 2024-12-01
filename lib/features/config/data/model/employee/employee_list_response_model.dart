class EmployeeListModelResponse {
  EmployeeListModelResponse({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data data;

  EmployeeListModelResponse.fromJson(Map<String, dynamic> json){
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
    required this.employeeList,
    required this.meta,
  });
  late final List<Employee> employeeList;
  late final Meta meta;

  Data.fromJson(Map<String, dynamic> json){
    employeeList = List.from(json['data']).map((e)=>Employee.fromJson(e)).toList();
    meta = Meta.fromJson(json['meta']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = employeeList.map((e)=>e.toJson()).toList();
    _data['meta'] = meta.toJson();
    return _data;
  }
}

class Employee {
  Employee({
    required this.id,
    required this.business,
    required this.store,
    required this.name,
    required this.phone,
    this.email,
    required this.address,
    this.allowLogin,
    this.dob,
    this.gender,
    this.maritalStatus,
    this.bloodGroup,
    required this.photo,
    this.status,
  });
  late final int id;
  late final String business;
  late final String store;
  late final String name;
  late final String phone;
  late final String? email;
  late final String address;
  late final String? allowLogin;
  late final String? dob;
  late final String? gender;
  late final String? maritalStatus;
  late final String? bloodGroup;
  late final String photo;
  late final int? status;

  Employee.fromJson(Map<String, dynamic> json){
    id = json['id'];
    business = json['business'];
    store = json['store'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    allowLogin = json['allow_login'];
    dob = json['dob'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    bloodGroup = json['blood_group'];
    photo = json['photo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['business'] = business;
    _data['store'] = store;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['address'] = address;
    _data['allow_login'] = allowLogin;
    _data['dob'] = dob;
    _data['gender'] = gender;
    _data['marital_status'] = maritalStatus;
    _data['blood_group'] = bloodGroup;
    _data['photo'] = photo;
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
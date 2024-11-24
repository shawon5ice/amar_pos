class EmployeeListResponseModel {
  EmployeeListResponseModel({
    required this.success,
    required this.employeeList,
  });
  late final bool success;
  late final List<Employee> employeeList;

  EmployeeListResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    employeeList = List.from(json['data']).map((e)=>Employee.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = employeeList.map((e)=>e.toJson()).toList();
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
    required this.email,
    required this.address,
    required this.allowLogin,
    required this.dob,
    required this.gender,
    required this.maritalStatus,
    required this.bloodGroup,
    required this.photo,
    required this.status,
  });
  late final int id;
  late final String business;
  late final String store;
  late final String name;
  late final String phone;
  late final String email;
  late final String address;
  late final String allowLogin;
  late final String dob;
  late final String gender;
  late final String maritalStatus;
  late final String bloodGroup;
  late final String photo;
  late final int status;

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
class SignInResponseModel {
  SignInResponseModel({
    required this.success,
    required this.userInfo,
    required this.message,
  });
  late final bool success;
  late final UserInfo userInfo;
  late final String message;

  SignInResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    userInfo = UserInfo.fromJson(json['data']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = userInfo.toJson();
    _data['message'] = message;
    return _data;
  }
}

class UserInfo {
  UserInfo({
    required this.token,
    required this.name,
    required this.email,
    required this.phone,
    required this.designation,
    required this.departmentId,
    required this.photo,
  });
  late final String token;
  late final String name;
  late final String email;
  late final String phone;
  late final String designation;
  late final int departmentId;
  late String photo;

  UserInfo.fromJson(Map<String, dynamic> json){
    token = json['token'];
    name = json['name'];
    email = json['email']??'';
    phone = json['phone']??'';
    departmentId = json['department_id']??-1;
    designation = json['designation'];
    photo = json['photo']??'';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['name'] = name;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['designation'] = designation;
    _data['department_id'] = departmentId;
    _data['photo'] = photo;
    return _data;
  }
}
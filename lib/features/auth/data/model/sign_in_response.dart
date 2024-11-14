class SignInResponse {
  SignInResponse({
    required this.success,
    required this.loginData,
    required this.message,
  });
  late final bool success;
  late final LoginData loginData;
  late final String message;

  SignInResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    loginData = LoginData.fromJson(json['data']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = loginData.toJson();
    _data['message'] = message;
    return _data;
  }
}

class LoginData {
  LoginData({
    required this.token,
    required this.name,
    required this.status,
    required this.email,
    required this.phone,
    required this.business,
    required this.subscription,
    required this.address,
    required this.permissions,
  });
  late final String token;
  late final String name;
  late final String status;
  late final String email;
  late final String phone;
  late final Business business;
  late final Subscription subscription;
  late final String address;
  late final List<String> permissions;

  LoginData.fromJson(Map<String, dynamic> json){
    token = json['token'];
    name = json['name'];
    status = json['status'];
    email = json['email'];
    phone = json['phone'];
    business = Business.fromJson(json['business']);
    subscription = Subscription.fromJson(json['subscription']);
    address = json['address'];
    permissions = List.castFrom<dynamic, String>(json['permissions']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['name'] = name;
    _data['status'] = status;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['business'] = business.toJson();
    _data['subscription'] = subscription.toJson();
    _data['address'] = address;
    _data['permissions'] = permissions;
    return _data;
  }
}

class Business {
  Business({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.logo,
    required this.address,
    required this.currencyId,
    required this.ownerId,
    required this.timeZone,
    required this.photoUrl,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final String email;
  late final Null logo;
  late final String address;
  late final int currencyId;
  late final int ownerId;
  late final String timeZone;
  late final String photoUrl;

  Business.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logo = null;
    address = json['address'];
    currencyId = json['currency_id'];
    ownerId = json['owner_id'];
    timeZone = json['time_zone'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['logo'] = logo;
    _data['address'] = address;
    _data['currency_id'] = currencyId;
    _data['owner_id'] = ownerId;
    _data['time_zone'] = timeZone;
    _data['photo_url'] = photoUrl;
    return _data;
  }
}

class Subscription {
  Subscription({
    required this.slNo,
    required this.businessId,
    required this.packageId,
    required this.startDate,
    required this.endDate,
    this.trialEndDate,
    required this.packagePrice,
    this.packageDetails,
    this.paymentMethod,
    required this.paymentStatus,
    this.transactionId,
  });
  late final String slNo;
  late final int businessId;
  late final int packageId;
  late final String startDate;
  late final String endDate;
  late final Null trialEndDate;
  late final int packagePrice;
  late final Null packageDetails;
  late final Null paymentMethod;
  late final int paymentStatus;
  late final Null transactionId;

  Subscription.fromJson(Map<String, dynamic> json){
    slNo = json['sl_no'];
    businessId = json['business_id'];
    packageId = json['package_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    trialEndDate = null;
    packagePrice = json['package_price'];
    packageDetails = null;
    paymentMethod = null;
    paymentStatus = json['payment_status'];
    transactionId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sl_no'] = slNo;
    _data['business_id'] = businessId;
    _data['package_id'] = packageId;
    _data['start_date'] = startDate;
    _data['end_date'] = endDate;
    _data['trial_end_date'] = trialEndDate;
    _data['package_price'] = packagePrice;
    _data['package_details'] = packageDetails;
    _data['payment_method'] = paymentMethod;
    _data['payment_status'] = paymentStatus;
    _data['transaction_id'] = transactionId;
    return _data;
  }
}
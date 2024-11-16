import 'package:hive/hive.dart';

part 'login_data.g.dart';

@HiveType(typeId: 1)
class LoginData extends HiveObject {

  @HiveField(0)
  String token;

  @HiveField(1)
  String name;

  @HiveField(2)
  String status;

  @HiveField(3)
  String email;

  @HiveField(4)
  String phone;

  @HiveField(5)
  Business business;

  // @HiveField(6)
  // Subscription subscription;

  @HiveField(6)
  String address;

  @HiveField(7)
  List<String> permissions;

  LoginData({
    required this.token,
    required this.name,
    required this.status,
    required this.email,
    required this.phone,
    required this.business,
    // required this.subscription,
    required this.address,
    required this.permissions,
  });


  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'],
      name: json['name'],
      status: json['status']??'--',
      email: json['email']??'--',
      phone: json['phone']??'--',
      business: Business.fromJson(json['business']),
      // subscription: Subscription.fromJson(json['subscription']),
      address: json['address'],
      permissions: List<String>.from(json['permissions']),
    );
  }

}

@HiveType(typeId: 2)
class Business extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String email;

  @HiveField(4)
  String? logo;

  @HiveField(5)
  String address;

  @HiveField(6)
  int currencyId;

  @HiveField(7)
  int ownerId;

  @HiveField(8)
  String timeZone;

  @HiveField(9)
  String photoUrl;

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

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name']??'--',
      phone: json['phone']??'--',
      email: json['email']??'--',
      logo: json['logo']??'--',
      address: json['address']??'--',
      currencyId: json['currency_id']??-1,
      ownerId: json['owner_id']??-1,
      timeZone: json['time_zone']??'--',
      photoUrl: json['photo_url']??'--',
    );
  }

}

@HiveType(typeId: 3)
class Subscription extends HiveObject {
  @HiveField(0)
  String slNo;

  @HiveField(1)
  int businessId;

  @HiveField(2)
  int packageId;

  @HiveField(3)
  String startDate;

  @HiveField(4)
  String endDate;

  @HiveField(5)
  int packagePrice;

  @HiveField(6)
  int paymentStatus;

  Subscription({
    required this.slNo,
    required this.businessId,
    required this.packageId,
    required this.startDate,
    required this.endDate,
    required this.packagePrice,
    required this.paymentStatus,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      slNo: json['sl_no'],
      businessId: json['business_id']??-1,
      packageId: json['package_id']??-1,
      startDate: json['start_date']??'--',
      endDate: json['end_date']??'--',
      packagePrice: json['package_price']??-1,
      paymentStatus: json['payment_status']??-1,
    );
  }

}

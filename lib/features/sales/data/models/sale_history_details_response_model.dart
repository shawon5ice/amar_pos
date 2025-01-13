class SaleHistoryDetailsResponseModel {
  SaleHistoryDetailsResponseModel({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data data;

  SaleHistoryDetailsResponseModel.fromJson(Map<String, dynamic> json){
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
    required this.id,
    required this.dateTime,
    required this.orderNo,
    required this.saleType,
    required this.customer,
    required this.soldBy,
    required this.serviceBy,
    required this.subTotal,
    required this.discount,
    required this.vat,
    required this.expense,
    required this.payable,
    required this.business,
    required this.store,
    required this.orderDetails,
    required this.paymentDetails,
    required this.changeAmount,
  });
  late final int id;
  late final String dateTime;
  late final String orderNo;
  late final String saleType;
  late final Customer customer;
  late final String soldBy;
  late final ServiceBy serviceBy;
  late final num subTotal;
  late final num discount;
  late final num vat;
  late final num expense;
  late final num payable;
  late final Business business;
  late final Store store;
  late final List<OrderDetails> orderDetails;
  late final List<PaymentDetails> paymentDetails;
  late final int changeAmount;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    dateTime = json['date_time'];
    orderNo = json['order_no'];
    saleType = json['sale_type'];
    customer = Customer.fromJson(json['customer']);
    soldBy = json['sold_by'];
    serviceBy = json['service_by'] is Map ? ServiceBy.fromJson(json['service_by']) : ServiceBy(id: -1, name: "--", email: "", phone: "", photoUrl: "");
    subTotal = json['sub_total'] ?? 0;
    discount = json['discount'] ?? 0;
    vat = json['vat'] ?? 0;
    expense = json['expense'] ?? 0;
    payable = json['payable'] ?? 0;
    business = Business.fromJson(json['business']);
    store = Store.fromJson(json['store']);
    orderDetails = List.from(json['order_details']).map((e)=>OrderDetails.fromJson(e)).toList();
    paymentDetails = List.from(json['payment_details']).map((e)=>PaymentDetails.fromJson(e)).toList();
    changeAmount = json['change_amount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['date_time'] = dateTime;
    _data['order_no'] = orderNo;
    _data['sale_type'] = saleType;
    _data['customer'] = customer.toJson();
    _data['sold_by'] = soldBy;
    _data['service_by'] = serviceBy.toJson();
    _data['sub_total'] = subTotal;
    _data['discount'] = discount;
    _data['vat'] = vat;
    _data['expense'] = expense;
    _data['payable'] = payable;
    _data['business'] = business.toJson();
    _data['store'] = store.toJson();
    _data['order_details'] = orderDetails.map((e)=>e.toJson()).toList();
    _data['payment_details'] = paymentDetails.map((e)=>e.toJson()).toList();
    _data['change_amount'] = changeAmount;
    return _data;
  }
}

class Customer {
  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final String address;

  Customer.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['address'] = address;
    return _data;
  }
}

class ServiceBy {
  ServiceBy({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
  });
  late final int id;
  late final String name;
  late final String email;
  late final String phone;
  late final String photoUrl;

  ServiceBy.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['photo_url'] = photoUrl;
    return _data;
  }
}

class Business {
  Business({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.logo,
    required this.address,
    required this.photoUrl,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final Null email;
  late final String logo;
  late final String address;
  late final String photoUrl;

  Business.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = null;
    logo = json['logo'];
    address = json['address'];
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
    _data['photo_url'] = photoUrl;
    return _data;
  }
}

class Store {
  Store({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final String address;

  Store.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['address'] = address;
    return _data;
  }
}

class OrderDetails {
  OrderDetails({
    required this.detailsId,
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.vat,
    required this.vatPercent,
    required this.snNo,
  });
  late final int detailsId;
  late final int id;
  late final String name;
  late final int quantity;
  late final int unitPrice;
  late final int totalPrice;
  late final int vat;
  late final int vatPercent;
  late final List<SnNo> snNo;

  OrderDetails.fromJson(Map<String, dynamic> json){
    detailsId = json['details_id'];
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'];
    totalPrice = json['total_price'];
    vat = json['vat'];
    vatPercent = json['vat_percent'];
    snNo = List.from(json['sn_no']).map((e)=>SnNo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['details_id'] = detailsId;
    _data['id'] = id;
    _data['name'] = name;
    _data['quantity'] = quantity;
    _data['unit_price'] = unitPrice;
    _data['total_price'] = totalPrice;
    _data['vat'] = vat;
    _data['vat_percent'] = vatPercent;
    _data['sn_no'] = snNo.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class SnNo {
  SnNo({
    required this.id,
    required this.serialNo,
  });
  late final int id;
  late final String serialNo;

  SnNo.fromJson(Map<String, dynamic> json){
    id = json['id'];
    serialNo = json['serial_no'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['serial_no'] = serialNo;
    return _data;
  }
}

class PaymentDetails {
  PaymentDetails({
    required this.id,
    required this.orderPaymentId,
    required this.name,
    required this.amount,
    required this.details,
    this.bank,
  });
  late final int id;
  late final int orderPaymentId;
  late final String name;
  late final int amount;
  late final List<Details> details;
  late final Bank? bank;

  PaymentDetails.fromJson(Map<String, dynamic> json){
    id = json['id'];
    orderPaymentId = json['order_payment_id'];
    name = json['name'];
    amount = json['amount'];
    details = List.from(json['details']).map((e)=>Details.fromJson(e)).toList();
    bank = json['bank'] is Map ? Bank.fromJson(json['bank']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['order_payment_id'] = orderPaymentId;
    _data['name'] = name;
    _data['amount'] = amount;
    _data['details'] = details.map((e)=>e.toJson()).toList();
    _data['bank'] = bank?.toJson();
    return _data;
  }
}

class Details {
  Details({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Details.fromJson(Map<String, dynamic> json){
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

class Bank {
  Bank({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Bank.fromJson(Map<String, dynamic> json){
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
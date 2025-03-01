class PurchaseOrderDetailsResponseModel {
  PurchaseOrderDetailsResponseModel({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data data;

  PurchaseOrderDetailsResponseModel.fromJson(Map<String, dynamic> json){
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
    required this.purchaseType,
    required this.supplier,
    required this.createdBy,
    required this.subTotal,
    required this.expense,
    required this.payable,
    required this.business,
    required this.details,
    required this.paymentDetails,
    required this.dueAmount,
    required this.discount,
  });
  late final int id;
  late final String dateTime;
  late final String orderNo;
  late final String purchaseType;
  late final Supplier supplier;
  late final String createdBy;
  late final int subTotal;
  late final int expense;
  late final int payable;
  late final Business business;
  late final List<Details> details;
  late final List<PaymentDetails> paymentDetails;
  late final int dueAmount;
  late final int discount;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    dateTime = json['date_time'];
    orderNo = json['order_no'];
    purchaseType = json['purchase_type'];
    supplier = Supplier.fromJson(json['supplier']);
    createdBy = json['created_by'];
    subTotal = json['sub_total'];
    expense = json['expense'];
    payable = json['payable'];
    business = Business.fromJson(json['business']);
    details = List.from(json['details']).map((e)=>Details.fromJson(e)).toList();
    paymentDetails = List.from(json['payment_details']).map((e)=>PaymentDetails.fromJson(e)).toList();
    dueAmount = json['due_amount'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['date_time'] = dateTime;
    _data['order_no'] = orderNo;
    _data['purchase_type'] = purchaseType;
    _data['supplier'] = supplier.toJson();
    _data['created_by'] = createdBy;
    _data['sub_total'] = subTotal;
    _data['expense'] = expense;
    _data['payable'] = payable;
    _data['business'] = business.toJson();
    _data['details'] = details.map((e)=>e.toJson()).toList();
    _data['payment_details'] = paymentDetails.map((e)=>e.toJson()).toList();
    _data['due_amount'] = dueAmount;
    _data['discount'] = discount;
    return _data;
  }
}

class Supplier {
  Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final String address;

  Supplier.fromJson(Map<String, dynamic> json){
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

class Details {
  Details({
    required this.id,
    required this.lineId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    required this.snNo,
  });
  late final int id;
  late final int lineId;
  late final String name;
  late final int quantity;
  late final int unitPrice;
  late final int total;
  late final List<String>? snNo;

  Details.fromJson(Map<String, dynamic> json){
    id = json['id'];
    lineId = json['line_id'];
    name = json['name'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'];
    total = json['total'];
    snNo = List.from(json['sn_no']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['line_id'] = lineId;
    _data['name'] = name;
    _data['quantity'] = quantity;
    _data['unit_price'] = unitPrice;
    _data['total'] = total;
    _data['sn_no'] = snNo;
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
  late final List<dynamic> details;
  late final Bank? bank;

  PaymentDetails.fromJson(Map<String, dynamic> json){
    id = json['id'];
    orderPaymentId = json['order_payment_id'];
    name = json['name'];
    amount = json['amount'];
    details = List.castFrom<dynamic, dynamic>(json['details']);
    bank = json['bank'] is Map? Bank.fromJson(json['bank']) : null ;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['order_payment_id'] = orderPaymentId;
    _data['name'] = name;
    _data['amount'] = amount;
    _data['details'] = details;
    _data['bank'] = bank;
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
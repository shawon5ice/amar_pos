class ClientListResponseModel {
  final bool success;
  final List<ClientData> data;

  ClientListResponseModel({
    required this.success,
    required this.data,
  });

  factory ClientListResponseModel.fromJson(Map<String, dynamic> json) {
    return ClientListResponseModel(
      success: json['success'],
      data: (json['data'] as List<dynamic>)
          .map((item) => ClientData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ClientData {
  final int id;
  final String clientNo;
  final String name;
  final String phone;
  final String address;
  final int openingBalance;
  final int previousDue;
  final int status;

  ClientData({
    required this.id,
    required this.clientNo,
    required this.name,
    required this.phone,
    required this.address,
    required this.openingBalance,
    required this.previousDue,
    required this.status,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      id: json['id'],
      clientNo: json['client_no'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      openingBalance: json['opening_balance'],
      previousDue: json['previous_due'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_no': clientNo,
      'name': name,
      'phone': phone,
      'address': address,
      'opening_balance': openingBalance,
      'previous_due': previousDue,
      'status': status,
    };
  }
}

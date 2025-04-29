class PosInvoiceModel {
  final String storeName;
  final String storeAddress;
  final String storePhone;
  final String invoiceDate;
  final String invoiceNo;
  final String customerName;
  final String customerPhone;
  final String? customerAddress;
  final List<PosProduct> products;
  final num vat;
  final num subTotal;
  final num discount;
  final num additionalCharge;


  PosInvoiceModel({
    required this.storeName,
    required this.storeAddress,
    required this.storePhone,
    required this.invoiceDate,
    required this.invoiceNo,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.products,
    required this.vat,
    required this.discount,
    required this.additionalCharge,
    required this.subTotal,
  });


  // Convert PosInvoiceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'storeAddress': storeAddress,
      'storePhone': storePhone,
      'invoiceDate': invoiceDate,
      'invoiceNo': invoiceNo,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'additionalCharge': additionalCharge,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  // Convert JSON to PosInvoiceModel
  factory PosInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PosInvoiceModel(
      storeName: json['storeName'],
      storeAddress: json['storeAddress'],
      storePhone: json['storePhone'],
      invoiceDate: json['invoiceDate'],
      invoiceNo: json['invoiceNo'],
      additionalCharge: json['additionalCharge'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      vat: json['vat'],
      discount: json['discount'],
      subTotal: json['subTotal'],
      products: (json['products'] as List)
          .map((productJson) => PosProduct.fromJson(productJson))
          .toList(),
    );
  }
}

class PosProduct {
  final String name;
  final int qty;
  final num unitPrice;
  final num subTotal;

  PosProduct({
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.subTotal,
  });

  // Convert PosProduct to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'unitPrice': unitPrice,
      'subTotal': subTotal,
    };
  }

  // Convert JSON to PosProduct
  factory PosProduct.fromJson(Map<String, dynamic> json) {
    return PosProduct(
      name: json['name'],
      qty: json['qty'],
      unitPrice: json['unitPrice'],
      subTotal: json['subTotal'],
    );
  }
}

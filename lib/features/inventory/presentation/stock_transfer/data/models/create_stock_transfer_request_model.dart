
class CreateStockTransferRequestModel {
  int storeId;
  int type;
  String remarks;
  List<StockTransferProduct> products;

  CreateStockTransferRequestModel({
    required this.storeId,
    required this.type,
    required this.products,
    required this.remarks,
  });

  CreateStockTransferRequestModel.defaultConstructor()
      : storeId = -1,
        type = 1,
        remarks = "",
        products = [];

  factory CreateStockTransferRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateStockTransferRequestModel(
      storeId: json['store_id'],
      type: json['type'],
      remarks: json['remarks'],
      products: (json['product'] as List)
          .map((productJson) => StockTransferProduct.fromJson(productJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'type' : type,
      'remarks' : remarks,
      'product': products.map((product) => product.toJson()).toList(),
    };
  }
}

class StockTransferProduct {
  int id;
  int quantity;
  List<String> serialNo;

  StockTransferProduct({
    required this.id,
    required this.quantity,
    required this.serialNo,
  });

  factory StockTransferProduct.fromJson(Map<String, dynamic> json) {
    return StockTransferProduct(
      id: json['id'],
      quantity: json['quantity'],
      serialNo: json['serial_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'serial_no': serialNo.isEmpty ? null : serialNo,
    };
  }
}
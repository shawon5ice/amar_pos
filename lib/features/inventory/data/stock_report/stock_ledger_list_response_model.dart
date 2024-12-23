class StockLedgerListResponseModel {
  StockLedgerListResponseModel({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data data;

  StockLedgerListResponseModel.fromJson(Map<String, dynamic> json){
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
    required this.stockLedgerList,
    required this.pagination,
  });
  late final List<StockLedger> stockLedgerList;
  late final Pagination pagination;

  Data.fromJson(Map<String, dynamic> json){
    stockLedgerList = List.from(json['data']).map((e)=>StockLedger.fromJson(e)).toList();
    pagination = Pagination.fromJson(json['pagination']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = stockLedgerList.map((e)=>e.toJson()).toList();
    _data['pagination'] = pagination.toJson();
    return _data;
  }
}

class StockLedger {
  StockLedger({
    required this.id,
    this.date,
    this.invoiceNo,
    this.clientName,
    this.stockIn,
    this.stockOut,
    this.balanceStock,
    this.status,
    this.createdBy,
  });
  late final String id;
  late final String? date;
  late final String? invoiceNo;
  late final String? clientName;
  late final int? stockIn;
  late final int? stockOut;
  late final int? balanceStock;
  late final String? status;
  late final String? createdBy;

  StockLedger.fromJson(Map<String, dynamic> json){
    id = json['id'];
    date = json['date'];
    invoiceNo = json['invoice_no'];
    clientName = json['client_name'];
    stockIn = json['stock_in'];
    stockOut = json['stock_out'];
    balanceStock = json['balance_stock'];
    status = json['status'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['date'] = date;
    _data['invoice_no'] = invoiceNo;
    _data['client_name'] = clientName;
    _data['stock_in'] = stockIn;
    _data['stock_out'] = stockOut;
    _data['balance_stock'] = balanceStock;
    _data['status'] = status;
    _data['created_by'] = createdBy;
    return _data;
  }
}

class Pagination {
  Pagination({
    required this.total,
    required this.perPage,
    required this.lastPage,
  });
  late final int total;
  late final int perPage;
  late final int lastPage;

  Pagination.fromJson(Map<String, dynamic> json){
    total = json['total'];
    perPage = json['per_page'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total'] = total;
    _data['per_page'] = perPage;
    _data['last_page'] = lastPage;
    return _data;
  }
}
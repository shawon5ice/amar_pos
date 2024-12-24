import 'package:amar_pos/core/data/model/product_model.dart';

class ProductListDDResponseModel {
  ProductListDDResponseModel({
    required this.success,
    required this.productDDList,
  });
  late final bool success;
  late final List<ProductModel> productDDList;

  ProductListDDResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    productDDList = List.from(json['data']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = productDDList.map((e)=>e.toJson()).toList();
    return _data;
  }
}
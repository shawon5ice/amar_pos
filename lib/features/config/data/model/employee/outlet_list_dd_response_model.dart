import 'package:amar_pos/core/data/model/outlet_model.dart';

class OutletListDDResponseModel {
  OutletListDDResponseModel({
    required this.success,
    required this.outletDDList,
  });
  late final bool success;
  late final List<OutletModel> outletDDList;

  OutletListDDResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    outletDDList = List.from(json['data']).map((e)=>OutletModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = outletDDList.map((e)=>e.toJson()).toList();
    return _data;
  }
}
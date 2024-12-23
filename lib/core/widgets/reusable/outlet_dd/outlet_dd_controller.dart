import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/features/config/data/model/employee/outlet_list_dd_response_model.dart';
import 'package:get/get.dart';

import '../../../../features/auth/data/model/hive/login_data.dart';
import '../../../../features/auth/data/model/hive/login_data_helper.dart';
import '../../../data/model/outlet_model.dart';
import '../../../network/base_client.dart';
import '../../../network/network_strings.dart';

class OutletDDController extends GetxController{
  LoginData? loginData = LoginDataBoxManager().loginData;

  bool outletListLoading = false;
  List<OutletModel> outlets = [];

  @override
  void onReady() {
    getAllOutlet();
    super.onReady();
  }

  void getAllOutlet() async {
    outletListLoading = true;
    logger.e("GETTING OUTLET");
    update(['outlet_dd']);
    var response = await BaseClient.getData(
      token: loginData!.token,
      api: NetWorkStrings.getAllOutletsDD,
    );

    if(response != null && response['success']){
      OutletListDDResponseModel outletListDDResponseModel = OutletListDDResponseModel.fromJson(response);
      outlets = outletListDDResponseModel.outletDDList;
    }

    outletListLoading = false;
    update(['outlet_dd']);
  }

}